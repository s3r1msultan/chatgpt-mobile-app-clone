import 'dart:developer';
import 'package:chatgpt_mobile_app/constants/cosntants.dart';
import 'package:chatgpt_mobile_app/providers/chats_provider.dart';
import 'package:chatgpt_mobile_app/providers/models_provider.dart';
import 'package:chatgpt_mobile_app/services/assets_manager.dart';
import 'package:chatgpt_mobile_app/widgets/chat_widget.dart';
import 'package:chatgpt_mobile_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isTyping = false;

  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController _listScrollController;

  @override
  void initState() {
    _listScrollController = ScrollController();
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const TextWidget(
          label: "ChatGPT",
          fontSize: 20,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         await Services.showModalSheet(context: context);
        //       },
        //       icon: const Icon(
        //         Icons.more_vert_rounded,
        //         color: Colors.white,
        //       ))
        // ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Flexible(
            child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatsProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                      msg: chatsProvider.getChatList[index].msg,
                      chatIndex: chatsProvider.chatList[index].chatIndex);
                }),
          ),
          if (isTyping) ...[
            const SpinKitThreeBounce(
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(
              height: 15,
            ),
          ] else ...[
            const SizedBox(
              height: 6,
            )
          ],
          // const SizedBox(
          //   height: 8,
          // ),
          Material(
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      style: const TextStyle(color: Colors.white),
                      controller: textEditingController,
                      onSubmitted: (value) async {
                        log(value);
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatsProvider: chatsProvider);
                      },
                      decoration: const InputDecoration.collapsed(
                          hintText: "How can I help you?",
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatsProvider: chatsProvider);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.grey,
                      ))
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void scrollToTheEnd() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatsProvider chatsProvider}) async {
    if (isTyping) {
      return;
    }
    if (textEditingController.text.isEmpty) {
      return;
    }
    try {
      String messageContent = textEditingController.text;
      setState(() {
        isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 1));
        chatsProvider.addUserMsg(msg: messageContent);
        textEditingController.clear();
        focusNode.unfocus();
      });
      // chatList.addAll(await ApiService.sendMessage(
      //     message: messageContent, modelId: modelsProvider.getCurrentModel));
      await chatsProvider.sendMsgAndGetAnswers(
          msg: messageContent, modelId: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (e) {
      log("Error with sending a message: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: e.toString()),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollToTheEnd();
        isTyping = false;
      });
    }
  }
}
