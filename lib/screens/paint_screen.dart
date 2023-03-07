import 'dart:developer';

import 'package:aifusion/providers/model_provider.dart';
import 'package:aifusion/providers/txt2img_provider.dart';
import 'package:aifusion/services/api_service.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../models/AiChatMessageModel.dart';
import '../providers/chats_provider.dart';
import '../services/assets_manager.dart';
import '../services/services.dart';
import '../widgets/chat_widget.dart';
import '../widgets/text_widget.dart';


class TxtToImageScreen extends StatefulWidget {
  const TxtToImageScreen({super.key});

  @override
  State<TxtToImageScreen> createState() => _TxtToImageScreenState();
}

class _TxtToImageScreenState extends State<TxtToImageScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final txt2imgProvider = Provider.of<Txt2ImgProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.txt2imgLogo),
        ),
        title: const Text("Text to Image"),        
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: 1, //chatList.length,
                  itemBuilder: (context, index) {
                    return Image(image: AssetImage(AssetsManager.txt2imgLogo),width: 128,height: 128,);
                      
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessage(
                              txt2imgProvider: txt2imgProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessage(
                            
                              txt2imgProvider: txt2imgProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessage(
      {required Txt2ImgProvider txt2imgProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));        
        textEditingController.clear();
        focusNode.unfocus();
      });
      await txt2imgProvider.sendMessageAndGetImages(
          msg: msg);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}