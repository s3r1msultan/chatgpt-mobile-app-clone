import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_mobile_app/constants/api_constants.dart';
import 'package:chatgpt_mobile_app/models/chat_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // static Future<List<ModelsModel>> getModels() async {
  //   try {
  //     var res = await http.get(Uri.parse('$BASE_URL/models'), headers: {
  //       "Authorization": "Bearer $API_KEY",
  //     });

  //     Map jsonResponse = jsonDecode(res.body);
  //     if (jsonResponse['error'] != null) {
  //       log("ERROR: ${jsonResponse['error']['message']}");
  //       throw HttpException(jsonResponse['error']['message']);
  //     }
  //     // print(jsonResponse);
  //     List temp = [];
  //     for (var value in jsonResponse['data']) {
  //       temp.add(value);
  //       // log("temp ${value}");
  //     }
  //     return ModelsModel.modelFromSnapshot(temp);
  //   } catch (error) {
  //     log("error $error");
  //     rethrow;
  //   }
  // }

  // sending a message

  static Future<List<ChatModel>> sendMessage(
      {required String message,
      required String modelId,
      required List<Map<String, String>> conversationHistory}) async {
    try {
      conversationHistory.add({"role": "user", "content": message});

      var res = await http.post(
        Uri.parse('$BASE_URL/chat/completions'),
        headers: {
          "Authorization": "Bearer $API_KEY",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "model": modelId,
          "messages": conversationHistory,
        }),
      );

      Map jsonResponse = jsonDecode(res.body);
      if (jsonResponse['error'] != null) {
        log("ERROR: ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }

      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // Assuming the response structure, you may need to adjust based on actual API response
        chatList = List.generate(jsonResponse["choices"].length,
            (index) => ChatModel.fromJson(jsonResponse["choices"][index]));
      }

      // Optionally, update the conversation history based on the response.
      // This logic will depend on how you want to structure conversation history.
      // For example, you might add system responses to it here.

      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
