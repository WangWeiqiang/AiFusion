import 'dart:developer';
import 'dart:ui';

import 'package:aifusion/services/assets_manager.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';
import '../models/drawing_model.dart';
import '../models/sketch.dart';
import '../widgets/canvas_side_bar.dart';
import 'drawing_canvas.dart';
import '../widgets/iconbox_widget.dart';

class DrawingScreen extends HookWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(Colors.black);
    final strokeSize = useState<double>(10);
    final eraserSize = useState<double>(30);
    final drawingMode = useState(DrawingMode.pencil);
    final filled = useState<bool>(false);
    final polygonSides = useState<int>(3);
    final backgroundImage = useState<Image?>(null);
    final showSize = useState<bool>(false);
    final showColorSetting = useState<bool>(false);
    final showPaintToolSetting = useState<bool>(false);

    final canvasGlobalKey = GlobalKey();
    ValueNotifier<Sketch?> currentSketch = useState(null);
    ValueNotifier<List<Sketch>> allSketches = useState([]);

    final undoRedoStack = useState(_UndoRedoStack(
      sketchesNotifier: allSketches,
      currentSketchNotifier: currentSketch,
    ));

    
    

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 150),
      initialValue: 1,
    );

    List<Color> colors = [
      Colors.black,
      Colors.white,
      ...Colors.primaries,
    ];

    showColorWheel(BuildContext context, ValueNotifier<Color> color) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: color.value,
                onColorChanged: (value) {
                  color.value = value;
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Done'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }

    IconData CurrentDrawIcon(DrawingMode drawingMode){
      switch(drawingMode){
        case DrawingMode.pencil:
          return FontAwesomeIcons.pencil;
        case DrawingMode.line:
          return FontAwesomeIcons.line;
        case DrawingMode.circle:
          return FontAwesomeIcons.circle;
        case DrawingMode.polygon:
          return FontAwesomeIcons.drawPolygon;
        case DrawingMode.eraser:
          return FontAwesomeIcons.eraser;
        case DrawingMode.square:
          return FontAwesomeIcons.square;        
      }

      return FontAwesomeIcons.pencil;
    }
    
    void _showPaintTool(BuildContext context){
      showModalBottomSheet(
        elevation: 10,
        backgroundColor: cardColor,
        context:context,
        builder: (context) =>Container(
          width: 300,
          height: 250,
          color: Colors.white,
          alignment: Alignment.center,
          child:Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        _IconBox(
                          iconData: FontAwesomeIcons.pencil,
                          selected: drawingMode.value == DrawingMode.pencil,
                          onTap: () => drawingMode.value = DrawingMode.pencil,
                          tooltip: 'Pencil',
                        ),
                        _IconBox(
                          selected: drawingMode.value == DrawingMode.line,
                          onTap: () => drawingMode.value = DrawingMode.line,
                          tooltip: 'Line',
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 22,
                                height: 2,
                                color: drawingMode.value == DrawingMode.line
                                    ? Colors.grey[900]
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        _IconBox(
                          iconData: Icons.hexagon_outlined,
                          selected: drawingMode.value == DrawingMode.polygon,
                          onTap: () => drawingMode.value = DrawingMode.polygon,
                          tooltip: 'Polygon',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.eraser,
                          selected: drawingMode.value == DrawingMode.eraser,
                          onTap: () => drawingMode.value = DrawingMode.eraser,
                          tooltip: 'Eraser',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.square,
                          selected: drawingMode.value == DrawingMode.square,
                          onTap: () => drawingMode.value = DrawingMode.square,
                          tooltip: 'Square',
                        ),
                        _IconBox(
                          iconData: FontAwesomeIcons.circle,
                          selected: drawingMode.value == DrawingMode.circle,
                          onTap: () => drawingMode.value = DrawingMode.circle,
                          tooltip: 'Circle',
                        ),
                      ],
                    )
        ));
    }
    void _showPaintSize(BuildContext context){
      
      showModalBottomSheet(
        elevation: 10,
        context: context, 
        backgroundColor: cardColor,
        builder: (context)=>Container(
          width: 300,
          height: 250,
          color: cardColor,
          alignment: Alignment.center,
          child:  Slider(
              value: strokeSize.value,
              min: 0,
              max: 50,
              onChanged: (val) {
                strokeSize.value = val;
                eraserSize.value = val;
              },)
        ));
    }
    void _showColorSettings(BuildContext context){
      showModalBottomSheet(
        context: context, 
        elevation: 10,
        backgroundColor:cardColor,
        builder: (context)=>Container(
          width: 300,
          height: 250,
          child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      for (Color color in colors)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => selectedColor.value = color,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(
                                    color: selectedColor.value == color
                                        ? Colors.blue
                                        : Colors.grey,
                                    width:selectedColor.value==color? 2: 0),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ),

                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              showColorWheel(context, selectedColor);
                            },
                            child: SvgPicture.asset(
                              'assets/images/color_wheel.svg',
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
      ));
    }
    return Scaffold(
      body: SafeArea(
        child:Column(
          children:[
            Container(
              color: kCanvasColor,
              //width: double.maxFinite,
              //height: double.maxFinite,
              child: DrawingCanvas(
                width: 300,//MediaQuery.of(context).size.width,
                height: 200,// MediaQuery.of(context).size.height,
                drawingMode: drawingMode,
                selectedColor: selectedColor,
                strokeSize: strokeSize,
                eraserSize: eraserSize,
                sideBarController: animationController,
                currentSketch: currentSketch,
                allSketches: allSketches,
                canvasGlobalKey: canvasGlobalKey,
                filled: filled,
                polygonSides: polygonSides,
                backgroundImage: backgroundImage,
              ),
            ),
            
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                heightFactor: 100,
                child: Material(
                    color: cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                  
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //drawing tools
                          _IconBox(
                            iconData: CurrentDrawIcon(drawingMode.value),                   
                            selected: true,
                            onTap: () => {_showPaintTool(context)},
                            tooltip: 'Pencil',
                          ),
                        const SizedBox(width: 10,),
                        
                        //stroke fill or not
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: ()=> filled.value=!filled.value ,
                            child: ImageIcon(AssetImage(filled.value?AssetsManager.drawFillYes:AssetsManager.drawFillNo)),
                            
                          ),
                        ),

                        const SizedBox(width: 10,),
                        
                        //stroke size
                        GestureDetector(
                          onTap: ()=>{_showPaintSize(context)},
                          child: Container(

                            width: 35,
                            height: 35,
                            decoration: const ShapeDecoration(
                              color: Colors.white,
                              shape: CircleBorder(side:BorderSide(color: Colors.black,width: 0.5)),
                              
                            ),
                            child: Center(
                              child: SizedBox(
                                width: strokeSize.value,
                                height: strokeSize.value,
                                
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:BorderRadius.all(Radius.circular(20))
                                  )
                                ),
                              )
                            ), 
                          ),
                        ),

                        const SizedBox(width: 10,),

                        //undo
                        _IconBox(
                              iconData: FontAwesomeIcons.arrowRotateLeft,                   
                              selected: true,
                              onTap: ()=>{
                                if(allSketches.value.isNotEmpty){
                                  undoRedoStack.value.undo()

                                }
                              },
                              tooltip: "undo",
                        ),
                        SizedBox(width: 10,),
                        
                        //redo
                        ValueListenableBuilder<bool>(
                          valueListenable: undoRedoStack.value._canRedo,
                          builder: (_, canRedo, __) {
                            return _IconBox(
                              iconData: FontAwesomeIcons.arrowRotateRight,                   
                              selected: true,
                              onTap: ()=>{
                                if(canRedo){
                                  undoRedoStack.value.redo()
                                }
                              },
                              tooltip: "redo",
                            );
                            
                          },
                        ),
                        SizedBox(width: 10,),
                        
                        //clear
                        _IconBox(
                          iconData: FontAwesomeIcons.xmark,                   
                          selected: true,
                          onTap: () => undoRedoStack.value.clear(),
                          tooltip: "magic",
                        ),

                        SizedBox(width: 10,),
                        
                        //color
                        GestureDetector(
                          onTap: ()=>{_showColorSettings(context)},
                          child: SizedBox(
                            width: 35,
                            height: 35,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: selectedColor.value,
                                borderRadius:BorderRadius.all(Radius.circular(20))
                              )
                            ),
                          )
                        ),
                        SizedBox(width: 10,),
                        
                        //export iamge
                        _IconBox(
                          iconData: FontAwesomeIcons.download,                   
                          selected: true,
                          onTap: () => {
                            
                          },
                          tooltip: "export",
                        ),
                        SizedBox(width: 10,),
                        
                        //image to image action
                        _IconBox(
                          iconData: FontAwesomeIcons.lightbulb,                   
                          selected: true,
                          onTap: () => {},
                          tooltip: "magic",
                      
                    ),
                      
                      ]
                    )
                  ),
                
                  ),
              
              )
            ),
            
          ],
        ),
      ),
    );
  }
}



