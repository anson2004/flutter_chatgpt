import 'package:chatcptapp/constants/constants.dart';
import 'package:chatcptapp/models/chat_model.dart';
import 'package:chatcptapp/providers/chat_provider.dart';
import 'package:chatcptapp/services/api_services.dart';
import 'package:chatcptapp/widgets/chat_widget.dart';
import 'package:chatcptapp/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../providers/modals_provider.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    listScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetManager.openaiLogo),
        ),
        title: const Text('AI Chart'),
        actions: [
          IconButton(
              onPressed: () async {
                await Services.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: listScrollController,
                itemCount: chatsProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                      msg: chatsProvider.getChatList[index].msg,
                      chatIndex: chatsProvider.getChatList[index].chatIndex);
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(color: Colors.white, size: 18)
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMsgFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatsProvider);
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I help u",
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  IconButton(
                      onPressed: () async {
                        await sendMsgFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatsProvider);
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ))
                ],
              ),
            ), // input box
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    listScrollController.animateTo(
        listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut);
  }

  Future<void> sendMsgFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
   if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: TextWidget(label: "You can not type message multiple times")));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: TextWidget(label: "Please type a message")));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMsg(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessgeAndGetAnswers(
          msg: msg,
          modelId: modelsProvider.getCurrentModel);

      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: TextWidget(label: error.toString())));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
    }
  }
}
