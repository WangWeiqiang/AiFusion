import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaintScreen extends StatefulWidget{
  const PaintScreen({super.key});
  @override 
  State<PaintScreen> createState()=>_PaintScreen();
}

class _PaintScreen extends State<PaintScreen>{
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.format_paint_rounded);
    
  }
}