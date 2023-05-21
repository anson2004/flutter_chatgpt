import 'package:chatcptapp/constants/constants.dart';
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

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatMessages[index]["msg"].toString(),
                    chatIndex:
                        int.parse(chatMessages[index]["chatIndex"].toString()),
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
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) {},
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I help u",
                        hintStyle: TextStyle(color: Colors.grey)),
                  )),
                  IconButton(
                      onPressed: () async {
                        try {
                           setState(() {
                             _isTyping = true;
                           });
                          await ApiService.sendMessage(
                              message: textEditingController.text,
                              modelId: modelsProvider.getCurrentModel);
                        } catch (e) {}
                        finally {
                          setState(() {
                             _isTyping = false;
                           });
                        }
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
}
