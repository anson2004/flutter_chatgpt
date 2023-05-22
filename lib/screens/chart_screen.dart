import 'package:chatcptapp/constants/constants.dart';
import 'package:chatcptapp/models/chat_model.dart';
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
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);

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
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatList[index].msg,
                    chatIndex:  chatList[index].chatIndex
                  );
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
                        await sendMsgFCT(modelsProvider: modelsProvider);
                      },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I help u",
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  IconButton(
                      onPressed: () async {
                        await sendMsgFCT(modelsProvider: modelsProvider);
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

  Future <void> sendMsgFCT ({ required ModelsProvider modelsProvider}) async {

     try {
            setState(() {
              _isTyping = true;
              chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
              textEditingController.clear();
              focusNode.unfocus();
            });
            var retList = await ApiService.sendMessage(
              message: textEditingController.text,
              modelId: modelsProvider.getCurrentModel);
            setState(() {
                chatList.addAll(retList);
             });
        } catch (e) {}
        finally {
          setState(() {
              _isTyping = false;
            });
        }
  }
}
