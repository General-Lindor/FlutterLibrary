// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';

class NinftyConstraints extends BoxConstraints {
  static double stdWidth = 100.0;
  static double stdHeight = 5.0;
  NinftyConstraints([BoxConstraints? otherConstraints])
      : super(
            minWidth: otherConstraints?.minWidth ?? 0.0,
            minHeight: otherConstraints?.minHeight ?? 0.0,
            maxWidth: otherConstraints?.maxWidth ?? double.infinity,
            maxHeight: otherConstraints?.maxHeight ?? double.infinity);

  ///Returns the size that both satisfies the constraints and is as close as possible to the given size.
  @override
  Size constrain(Size size) {
    double width = min(max(size.width, minWidth), maxWidth);
    width = ((width.isInfinite) ? stdWidth : width);
    double height = min(max(size.height, minHeight), maxHeight);
    height = ((height.isInfinite) ? stdHeight : height);
    return Size(width, height);
  }

  ///Returns the size that both satisfies the constraints and is as close as possible to the given width and height.
  @override
  Size constrainDimensions(double width, double height) {
    double newWidth = min(max(width, minWidth), maxWidth);
    newWidth = ((newWidth.isInfinite) ? stdWidth : newWidth);
    double newHeight = min(max(height, minHeight), maxHeight);
    newHeight = ((newHeight.isInfinite) ? stdHeight : newHeight);
    return Size(newWidth, newHeight);
  }

  ///Returns the width that both satisfies the constraints and is as close as possible to the given width.
  @override
  double constrainWidth([double width = double.infinity]) {
    double newWidth = min(max(width, minWidth), maxWidth);
    newWidth = ((newWidth.isInfinite) ? stdWidth : newWidth);
    return newWidth;
  }

  ///Returns the height that both satisfies the constraints and is as close as possible to the given height.
  @override
  double constrainHeight([double height = double.infinity]) {
    double newHeight = min(max(height, minHeight), maxHeight);
    newHeight = ((newHeight.isInfinite) ? stdHeight : newHeight);
    return newHeight;
  }

  ///Returns a size that attempts to meet the following conditions, in order:
  @override
  Size constrainSizeAndAttemptToPreserveAspectRatio(Size size) {
    return constrain(size);
  }
}
