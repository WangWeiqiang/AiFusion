import 'package:aifusion/widgets/drop_down.dart';
import 'package:flutter/material.dart';

import '../constants/constants.dart';

class Services{
  static Future<void> showModalSheet({required BuildContext context}) async{
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20)
        
        )
      ),
      backgroundColor: scaffoldBackgroundColor,
      context: context, 
      builder: (context){
        return Padding(
          padding: EdgeInsets.all(18.9),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
              Flexible(
                child: Text('Chosen Model:',)
              ),
              Flexible(child: ModelsDropDownWidget()),
            ],
          )
        );
      }
    );
  }
}