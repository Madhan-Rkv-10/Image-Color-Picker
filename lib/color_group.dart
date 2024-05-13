import 'package:flutter/material.dart';

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child:
          Card(clipBehavior: Clip.antiAlias, child: Column(children: children)),
    );
  }
}
