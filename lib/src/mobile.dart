import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'utils.dart';

class UniversalEcharts {
  UniversalEcharts._();

  static Widget drawChart(String option) {
    return EchartsDevice(option: option);
  }
}

class EchartsDevice extends StatelessWidget {
  final String option;

  final String extraScript;

  final void Function(String message)? onMessage;

  final List<String> extensions;

  final String? theme;

  final bool captureAllGestures;

  final bool captureHorizontalGestures;

  final bool captureVerticalGestures;

  final void Function()? onLoad;

  final double? width, height;

  EchartsDevice({
    Key? key,
    required this.option,
    this.extraScript = '',
    this.onMessage,
    this.extensions = const [],
    this.theme,
    this.captureAllGestures = false,
    this.captureHorizontalGestures = false,
    this.captureVerticalGestures = false,
    this.onLoad,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: width,
      height: height,
      builder: (w, h) {
        return Echarts(
          option: option,
          extraScript: extraScript,
          onMessage: onMessage,
          extensions: extensions,
          theme: theme,
          captureAllGestures: captureAllGestures,
          captureHorizontalGestures: captureHorizontalGestures,
          captureVerticalGestures: captureVerticalGestures,
          onLoad: onLoad,
        );
      },
    );
  }
}
