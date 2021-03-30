import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';

import 'utils.dart';

/// Provide function [drawChart] that takes in [option] to
/// draw it on the Device's interface
class UniversalEcharts {
  UniversalEcharts._();

  /// A stub that draw an Echart using flutter_echarts wrapped
  /// within an [OptionalSizedChild] to nicely draw the chart
  /// with or without user inputting the [width] and [height].
  static Widget drawChart(
    String option, {
    String? extraScript,
    Function(String message)? onMessage,
    List<String>? extensions,
    String? theme,
    bool? captureAllGestures,
    bool? captureHorizontalGestures,
    bool? captureVerticalGestures,
    double? width,
    height,
    void Function()? onLoad,
  }) {
    return EchartsDevice(
      option: option,
      extraScript: extraScript ?? '',
      onMessage: onMessage,
      extensions: extensions ?? const [],
      theme: theme,
      captureAllGestures: captureAllGestures ?? false,
      captureHorizontalGestures: captureHorizontalGestures ?? false,
      captureVerticalGestures: captureVerticalGestures ?? false,
      width: width,
      height: height,
      onLoad: onLoad,
    );
  }
}

/// A class using [Echarts] from [flutter_echarts] package, wrapped
/// inside an [OptionalSizedChild] widget to display the chart when
/// [width] and [height] are not provided by the user.
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
    print(extraScript);
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
