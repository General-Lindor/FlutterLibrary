// ignore_for_file: file_names, avoid_print

import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_layout_descriptive/utils.dart" as utils;

class SuperScroller extends StatelessWidget {
  const SuperScroller({
    super.key,
    required this.child,
    required this.centerChild,
  });

  final Widget child;
  final bool centerChild;

  double getBodyHeight(BuildContext context) {
    double defaultHeight = MediaQuery.of(context).size.height;
    try {
      defaultHeight = max(
          defaultHeight -
              AppBar.preferredHeightFor(
                  context, Scaffold.of(context).widget.appBar!.preferredSize),
          0.1);
      defaultHeight = defaultHeight.isFinite ? defaultHeight : 1.0;
      return defaultHeight;
    } catch (e) {
      utils.message("$e");
      defaultHeight = defaultHeight.isFinite ? defaultHeight : 1.0;
      return defaultHeight;
    }
  }

  double getScreenHeight(BuildContext context) {
    double defaultHeight = MediaQuery.of(context).size.height;
    return defaultHeight.isFinite ? defaultHeight : 1.0;
  }

  double getScreenWidth(BuildContext context) {
    double defaultWidth = MediaQuery.of(context).size.width;
    return defaultWidth.isFinite ? defaultWidth : 1.0;
  }

  @override
  Widget build(BuildContext context) {
    //print("BuildSuperScroller");
    double width = getScreenWidth(context);
    double height = getBodyHeight(context);
    ScrollController controllerVertical = ScrollController();
    ScrollController controllerHorizontal = ScrollController();
    return Scrollbar(
      controller: controllerVertical,
      thumbVisibility: true,
      trackVisibility: true,
      notificationPredicate: (ScrollNotification notification) => true,
      child: Scrollbar(
        controller: controllerHorizontal,
        thumbVisibility: true,
        trackVisibility: true,
        notificationPredicate: (ScrollNotification notification) => true,
        child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: controllerVertical,
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.hardEdge,
              child: SingleChildScrollView(
                  controller: controllerHorizontal,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                      alignment:
                          (centerChild ? Alignment.center : Alignment.topLeft),
                      children: [
                        Container(
                            width: width,
                            height: height,
                            //color: const Color.fromARGB(255, 64, 68, 75),
                            color: Theme.of(context).colorScheme.background),
                        child
                      ])),
            )),
      ),
    );
  }
}

class SuperScaffold extends StatelessWidget {
  const SuperScaffold(
      {required BuildContext context,
      required this.title,
      required this.child,
      this.centerChild = false,
      this.floatingActionButton,
      this.image,
      super.key});

  final String title;
  final bool centerChild;
  final Image? image;
  final FloatingActionButton? floatingActionButton;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //print("BuildSuperScaffold");
    ColorScheme themeColor = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          backgroundColor: themeColor.primary,
          foregroundColor: themeColor.onPrimary,
          actions: (image == null)
              ? [const FlutterLogo(size: 150)]
              : [image!, const FlutterLogo(size: 150)],
          title: Text(title),
        ),
        body: SuperScroller(
          centerChild: centerChild,
          child: child,
        ),
        floatingActionButton: floatingActionButton);
  }
}
