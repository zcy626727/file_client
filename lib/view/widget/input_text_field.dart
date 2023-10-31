import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({Key? key, required this.controller, this.iconData, required this.title, required this.enable, this.maxLength, this.hintText}) : super(key: key);
  final TextEditingController controller;
  final String title;
  final IconData? iconData;
  final String? hintText;
  final int? maxLength;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: 1,
      maxLength: maxLength,
      enabled: enable,
      style: TextStyle(
        color: enable ? colorScheme.onSurface : colorScheme.onBackground.withAlpha(150),
      ),
      strutStyle: const StrutStyle(fontSize: 21),
      decoration: InputDecoration(
        isCollapsed: true,
        //防止文本溢出时被白边覆盖
        contentPadding: const EdgeInsets.only(left: 12.0, right: 2, bottom: -3, top: 10),
        border: OutlineInputBorder(
          //添加边框
          borderRadius: BorderRadius.circular(5.0),
        ),
        hintText: hintText,
        label: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground.withAlpha(150),
          ),
          strutStyle: const StrutStyle(fontSize: 16),
        ),
        suffixIcon: iconData != null
            ? Icon(
                iconData,
                color: Theme.of(context).colorScheme.primary,
              )
            : const SizedBox(),
        counterStyle: TextStyle(color: colorScheme.onSurface),
      ),
      keyboardType: TextInputType.text,
    );
  }
}
