import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonSearchTextField extends StatelessWidget {
  const CommonSearchTextField({
    super.key,
    this.height = 35,
    this.placeholder,
    this.onSubmitted,
  });

  final double height;
  final String? placeholder;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      height: height,
      // padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0, bottom: 10.0),
      child: CupertinoSearchTextField(
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
        placeholder: placeholder,
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        prefixInsets: const EdgeInsets.only(top: 1, left: 5, right: 2),
        suffixIcon: Icon(
          CupertinoIcons.xmark_circle_fill,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}
