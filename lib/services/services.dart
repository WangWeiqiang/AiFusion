import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/drop_down.dart';

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
          padding: const EdgeInsets.all(18.9),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[
              Flexible(
                child: Text('Chosen Model:',)
              ),
              Flexible(child: ModelsDrowDownWidget()),
            ],
          )
        );
      }
    );
  }
}