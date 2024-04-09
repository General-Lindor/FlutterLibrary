// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CRGrid extends StatelessWidget {
  const CRGrid({required this.children, required this.rowCellCount, super.key});
  final List<Widget> children;
  final int rowCellCount;

  @override
  Widget build(BuildContext context) {
    List<Row> rows = [];
    List<Widget> currentChildren = [];
    bool hasBeenAdded = false;
    for (Widget w in children) {
      currentChildren.add(w);
      if (currentChildren.length == rowCellCount) {
        rows.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: currentChildren));
        currentChildren = [];
        hasBeenAdded = true;
      } else {
        hasBeenAdded = false;
      }
    }
    if (!hasBeenAdded) {
      rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: currentChildren));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }
}
