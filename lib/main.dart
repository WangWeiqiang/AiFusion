import 'package:aifusion/providers/model_provider.dart';
import 'package:aifusion/providers/txt2img_provider.dart';
import 'package:aifusion/screens/chat_screen.dart';
import 'package:aifusion/screens/drawing_screen.dart';
import 'package:aifusion/screens/stability_screen.dart';
import 'package:aifusion/screens/supper_resolution_screen.dart';
import 'package:aifusion/services/services.dart';
import 'package:aifusion/widgets/text_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'providers/chats_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Txt2ImgProvider()
        )
      ],
      child: MaterialApp(
        title: 'Flutter ChatBOT',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: scaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
              color: cardColor,
            )),
        home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              title: const TextWidget(label: 'Ai Fusion'),
              
              bottom: const TabBar(
                tabs: [
                  Tab(icon:Icon(Icons.chat)),
                  Tab(icon:Icon(Icons.image)),
                  Tab(icon: Icon(Icons.scale_sharp)),
                  Tab(icon:Icon(Icons.draw_rounded))
                ]
              ),
            ),
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ChatScreen(),
                SingleImagePage(),
                SupperResolutionPage(),
                DrawingScreen()
              ],
            ) ,
          ),
        ),
      ),
    );
  }
}