import 'dart:developer';
import 'dart:typed_data';

import 'package:aifusion/constants/api_constant.dart';
import 'package:azblob/azblob.dart';

class AzureBlobStorageService{
  static Future<String?> Upload({required String fileName,required Uint8List bodyByte }) async {
    try{
      var storage = AzureStorage.parse(AZURE_STORAGE_CONN);
      
      await storage.putBlob('/img/$fileName',  bodyBytes :bodyByte);

      return "https://neabisdevdiag.blob.core.windows.net/img/$fileName";

    }
    catch(error){
      log("error: $error");
    }
  }
}