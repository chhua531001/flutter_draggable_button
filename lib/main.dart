import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Draggable Floating Button'),
        ),
        body: const DraggableFloatingButton(),
      ),
    );
  }
}

class DraggableFloatingButton extends StatefulWidget {
  const DraggableFloatingButton({super.key});

  @override
  State<DraggableFloatingButton> createState() =>
      _DraggableFloatingButtonState();
}

class _DraggableFloatingButtonState extends State<DraggableFloatingButton> {
  Offset position = const Offset(100, 100);
  bool isSafeAreaUsed = false;

  //確認SafeArea是否有使用
  void checkForSafeArea(BuildContext context) {
    context.visitAncestorElements((element) {
      if (element.widget is SafeArea) {
        isSafeAreaUsed = true;
        return false;
      }
      return true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkForSafeArea(context);
    debugPrint("isSafeAreaUsed -> $isSafeAreaUsed");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
    debugPrint(
        "appBarHeight -> $appBarHeight");
    double statusBarHeight = 0;

    if (isSafeAreaUsed) {
      //MediaQueryData.fromView(window).padding.top是記錄Status Bar的高度
      debugPrint(
          "MediaQueryData.fromWindow(window).padding -> ${MediaQueryData.fromView(window).padding}");
      statusBarHeight = MediaQueryData.fromView(window).padding.top;
    }

    debugPrint("statusBarHeight -> $statusBarHeight");

    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: const Opacity(
              opacity: 0.3,
              child: FloatingActionButton(
                onPressed: null,
                child: ImageIcon(
                  AssetImage("assets/images/drag-and-drop.png"),
                  size: 36,
                ),
              ),
            ),
            childWhenDragging: Container(),
            onDragEnd: (details) {
              setState(() {
                //回傳的Offset有把AppBar的height加上了，必須把它減回來
                position = details.offset
                    .translate(0, -(appBarHeight + statusBarHeight));
                debugPrint("position -> $position");
              });
            },
            child: FloatingActionButton(
              onPressed: () {
                debugPrint(
                    "Click get appBarHeight -> ${appBarHeight + statusBarHeight}");
              },
              child: const ImageIcon(
                AssetImage("assets/images/drag-and-drop.png"),
                size: 36,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
