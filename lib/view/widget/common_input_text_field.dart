import 'package:flutter/material.dart';

class CommonInputTextField extends StatelessWidget {
  const CommonInputTextField({
    super.key,
    this.maxLines = 1,
    this.maxLength,
    this.title,
    this.controller,
  });

  final int maxLines;
  final int? maxLength;
  final String? title;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isCollapsed: true,
        //防止文本溢出时被白边覆盖
        contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: title,
        labelStyle: TextStyle(color: colorScheme.onSurface, fontSize: 14),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: colorScheme.onSurface),
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      style: TextStyle(color: colorScheme.onSurface),
    );
  }
}
