// ignore_for_file: file_names

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';

class EventNotification extends Notification {
  final bool tap;
  final int id;
  final TapDownDetails? tapDetails;
  final PointerEnterEvent? enterDetails;

  const EventNotification(
      {required this.id,
      required this.tap,
      this.tapDetails,
      this.enterDetails});
}
