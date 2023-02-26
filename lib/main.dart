import 'package:aifusion/screens/chat_screen.dart';
import 'package:aifusion/screens/paint_screen.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:aifusion/models/AiChatMessageModel.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';


void main() {
  runApp(AiFusionApp());
}

class AiFusionApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Ai Fusion',
      home: new AiHomePage(),
    );
  }
}

class AiHomePage extends StatefulWidget{
  @override
  _AiHomePageState createState()=> new _AiHomePageState();
}

class _AiHomePageState extends State<AiHomePage>{

  late OpenAI openAI;
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Material(
      child:DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.draw)),
                Tab(icon:Icon(Icons.play_circle))
              ],
            ),
            title: const Text('Ai Fusion'),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ChatScreen(),
              PaintScreen(),
              Icon(Icons.play_circle)
            ]
          ),
          floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.send),
                    onPressed: (){
                      setState((){
                        messages.add(AiChatMessage(messageContent: sendNewText, messageType:'receiver'));
                        
                      });
                    }
          ),
        ),
      ),
    );
  }
}