// ignore_for_file: file_names

import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
//import "package:flutter/services.dart";
//import 'package:flutter_layout_descriptive/Layouts/EverythingOnTop.dart';
//import 'package:flutter_layout_descriptive/Layouts/ColumnCenter.dart';
//import 'package:flutter_layout_descriptive/Layouts/Grid.dart';
import 'package:flutter_layout_descriptive/Notifications.dart';
import 'package:flutter_layout_descriptive/Widgets/SelectableTable-Grid.dart';
import 'package:flutter_layout_descriptive/Widgets/SelectableTable-Layout.dart'
    as slayout;
//import 'package:flutter_layout_descriptive/Layouts/FakeGrid.dart';
//import 'dart:ui';
import 'package:flutter_layout_descriptive/utils.dart' as utils;

class SelectableTable extends StatefulWidget {
  const SelectableTable(
      {super.key,
      required this.content,
      required this.rowCellCount,
      this.headerRows = const [],
      this.headerColumns = const []});

  final int rowCellCount;
  final List<String> content;
  final List<int> headerRows;
  final List<int> headerColumns;

  @override
  State<SelectableTable> createState() => _TableState();
}

class _TableState extends State<SelectableTable> {
  int rowCellCount = 0;
  List<String>? content;
  List<bool> selectedStates = [];
  List<bool> selectabilities = [];

  bool multiselect = false;
  List<Size> sizes = [];
  Size size = const Size(0, 0);

  int rowStart = 0;
  int rowEnd = 0;
  int columnStart = 0;
  int columnEnd = 0;
/*
  @override
  void didUpdateWidget(covariant SelectableTable oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
*/
  void reset(int index) {
    setState(() {
      int count = 0;
      for (bool state in selectedStates) {
        if (state) {
          count = count + 1;
        }
      }
      if (!multiselect) {
        for (int i = 0; i < selectedStates.length; i = i + 1) {
          if (i == index) {
            if (count == 1) {
              selectedStates[i] = !(selectedStates[i]);
            } else {
              selectedStates[i] = true;
            }
          } else {
            selectedStates[i] = false;
          }
        }
      } else {
        selectedStates[index] = !(selectedStates[index]);
      }
      List<int> l = utils.indexToPosition(index, rowCellCount);
      rowStart = l[0];
      rowEnd = l[0];
      columnStart = l[1];
      columnEnd = l[1];
    });
  }

  void change(int row, int column) {
    setState(() {
      for (int i = min(rowStart, rowEnd);
          i <= max(rowStart, rowEnd);
          i = i + 1) {
        for (int j = min(columnStart, columnEnd);
            j <= max(columnStart, columnEnd);
            j = j + 1) {
          int currentIndex = utils.positionToIndex(i, j, rowCellCount);
          selectedStates[currentIndex] = !(selectedStates[currentIndex]);
        }
      }
      rowEnd = row;
      columnEnd = column;
      for (int i = min(rowStart, rowEnd);
          i <= max(rowStart, rowEnd);
          i = i + 1) {
        for (int j = min(columnStart, columnEnd);
            j <= max(columnStart, columnEnd);
            j = j + 1) {
          int currentIndex = utils.positionToIndex(i, j, rowCellCount);
          selectedStates[currentIndex] = !(selectedStates[currentIndex]);
        }
      }
    });
  }

  bool notify(EventNotification notification) {
    int index = notification.id;
    bool isTap = notification.tap;
    if (isTap) {
      reset(index);
    } else {
      if (notification.enterDetails!.down) {
        List<int> l = utils.indexToPosition(index, rowCellCount);
        int row = l[0];
        int column = l[1];
        change(row, column);
      }
    }
    return false;
  }

  void keyDetect(KeyEvent event) {
    final label = event.logicalKey.keyLabel;
    if (label.toLowerCase().contains("control")) {
      if (event is KeyDownEvent) {
        setState(() {
          multiselect = true;
        });
      } else if (event is KeyUpEvent) {
        setState(() {
          multiselect = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    rowCellCount = widget.rowCellCount;
    content = widget.content;
    sizes = slayout.textsizes(widget.content, rowCellCount);
    size = slayout.entireSize(sizes, rowCellCount);
    for (int i = 0; i < content!.length; i = i + 1) {
      selectedStates.add(false);
      List<int> l = utils.indexToPosition(i, rowCellCount);
      if (widget.headerRows.contains(l[0])) {
        selectabilities.add(false);
      } else if (widget.headerColumns.contains(l[1])) {
        selectabilities.add(false);
      } else {
        selectabilities.add(true);
      }
    }
  }

  final FocusNode _tableFocusNode = FocusNode();

  void requestFocus(PointerEnterEvent details) {
    _tableFocusNode.requestFocus();
  }

  List<List<int>> get selectedCells {
    List<List<int>> result = [];
    for (int i = 0; i < selectedStates.length; i = i + 1) {
      if (selectedStates[i] & selectabilities[i]) {
        result.add(utils.indexToPosition(i, rowCellCount));
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
        size: size,
        child: KeyboardListener(
            autofocus: false,
            focusNode: _tableFocusNode,
            onKeyEvent: keyDetect,
            child: MouseRegion(
                onEnter: requestFocus,
                child: NotificationListener<EventNotification>(
                    onNotification: notify,
                    child: SelectableGrid(
                        key: ValueKey("${widget.key}Grid"),
                        //key: widget.key,
                        texts: content!,
                        sizes: sizes,
                        //size: size,
                        states: selectedStates,
                        selectabilities: selectabilities,
                        rowCellCount: rowCellCount)))));
  }
}
