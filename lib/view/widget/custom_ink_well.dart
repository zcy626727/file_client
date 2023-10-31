
import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomInkWell extends StatefulWidget {
  const CustomInkWell({Key? key, required this.child, this.onTap, this.onDoubleTap, this.onPreTap, required this.doubleTapTime, this.onSecondaryTap, this.onLongTap}) : super(key: key);

  final Widget child;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onDoubleTap;
  final GestureTapCallback? onPreTap;
  final GestureTapDownCallback? onSecondaryTap;
  final GestureLongPressStartCallback? onLongTap;
  final Duration doubleTapTime;

  @override
  State<CustomInkWell> createState() => _CustomInkWellState();
}

class _CustomInkWellState extends State<CustomInkWell> {
  Timer? doubleTapTimer;
  int _count = 0;

  void _doubleTapTimerElapsed() {
    if(_count==1){
      if(widget.onTap != null) widget.onTap!();
    }else if(_count==2){
      if(widget.onDoubleTap!=null) widget.onDoubleTap!();
    }
    doubleTapTimer!.cancel();
    _count=0;
  }

  void _onTap() {
    if(_count==0){
      if(widget.onPreTap!=null) widget.onPreTap!();
    }
    _count++;
    if (doubleTapTimer == null || !doubleTapTimer!.isActive) {
      //生成定时器
      doubleTapTimer = Timer(widget.doubleTapTime, _doubleTapTimerElapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: widget.onLongTap,
      child: InkWell(
        onSecondaryTapDown: widget.onSecondaryTap,
        splashFactory: InkRipple.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.grey.withAlpha(50),
        key: widget.key, // if onDoubleTap is not used from user, then route further to onTap
        onTap: _onTap,
        child: widget.child,
      ),
    );
  }
}
