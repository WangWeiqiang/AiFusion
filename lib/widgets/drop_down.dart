import 'package:aifusion/constants/constants.dart';
import 'package:flutter/material.dart';

class ModelsDropDownWidget extends StatefulWidget{
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState()=>_ModelsDropDownWidget();
}

class _ModelsDropDownWidget extends State<ModelsDropDownWidget>{
  String currentModel = "model1";


  @override
  Widget build(BuildContext context){
    return DropdownButton(
      dropdownColor: scaffoldBackgroundColor,
      iconEnabledColor: Colors.white,
      items:getModelsItem() , 
      value: currentModel,
      onChanged:(value){
        setState(() {
          currentModel=value.toString();
        });

      }
    );
  }
}

