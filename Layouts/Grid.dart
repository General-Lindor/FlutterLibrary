// ignore_for_file: file_names, dangling_library_doc_comments

///////////
//IMPORTS//
///////////
import "package:flutter/material.dart";
import "dart:math";
import 'package:flutter_layout_descriptive/Layouts/DynamicMultiChildLayout.dart';
import "package:flutter_layout_descriptive/Widgets/NinftyConstraints.dart";

/////////////////
//HELPERCLASSES//
/////////////////

class GridRow {
  int key;
  List<GridCell> cells = [];
  double height = 0;
  double y = 0;

  GridRow(this.key);

  void add(GridCell cell) {
    cells.add(cell);
    height = max(height, cell.size.height);
  }

  void update([GridRow? previousRow]) {
    if (previousRow != null) {
      y = previousRow.y + previousRow.height;
      for (GridCell cell in cells) {
        cell.y = y;
      }
    }
  }
}

class GridColumn {
  int key;
  List<GridCell> cells = [];
  double width = 0;
  double x = 0;

  GridColumn(this.key);

  void add(GridCell cell) {
    cells.add(cell);
    width = max(width, cell.size.width);
  }

  void update([GridColumn? previousColumn]) {
    if (previousColumn != null) {
      x = previousColumn.x + previousColumn.width;
      for (GridCell cell in cells) {
        cell.x = x;
      }
    }
  }
}

class GridCell {
  final int key;
  final Size size;
  double x = 0;
  double y = 0;
  GridCell(this.key, this.size, GridRow row, GridColumn column) {
    row.add(this);
    column.add(this);
  }
}

////////////
//DELEGATE//
////////////
class GridDelegate extends DynamicMultiChildDelegate {
  final int rowCellCount;
  final double padding;

  GridDelegate({required this.rowCellCount, required this.padding});

  BoxConstraints gridConstraints = NinftyConstraints();

  @override
  Size performLayout() {
    List<GridRow> rows = <GridRow>[GridRow(0)];
    List<GridColumn> columns = <GridColumn>[GridColumn(0)];
    List<GridCell> cells = <GridCell>[];

    int currentKey = 0;
    int currentRowIndex = 0;
    int currentColumnIndex = 0;

    double width = 0.0;
    double height = 0.0;

    //Add all children to the corresponding GridCells, GridRows and GridColumns
    while (hasChild(currentKey)) {
      Size wsize = layoutChild(currentKey, gridConstraints);
      wsize = Size(wsize.width + (2 * padding), wsize.height + (2 * padding));
      cells.add(GridCell(currentKey, wsize, rows[currentRowIndex],
          columns[currentColumnIndex]));
      currentKey = currentKey + 1;
      if (currentColumnIndex == (rowCellCount - 1)) {
        currentColumnIndex = 0;
        currentRowIndex = currentRowIndex + 1;
        if (rows.length <= currentRowIndex) {
          rows.add(GridRow(currentRowIndex));
        }
      } else {
        currentColumnIndex = currentColumnIndex + 1;
        if (columns.length <= currentColumnIndex) {
          columns.add(GridColumn(currentColumnIndex));
        }
      }
    }

    //IMPORTANT: need to iterate over rows in order!!!
    GridRow? previousRow;
    for (GridRow row in rows) {
      row.update(previousRow);
      previousRow = row;
    }

    //IMPORTANT: need to iterate over columns in order!!!
    GridColumn? previousColumn;
    for (GridColumn column in columns) {
      column.update(previousColumn);
      previousColumn = column;
    }

    for (int i = 0; i < cells.length; i++) {
      GridCell cell = cells[i];
      positionChild(cell.key, Offset(cell.x + padding, cell.y + padding));
    }

    //Set Dimensions
    for (GridRow row in rows) {
      height = height + row.height;
    }

    for (GridColumn column in columns) {
      width = width + column.width;
    }
    return Size(width, height);
  }

  @override
  bool shouldRelayout(GridDelegate oldDelegate) {
    return ((oldDelegate.rowCellCount != rowCellCount) ||
        (oldDelegate.gridConstraints != gridConstraints));
  }
}

////////
//GRID//
////////

List<Widget> transformList(List<Widget> children) {
  List<Widget> transformedList = [];
  int key = 0;
  for (Widget widget in children) {
    transformedList.add(LayoutId(id: key, child: widget));
    key = key + 1;
  }
  return transformedList;
}

class Grid extends DynamicMultiChildLayout {
  Grid(
      {required List<Widget> children,
      required int rowCellCount,
      required double padding,
      super.key})
      : super(
            delegate:
                GridDelegate(rowCellCount: rowCellCount, padding: padding),
            children: transformList(children));
}

/*
Widget grid(
    {required List<Widget> children,
    required int rowCellCount,
    required double padding}) {
  List<Widget> transformedList = [];
  int key = 1;
  for (Widget widget in children) {
    transformedList.add(LayoutId(id: key, child: widget));
    key = key + 1;
  }
  return CustomMultiChildLayout(
      delegate: GridDelegate(rowCellCount: rowCellCount, padding: padding),
      children: transformedList);
}
*/