// ignore_for_file: file_names,, avoid_print

//import "dart:io";

import "package:flutter/material.dart";
//import "package:flutter/scheduler.dart";
//import 'package:flutter/rendering.dart';
import "package:flutter/services.dart";

class FiniteTextField extends StatelessWidget {
  const FiniteTextField(
      {super.key, this.keyboardType, this.inputFormatters, this.onChanged});

  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    //FocusNode fn = FocusNode();
    //fn.requestFocus;
    return SizedBox(
        width: 500.0,
        height: 20.0,
        child: TextField(
            //focusNode: fn,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            autofocus: false,
            onChanged: onChanged));
  }
}

class FiniteDropdownMenu extends SizedBox {
  static List<DropdownMenuEntry> transformList(List<String>? entries) {
    List<DropdownMenuEntry> transformedList = <DropdownMenuEntry>[];
    if (entries != null) {
      int i = 0;
      for (String entry in entries) {
        transformedList.add(DropdownMenuEntry(value: i, label: entry));
        i = i + 1;
      }
    }
    return transformedList;
  }

  FiniteDropdownMenu({List<String>? entries, Widget? label, super.key})
      : super(
            width: 200.0,
            height: 60.0,
            child: DropdownMenu(
              dropdownMenuEntries: transformList(entries),
              label: label,
            ));
}
