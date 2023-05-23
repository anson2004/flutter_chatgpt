import 'package:chatcptapp/models/chat_model.dart';
import 'package:flutter/material.dart';

import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List <ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMsg({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessgeAndGetAnswers({required String msg, required String modelId}) async {
    var retList = await ApiService.sendMessage(
              message: msg,
              modelId: modelId);
    chatList.addAll(retList);
    notifyListeners();
  }

}