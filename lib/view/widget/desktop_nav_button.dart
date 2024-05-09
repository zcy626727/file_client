import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  const NavButton({
    Key? key,
    required this.title,
    this.onPress,
    required this.iconData,
    required this.index,
    required this.selectedIndex,
    this.height = 35,
  }) : super(key: key);
  final String title;
  final VoidCallback? onPress;
  final IconData iconData;
  final int index;
  final int selectedIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var color = index == selectedIndex ? colorScheme.primary : colorScheme.onSurface.withAlpha(150);
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onPress,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 7),
              child: Icon(
                iconData,
                size: 20,
                color: color,
              ),
            ),
            Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}
