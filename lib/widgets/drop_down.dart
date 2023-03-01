import 'package:aifusion/constants/constants.dart';
import 'package:aifusion/models/models_model.dart';
import 'package:aifusion/providers/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModelsDropDownWidget extends StatefulWidget{
  const ModelsDropDownWidget({super.key});

  @override
  State<ModelsDropDownWidget> createState()=>_ModelsDropDownWidget();
}

class _ModelsDropDownWidget extends State<ModelsDropDownWidget>{
  String? currentModel;


  @override
  Widget build(BuildContext context){
    final modelProvider =Provider.of<ModelsProvider>(context,listen: false);
    currentModel = modelProvider.getCurrentModel;
    return FutureBuilder<List<ModelsModel>>(
      future: modelProvider.getModelsList(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text(snapshot.error.toString()),
          );         
        }
        return snapshot.data==null || snapshot.data!.isEmpty
          ? const SizedBox.shrink()
          : FittedBox(
            child: DropdownButton(
              dropdownColor: scaffoldBackgroundColor,
              iconEnabledColor: Colors.white,
              items:List<DropdownMenuItem<String>>.generate(
                snapshot.data!.length,
                (index)=>DropdownMenuItem(
                  value:snapshot.data![index].id,
                  child:Text(snapshot.data![index].id,style: const TextStyle(color: Colors.white),)
                )
              ),
              value: currentModel,
              onChanged:(value){
                setState(() {
                  currentModel=value.toString();
                });
                modelProvider.setCurrentModel(value.toString());
          
              },
            ),
          );
    });
  }
}

/*
*/