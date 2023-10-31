import 'package:flutter/material.dart';

class CommonDropdown extends StatefulWidget {
  const CommonDropdown({super.key, required this.title, required this.onChanged, required this.options, this.initIndex = 0});

  final String title;
  final Function((int, String)) onChanged;
  final bool switchMode = true;
  final List<(int, String)> options;
  final int initIndex;

  @override
  State<CommonDropdown> createState() => _CommonDropdownState();
}

class _CommonDropdownState extends State<CommonDropdown> {
  late (int, String)? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.options[widget.initIndex];
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surface,
      child: ListTile(
        visualDensity: const VisualDensity(horizontal: -4),
        leading: Text(
          widget.title,
          style: TextStyle(color: colorScheme.onSurface.withAlpha(200), fontSize: 16),
          strutStyle: const StrutStyle(fontSize: 16),
        ),
        trailing: DropdownButton<(int, String)>(
          dropdownColor: colorScheme.surface,
          focusColor: colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          items: widget.options
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      e.$2,
                      style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withAlpha(200)),
                    ),
                  ),
                ),
              )
              .toList(),
          value: _value,
          underline: Container(),
          onChanged: (value) {
            _value = value;
            widget.onChanged(value!);
          },
        ),
      ),
    );
  }
}
