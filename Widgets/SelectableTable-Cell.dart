// ignore_for_file: file_names

//import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
//import 'package:flutter/rendering.dart';
//import "package:flutter/services.dart";
//import 'package:flutter_layout_descriptive/Layouts/EverythingOnTop.dart';
//import 'package:flutter_layout_descriptive/Layouts/ColumnCenter.dart';
//import 'package:flutter_layout_descriptive/Layouts/Grid.dart';
//import 'package:flutter_layout_descriptive/Layouts/FakeGrid.dart';
//import 'dart:ui';
//import 'package:flutter_layout_descriptive/utils.dart' as utils;
import 'package:flutter_layout_descriptive/Notifications.dart';

class SelectableBox extends StatelessWidget {
  const SelectableBox(
      {super.key,
      required this.id,
      required this.text,
      required this.size,
      required this.selectability,
      required this.isSelected});

  final int id;
  final String text;
  final Size size;
  final bool selectability;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;
    if (selectability) {
      return SizedBox.fromSize(
          size: size,
          child: MouseRegion(
              onEnter: (PointerEnterEvent details) =>
                  EventNotification(id: id, tap: false, enterDetails: details)
                    ..dispatch(context),
              child: SizedBox.fromSize(
                  size: size,
                  child: GestureDetector(
                      onTapDown: (TapDownDetails details) => EventNotification(
                          id: id, tap: true, tapDetails: details)
                        ..dispatch(context),
                      child: Container(
                          width: size.width,
                          height: size.height,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: (isSelected == true
                                  ? scheme.primaryContainer
                                  : scheme.surface),
                              border: Border.all(color: scheme.primary)),
                          child: Text(text, style: TextStyle(color: (isSelected == true ? scheme.onPrimaryContainer : scheme.onSurface), fontSize: 15.0)))))));
    } else {
      return Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: scheme.primary, border: Border.all(color: scheme.scrim)),
          child: Text(text,
              style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)));
    }
  }
}
