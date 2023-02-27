import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

import '../models/AiChatMessageModel.dart';
import '../services/assets_manager.dart';

List<AiChatMessage> messages=[
  AiChatMessage(messageContent: "Hello, Will you come to my house today?",messageType: "reciever"),
  AiChatMessage(messageContent: "How about you been",messageType: "reciever"),
  AiChatMessage(messageContent: "Hey Kriss, I am doing fine dude. whu?",messageType: "sender"),
  AiChatMessage(messageContent: "ehhhhh, doing ok",messageType: "reciever"),
  AiChatMessage(messageContent: "Is there any thing wrong?",messageType: "sender"),
  AiChatMessage(messageContent: "Everything going well, thanks",messageType: "reciever"),

];

String sendNewText="";

class ChatScreen extends StatefulWidget{
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState()=>_ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>{
  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child:Column(
        children: [
          
          Expanded(
            child: Flexible(
                  child: ListView.builder(
                  
                    itemCount: messages.length,
                    scrollDirection: Axis.vertical,                              
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    
                    itemBuilder: (context,index){
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: messages[index].messageType=="reciever"?true:false,
                            child: Image.asset('assets/images/icon_girl.png',width: 42,height: 42,),
                          ),
                          SizedBox(width:(messages[index].messageType=="reciever"?4:46),),
                          Expanded(
                            
                            child:Align(
                              alignment: (messages[index].messageType=="reciever"?Alignment.topLeft:Alignment.topRight),
                              child:Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),                                         
                                child:Bubble(
                                  nip:messages[index].messageType=="reciever"?BubbleNip.leftTop:BubbleNip.rightTop,
                                  color:messages[index].messageType=="reciever"?Colors.grey[200]:Colors.blue[100],
                                  child:Text(
                                    messages[index].messageContent,
                                    style: const TextStyle(
                                      fontSize: 15                                      
                                    ),
                                    
                                  )
                                )
                              )
                            ),
                          ),
                          SizedBox(width: (messages[index].messageType=="reciever"?46:4),),
                          Visibility(
                            visible: messages[index].messageType=="reciever"?false:true,
                            child: Image.asset('assets/images/icon_boy.png',width: 42,height: 42,),
                          ),
                        ],
                      );
                    }
                  ),
                ),
          ), 
                    
          Row(               
            children:[
              Expanded(child: 
                TextField(
                  decoration: InputDecoration(labelText: 'Say something'),
                  onChanged: (String newText){
                    if(newText.isNotEmpty){
                      sendNewText=newText;
                    }
                  },
                
                ) 
              ),
              const SizedBox(width: 15,),
              IconButton(onPressed: (){}, icon: const Icon(Icons.send))
            ],
            
          )
        ]
      ),
    );
  }
}