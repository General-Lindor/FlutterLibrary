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

class Consize extends Size {
  double workaroundWidth;
  double workaroundHeight;

  Consize(this.workaroundWidth, this.workaroundHeight)
      : super(workaroundWidth, workaroundHeight);

  set width(double newWidth) {
    workaroundWidth = newWidth;
  }

  set height(double newHeight) {
    workaroundHeight = newHeight;
  }

  @override
  double get width {
    return workaroundWidth;
  }

  @override
  double get height {
    return workaroundHeight;
  }

  void constrain(BoxConstraints constraints) {
    width = constraints.constrainWidth(width);
    height = constraints.constrainHeight(height);
  }
}

////////////
//DELEGATE//
////////////
class TreeDelegate extends DynamicMultiChildDelegate {
  final double padding;
  final double indentation;

  TreeDelegate({required this.padding, required this.indentation});

  BoxConstraints gridConstraints = NinftyConstraints();

  (double, double) actualWork(Object key, double width, double height,
      [double indent = 0]) {
    Size wsize = layoutChild(key, gridConstraints);
    wsize = Size(wsize.width + (2 * padding), wsize.height + (2 * padding));
    positionChild(key, Offset(indent + padding, height + padding));
    width = max(width, indent + wsize.width);
    height = height + wsize.height;
    return (width, height);
  }

  @override
  Size performLayout() {
    // `size` is the size of the `CustomMultiChildLayout` itself.
    double width = 0.0;
    double height = 0.0;

    int currentKey = 0;
    while (true) {
      if (hasChild(currentKey)) {
        (width, height) = actualWork(currentKey, width, height);
        currentKey = currentKey + 1;
      } else if (hasChild("TREE$currentKey")) {
        (width, height) =
            actualWork("TREE$currentKey", width, height, indentation);
        currentKey = currentKey + 1;
      } else {
        break;
      }
    }
    return Size(width, height);
  }

  @override
  bool shouldRelayout(TreeDelegate oldDelegate) {
    return ((oldDelegate.getSize(oldDelegate.gridConstraints)) !=
        (getSize(gridConstraints)));
  }
}

////////
//GRID//
////////

List<Widget> transformList(List<Widget> children) {
  List<Widget> transformedList = [];
  int key = 0;
  for (Widget widget in children) {
    if (widget is Tree) {
      transformedList.add(LayoutId(id: "TREE$key", child: widget));
    } else {
      transformedList.add(LayoutId(id: key, child: widget));
    }
    key = key + 1;
  }
  return transformedList;
}

class Tree extends DynamicMultiChildLayout {
  Tree(
      {required List<Widget> children,
      required double padding,
      double indentation = 100.0,
      super.key})
      : super(
            delegate: TreeDelegate(padding: padding, indentation: indentation),
            children: transformList(children));
}
