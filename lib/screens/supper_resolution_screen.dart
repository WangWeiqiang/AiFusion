import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aifusion/constants/api_constant.dart';
import 'package:aifusion/services/replicate_service.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stability_sdk/stability_sdk.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/constants.dart';
import '../services/assets_manager.dart';

class SupperResolutionPage extends StatefulWidget {
  const SupperResolutionPage({super.key});

  @override
  State<SupperResolutionPage> createState() => _SupperResolutionPageState();
}

class _SupperResolutionPageState extends State<SupperResolutionPage> {
  late StabilityApiClient client;
  List<String?> images=[];
  late bool hasInput;
  late bool isLoading;
  late FocusNode focusNode;
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late ScrollController _listScrollController;

  final ImagePicker _imagePicker=ImagePicker();

  var _image;

  final ReplicateService service = ReplicateService();

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

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supper Resolution'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(
              child:_image!=null 
                ?Image.file(_image) :Image(image: AssetImage(AssetsManager.openaiLogo)),
            )),
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
                padding: const EdgeInsets.all(2.0),
                child:TextButton(
                  onPressed: () async { 
                    final XFile? imgFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                    var base64Image;
                    if(imgFile!=null){
                      setState((){
                        _image = File(imgFile.path);
                        List<int> imageBytes = _image.readAsBytesSync();
                        print(imageBytes);
                        base64Image = base64Encode(imageBytes);
                      });

                      var result = await ReplicateService.SupperResolution(modelType: '', imageFile: base64Image);
                      if(result!.isNotEmpty){
                        setState(() {
                          _image = File.fromUri(Uri.parse(result));
                        });
                      }
                    }
                  }, 
                 child: Text('Choose a low resolution Image'),)
              ),
            )
          ],          
        ),
      ),
    );
  }
}