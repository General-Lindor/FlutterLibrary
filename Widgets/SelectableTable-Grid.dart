// ignore_for_file: file_names

//import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_layout_descriptive/Layouts/CRGrid.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
//import "package:flutter/services.dart";
//import 'package:flutter_layout_descriptive/Layouts/EverythingOnTop.dart';
//import 'package:flutter_layout_descriptive/Layouts/ColumnCenter.dart';
//import 'package:flutter_layout_descriptive/Layouts/FixedSizeGrid.dart';
//import 'package:flutter_layout_descriptive/Layouts/Grid.dart';
import 'package:flutter_layout_descriptive/Widgets/SelectableTable-Cell.dart';
//import 'package:flutter_layout_descriptive/Layouts/FakeGrid.dart';
//import 'dart:ui';
//import 'package:flutter_layout_descriptive/utils.dart' as utils;

List<SelectableBox> toCells(Key? key, List<String> texts, List<Size> sizes,
    List<bool> states, List<bool> selectabilities) {
  List<SelectableBox> result = [];
  for (int i = 0; i < texts.length; i = i + 1) {
    result.add(SelectableBox(
        key: ValueKey("${key}Cell$i"),
        id: i,
        text: texts[i],
        size: sizes[i],
        selectability: selectabilities[i],
        isSelected: states[i]));
  }
  return result;
}

class SelectableGrid extends StatelessWidget {
  SelectableGrid({
    super.key,
    required List<String> texts,
    required List<Size> sizes,
    required List<bool> states,
    required List<bool> selectabilities,
    required this.rowCellCount,
    //required this.size
  }) : cells = toCells(key, texts, sizes, states, selectabilities);

  final int rowCellCount;
  //final Size size;

  final List<SelectableBox> cells;

  @override
  Widget build(BuildContext context) {
    return CRGrid(rowCellCount: rowCellCount, children: cells);
    /*
    return SizedBox.fromSize(
        size: size,
        child: FixedSizeGrid(
            rowCellCount: rowCellCount,
            padding: 0.0,
            size: size,
            children: cells));*/
    //return Grid(rowCellCount: rowCellCount, padding: 0.0, children: cells);
  }
}
