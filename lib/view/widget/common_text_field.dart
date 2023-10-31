import 'package:flutter/material.dart';

class CommonTextEditField extends StatelessWidget {
  const CommonTextEditField({super.key, required this.textEditingController, this.maxLines = 1, required this.title, required this.textInputType});

  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final int maxLines;
  final String title;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: 50,
      keyboardType: textInputType,
      validator: (value) {
        if (value!.isEmpty) {
          return "不能为空";
        }
        return null;
      },
      style: TextStyle(
        color: colorScheme.onSurface,
      ),
      strutStyle: const StrutStyle(fontSize: 16),
      decoration: InputDecoration(
        isCollapsed: true,
        //防止文本溢出时被白边覆盖
        contentPadding: const EdgeInsets.only(left: 10.0, right: 2, bottom: 10, top: 10),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: title,
        labelStyle: TextStyle(color: colorScheme.onSurface),
        alignLabelWithHint: true,
        counter: const SizedBox(),
        errorStyle: const TextStyle(fontSize: 10),
        counterStyle: TextStyle(color: colorScheme.onSurface),
      ),
    );
  }
}
