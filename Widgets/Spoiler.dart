// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_layout_descriptive/Widgets/SuperScaffold.dart';

void main() => runApp(const SpoilerExample());

class SpoilerExample extends StatelessWidget {
  const SpoilerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Zeiterfassungssystem",
        theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal, brightness: Brightness.dark),
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          //textTheme: const TextTheme(),
          useMaterial3: true,
        ),
        home: SuperScaffold(
            context: context,
            title: "Spoiler",
            child: const Column(children: [Spoiler(), Spoiler(), Spoiler()])));
  }
}

class Spoiler extends StatefulWidget {
  const Spoiler(
      {super.key,
      this.text = "Open Spoiler",
      this.child = const FlutterLogo(size: 200.0)});

  final String text;
  final Widget child;

  @override
  State<Spoiler> createState() => SpoilerState();
}

/// [AnimationController]s can be created with `vsync: this` because of [TickerProviderStateMixin].
class SpoilerState extends State<Spoiler> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
    reverseCurve: Curves.fastOutSlowIn,
  );

  bool isOpen = false;
  bool showBorder = true;

  void onAction() async {
    if (isOpen) {
      setState(() {
        _controller.animateBack(0.0);
        isOpen = false;
      });
      await Future.delayed(const Duration(milliseconds: 490));
      setState(() {
        showBorder = true;
      });
    } else {
      setState(() {
        _controller.animateTo(1.0);
        isOpen = true;
        showBorder = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    ColorScheme scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: const Alignment(0.0, 0.0),
          padding: const EdgeInsets.all(4.0),
          child: Row(children: [
            Icon(isOpen ? Icons.arrow_drop_down : Icons.arrow_right,
                color: scheme.primary),
            TextButton(
              onPressed: onAction,
              child: Text(
                widget.text,
                //style: TextStyle(color: Colors.lightBlue.shade900),
              ),
            ),
          ]),
        ),
        Container(
          alignment: const Alignment(0.0, 0.0),
          padding: const EdgeInsets.all(4.0),
          decoration: (showBorder
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: scheme.outlineVariant,
                    ),
                  ),
                )
              : null),
          child: SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            axisAlignment: -1.0,
            child: Container(
                padding: const EdgeInsets.all(4.0),
                alignment: const Alignment(-1.0, 0.0),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  border: Border.all(color: scheme.primary),
                ),
                child: widget.child),
          ),
        ),
      ],
    );
  }
}