class _CustomAppBar extends StatelessWidget {
  final AnimationController animationController;

  const _CustomAppBar({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight,
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                if (animationController.value == 0) {
                  animationController.forward();
                } else {
                  animationController.reverse();
                }
              },
              icon: const Icon(Icons.draw_sharp),
            )
          ],
        ),
      ),
    );
  }
}


class _IconBox extends StatelessWidget {
  final IconData? iconData;
  final Widget? child;
  final bool selected;
  final VoidCallback onTap;
  final String? tooltip;

  const _IconBox({
    Key? key,
    this.iconData,
    this.child,
    this.tooltip,
    required this.selected,
    required this.onTap,
  })  : assert(child != null || iconData != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? Colors.grey[900]! : Colors.grey,
              width: 0.5,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Tooltip(
            message: tooltip,
            preferBelow: false,
            child: child ??
                Icon(
                  iconData,
                  color: selected ? Colors.grey[900] : Colors.grey,
                  size: 20,
                ),
          ),
        ),
      ),
    );
  }
}

class _UndoRedoStack {
  _UndoRedoStack({
    required this.sketchesNotifier,
    required this.currentSketchNotifier,
  }) {
    _sketchCount = sketchesNotifier.value.length;
    sketchesNotifier.addListener(_sketchesCountListener);
  }

