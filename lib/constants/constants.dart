import 'package:flutter/material.dart';

Color scaffoldBackgroundColor=const Color(0xFF343541);
Color cardColor = const Color(0xFF444654);

List<String> models=[
  'model1',
  'model2',
  'model3',
  'model4',
  'model5',
  'model6',
  'model7',
  'model8',
];

List<DropdownMenuItem<String>>? getModelsItem() {
  List<DropdownMenuItem<String>>? modelsItem=
    List<DropdownMenuItem<String>>.generate(
      models.length,
      (index) => DropdownMenuItem(
        value: models[index],
        child: Text(models[index],style: TextStyle(color: Colors.white),)
      )
    );

  return modelsItem;
  
}