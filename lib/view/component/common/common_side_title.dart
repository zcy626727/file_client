import 'package:flutter/material.dart';

class CommonSideTitle extends StatelessWidget {
  const CommonSideTitle({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, top: 8.0, bottom: 2.0),
      child: Text(value, style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}
