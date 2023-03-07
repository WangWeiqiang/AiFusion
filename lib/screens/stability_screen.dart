import 'dart:developer';

import 'package:aifusion/constants/api_constant.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stability_sdk/stability_sdk.dart';

import '../constants/constants.dart';

class SingleImagePage extends StatefulWidget {
  const SingleImagePage({super.key});

  @override
  State<SingleImagePage> createState() => _SingleImagePageState();
}

class _SingleImagePageState extends State<SingleImagePage> {
  late StabilityApiClient client;
  List<String?> images=[];
  late bool hasInput;
  late bool isLoading;
  late FocusNode focusNode;
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;

  @override
  void initState() {
    hasInput = false;
    isLoading = false;
    focusNode=FocusNode();
    client = StabilityApiClient.init(DREAM_STUDIO_KEY);
    textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    textEditingController.addListener(() {
      if (textEditingController.text != null && textEditingController.text.isNotEmpty) {
        setState(() {
          hasInput = true;
        });
      } else {
        setState(() {
          hasInput = false;
        });
      }
    });

    super.initState();
  }

  Future<void> generateImage(String prompt) async {
    setState(() {
      isLoading = true;
      images =[];
      _isTyping = true;
    });

    final request = RequestBuilder(prompt)
        .setHeight(512)
        .setWidth(512)
        .setEngineType(EngineType.inpainting_v2_0)
        .setSampleCount(4)
        
        .build();

    client.generate(request).listen((answer) {
      if (answer.artifacts?.isNotEmpty == true) {
        setState(() {
           
          final list =answer.artifacts!.toList(growable: true);
          
          //images.clear();
          for(var a in list){
            var img =a.getImage();
            if(img != null)
              images.add(img);
          }
          _isTyping = false;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Image'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: images.length,
                itemBuilder: (context,index){
                  if(images.length>0)
                  return Padding(padding: EdgeInsets.all(10),child:  CachedMemoryImage(
                      base64: images[index],
                      uniqueKey: images[index].toString(),
                    ),);
                }
                ),
                
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
                    Icon(Icons.camera_enhance,color: Colors.white,),
                    SizedBox(width: 10,),
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          generateImage(textEditingController.text);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          generateImage(textEditingController.text);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            )
          ],          
        ),
      ),
    );
  }
}