  final ValueNotifier<List<Sketch>> sketchesNotifier;
  final ValueNotifier<Sketch?> currentSketchNotifier;

  ///Collection of sketches that can be redone.
  late final List<Sketch> _redoStack = [];

  ///Whether redo operation is possible.
  ValueNotifier<bool> get canRedo => _canRedo;
  late final ValueNotifier<bool> _canRedo = ValueNotifier(false);

  late int _sketchCount;

  void _sketchesCountListener() {
    if (sketchesNotifier.value.length > _sketchCount) {
      //if a new sketch is drawn,
      //history is invalidated so clear redo stack
      _redoStack.clear();
      _canRedo.value = false;
      _sketchCount = sketchesNotifier.value.length;
    }
  }

  void clear() {
    _sketchCount = 0;
    sketchesNotifier.value = [];
    _canRedo.value = false;
    currentSketchNotifier.value = null;
  }

  void undo() {
    final sketches = List<Sketch>.from(sketchesNotifier.value);
    if (sketches.isNotEmpty) {
      _sketchCount--;
      _redoStack.add(sketches.removeLast());
      sketchesNotifier.value = sketches;
      _canRedo.value = true;
      currentSketchNotifier.value = null;
    }
  }

  void redo() {
    if (_redoStack.isEmpty) return;
    final sketch = _redoStack.removeLast();
    _canRedo.value = _redoStack.isNotEmpty;
    _sketchCount++;
    sketchesNotifier.value = [...sketchesNotifier.value, sketch];
  }

  void dispose() {
    sketchesNotifier.removeListener(_sketchesCountListener);
  }
}