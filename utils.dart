// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";

BuildContext? currentContext;

void setContext(BuildContext context) {
  currentContext = context;
}

void message(String text, {Color? textColor}) {
  print(text);
  try {
    ColorScheme scheme = Theme.of(currentContext!).colorScheme;
    Color tc = textColor ?? scheme.onErrorContainer;
    ScaffoldMessenger.of(currentContext!).showSnackBar(SnackBar(
        backgroundColor: scheme.errorContainer,
        content: Text(text,
            style: TextStyle(
                color: tc, fontSize: 15, fontWeight: FontWeight.bold))));
  } catch (e) {
    print("$e");
  }
}

Future<AppExitResponse> exitApplication(AppExitType exitType,
    [int exitCode = 0]) async {
  try {
    final Map<String, Object?>? result =
        await SystemChannels.platform.invokeMethod<Map<String, Object?>>(
      "System.exitApplication",
      <String, Object?>{"type": exitType.name, "exitCode": exitCode},
    );
    if (result == null) {
      return AppExitResponse.cancel;
    }
    switch (result["response"]) {
      case "cancel":
        return AppExitResponse.cancel;
      case "exit":
        return AppExitResponse.exit;
      default:
        return AppExitResponse.exit;
    }
  } catch (e) {
    message(e.toString());
    return AppExitResponse.cancel;
  }
}

Map<String, dynamic> stringToTime(String timeString) {
  Map<String, dynamic> result = {
    "sign": "+",
    "days": 0,
    "hours": 0,
    "minutes": 0,
    "seconds": 0
  };
  try {
    String sign;
    int days;
    int hours;
    int minutes;
    int seconds;
    if (timeString.substring(0, 1) == "-") {
      sign = "-";
      timeString = timeString.substring(1);
    } else {
      sign = "+";
    }
    List<String> timeList = timeString.split(":");
    if (timeList.length != 3) {
      throw const FormatException(
          "Expected a string that can be parsed into time of format +/-hh:mm:ss.ssssss");
    }
    hours = int.parse(timeList[0]);
    days = hours ~/ 24;
    hours = hours - (24 * days);
    minutes = int.parse(timeList[1]);
    seconds = (double.parse(timeList[2])).floor();

    result = {
      "sign": sign,
      "days": days,
      "hours": hours,
      "minutes": minutes,
      "seconds": seconds
    };
  } catch (e) {
    message(e.toString());
  }
  return result;
}

Map<String, String> stringToDate(String dateString) {
  Map<String, String> result = {"day": "01", "month": "01", "year": "0001"};
  try {
    String day;
    String month;
    String year;
    List<String> dateList = dateString.split("-");
    if (dateList.length != 3) {
      throw const FormatException(
          "Expected a string that can be parsed into a Date of format dd-mm-yyyy");
    }
    day = dateList[0];
    month = dateList[1];
    year = dateList[2];

    result = {
      "day": day,
      "month": month,
      "year": year,
    };
  } catch (e) {
    message(e.toString());
  }
  return result;
}

int positionToIndex(int row, int column, int rowCellCount) {
  return rowCellCount * row + column;
}

List<int> indexToPosition(int index, int rowCellCount) {
  int row = index ~/ rowCellCount;
  int column = index - (row * rowCellCount);
  return [row, column];
}

class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  String toString() => "$runtimeType: ($first, $second)";
}
