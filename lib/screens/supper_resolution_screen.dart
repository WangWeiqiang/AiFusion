import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

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

  String _image='';

  
  
  final Duration duration = Duration(seconds: 3);

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
              child:_image.isEmpty? Image(image: AssetImage(AssetsManager.openaiLogo))
              :(_image.contains('http')?Image.network(_image):Image.file(File(_image))),
            )),
            if (isLoading) ...[
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
                    Timer? _timer =null;
                    int maxLoadTimes = 10;
                    final XFile? imgFile = await _imagePicker.pickImage(source: ImageSource.gallery);
                    
                    Uint8List imageBytes = await imgFile!.readAsBytes();
                     
                    if(imgFile!=null){
                      isLoading=true;

                      setState((){
                        _image = imgFile.path;
                      });

                      String? reqeustId = await ReplicateService.SupperResolution(fileName: imgFile.name, bodyBytes: imageBytes);

                      _timer = Timer.periodic(duration, (timer) async { 
                        var output = await ReplicateService.GetSuppResolutionResult(id: reqeustId!);
                        log(maxLoadTimes.toString());
                        if(output!=null){
                          isLoading=false;
                          _timer!.cancel();
                          setState(() {
                            _image = output;
                          });
                        }
                        maxLoadTimes--;
                        if(maxLoadTimes<0 && _timer!=null){
                          setState(() {
                            isLoading=false;
                          });
                          _timer!.cancel();
                          log("wait for long time no response from replciate");
                        }
                      });
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