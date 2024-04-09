// ignore_for_file: file_names

import 'dart:math';

import "package:flutter/material.dart";
//import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
//import "package:flutter/services.dart";
//import 'package:flutter_layout_descriptive/Layouts/EverythingOnTop.dart';
//import 'package:flutter_layout_descriptive/Layouts/ColumnCenter.dart';
//import 'package:flutter_layout_descriptive/Layouts/Grid.dart';
//import 'package:flutter_layout_descriptive/Widgets/SelectableTable - Cell.dart';
//import 'package:flutter_layout_descriptive/Layouts/FakeGrid.dart';
//import 'dart:ui';
import 'package:flutter_layout_descriptive/utils.dart' as utils;

Size textSize(String text, TextStyle style) {
  TextPainter? textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  Size s = textPainter.size;
  textPainter = null;
  return Size(s.width * 1.5, s.height * 1.5);
  //return const Size(180.0, 100.0);
}

//This is only here to ged the size of the cells before rendering the box around it!
class FakeGridRow {
  int key;
  List<FakeGridCell> cells = [];
  double height = 0;
  double y = 0;

  FakeGridRow(this.key);

  void add(FakeGridCell cell) {
    cells.add(cell);
    height = max(height, cell.size.height);
  }

  void update([FakeGridRow? previousRow]) {
    if (previousRow != null) {
      y = previousRow.y + previousRow.height;
      for (FakeGridCell cell in cells) {
        cell.y = y;
      }
    }
    for (FakeGridCell cell in cells) {
      cell.size = Size(cell.size.width, height);
    }
  }
}

class FakeGridColumn {
  int key;
  List<FakeGridCell> cells = [];
  double width = 0;
  double x = 0;

  FakeGridColumn(this.key);

  void add(FakeGridCell cell) {
    cells.add(cell);
    width = max(width, cell.size.width);
  }

  void update([FakeGridColumn? previousColumn]) {
    if (previousColumn != null) {
      x = previousColumn.x + previousColumn.width;
      for (FakeGridCell cell in cells) {
        cell.x = x;
      }
    }
    for (FakeGridCell cell in cells) {
      cell.size = Size(width, cell.size.height);
    }
  }
}

class FakeGridCell {
  final int key;
  Size size;
  double x = 0;
  double y = 0;
  FakeGridCell(this.key, this.size, FakeGridRow row, FakeGridColumn column) {
    row.add(this);
    column.add(this);
  }
}

List<Size> textsizes(List<String> content, int rowCellCount) {
  List<FakeGridRow> rows = <FakeGridRow>[FakeGridRow(0)];
  List<FakeGridColumn> columns = <FakeGridColumn>[FakeGridColumn(0)];
  List<FakeGridCell> cells = <FakeGridCell>[];

  int currentKey = 0;
  int currentRowIndex = 0;
  int currentColumnIndex = 0;

  //double width = 0.0;
  //double height = 0.0;

  //Add all children to the corresponding GridCells, GridRows and GridColumns
  while (currentKey < content.length) {
    Size wsize = textSize(content[currentKey], const TextStyle(fontSize: 15.0));
    wsize = Size(wsize.width + 1.0, wsize.height + 1.0);
    cells.add(FakeGridCell(
        currentKey, wsize, rows[currentRowIndex], columns[currentColumnIndex]));
    currentKey = currentKey + 1;
    if (currentColumnIndex == (rowCellCount - 1)) {
      currentColumnIndex = 0;
      currentRowIndex = currentRowIndex + 1;
      if (rows.length <= currentRowIndex) {
        rows.add(FakeGridRow(currentRowIndex));
      }
    } else {
      currentColumnIndex = currentColumnIndex + 1;
      if (columns.length <= currentColumnIndex) {
        columns.add(FakeGridColumn(currentColumnIndex));
      }
    }
  }

  //IMPORTANT: need to iterate over rows in order!!!
  FakeGridRow? previousRow;
  for (FakeGridRow row in rows) {
    row.update(previousRow);
    previousRow = row;
  }

  //IMPORTANT: need to iterate over columns in order!!!
  FakeGridColumn? previousColumn;
  for (FakeGridColumn column in columns) {
    column.update(previousColumn);
    previousColumn = column;
  }

  List<Size> result = [];
  for (FakeGridCell cell in cells) {
    result.add(cell.size);
  }
  return result;
}

Size entireSize(List<Size> sizes, int rowCellCount) {
  Map<int, double> widths = {};
  Map<int, double> heights = {};
  for (int index = 0; index < sizes.length; index = index + 1) {
    Size currentSize = sizes[index];
    List<int> position = utils.indexToPosition(index, rowCellCount);
    int rowIndex = position[0];
    int columnIndex = position[1];

    heights[rowIndex] = max(heights[rowIndex] ?? 0.0, currentSize.height);
    widths[columnIndex] = max(widths[columnIndex] ?? 0.0, currentSize.width);
  }
  double width = 0.0;
  for (double columnWidth in widths.values) {
    width = width + columnWidth;
  }
  double height = 0.0;
  for (double rowHeight in heights.values) {
    height = height + rowHeight;
  }
  return Size(width, height);
}
