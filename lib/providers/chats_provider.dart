import 'package:chatgpt_mobile_app/models/chat_model.dart';
import 'package:chatgpt_mobile_app/services/api_services.dart';
import 'package:flutter/material.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMsg({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 1));
    notifyListeners();
  }

  Future<void> sendMsgAndGetAnswers(
      {required String msg, required String modelId}) async {
    // Convert chatList to the format expected by the API
    List<Map<String, String>> formattedHistory = chatList.map((chatModel) {
      // Assuming all messages in chatList are from the user; adjust if necessary
      return {"role": "user", "content": chatModel.msg};
    }).toList();

    // Add the current message to the history before sending
    formattedHistory.add({"role": "user", "content": msg});

    // Call the API
    var responseMessages = await ApiService.sendMessage(
      message: msg,
      modelId: modelId,
      conversationHistory: formattedHistory,
    );

    // Assuming the response is a list of ChatModel instances,
    // which represent messages from the system.
    if (responseMessages.isNotEmpty) {
      chatList.addAll(responseMessages);
      notifyListeners();
    }
  }
}
