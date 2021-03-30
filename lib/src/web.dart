import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'utils.dart';

/// Provide function [drawChart] that takes in [option] to
/// draw it on the Web's interface
class UniversalEcharts {
  UniversalEcharts._();

  /// A stub that draw an Echart using inner frame within a custom HTML
  /// and continuously updated echart scripts, wrapped within
  /// an [OptionalSizedChild] to nicely draw the chart
  /// with or without user inputting the [width] and [height].
  static Widget drawChart(
    String option, {
    String? extraScript,
    Function(String message)? onMessage,
    List<String>? extensions,
    String? theme,
    double? width,
    height,
    void Function()? onLoad,
  }) {
    return EchartsWeb(
      option: option,
      extraScript: extraScript,
      onMessage: onMessage,
      extensions: extensions,
      theme: theme,
      width: width,
      height: height,
      onLoad: onLoad,
    );
  }
}

/// The [EchartsWeb] class passing the user options to the HtmlView.
/// The chart is displayed using [IFrameElement] with the use of an
/// [OptionalSizedChild] in case the [width] and [height] is not set
/// by the user.
class EchartsWeb extends StatefulWidget {
  final String option;

  final String? extraScript;

  final void Function(String message)? onMessage;

  final List<String>? extensions;

  final String? theme;

  final double? width, height;

  final void Function()? onLoad;

  EchartsWeb({
    Key? key,
    required this.option,
    this.extraScript = '',
    this.onMessage,
    this.extensions = const [],
    this.theme,
    this.onLoad,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  _EchartsWebState createState() => _EchartsWebState();
}

class _EchartsWebState extends State<EchartsWeb> {
  var _jsScript = '';

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final _iframe = _iframeElementMap[widget.key];
      if (_iframe != null) {
        _iframe.onLoad.listen((event) {
          if (widget.onLoad != null) {
            widget.onLoad!();
          }
        });
      }
    });
    final extensionsStr = ((widget.extensions?.length ?? 0) > 0)
        ? widget.extensions
            ?.reduce((value, element) => (value) + '\n' + (element))
        : '';
    final themeStr = widget.theme != null ? '\'${widget.theme}\'' : 'null';
    _jsScript = '''
      $extensionsStr
      var chart = echarts.init(document.getElementById('chart'), ${themeStr});
      ${this.widget.extraScript}
      chart.setOption(${widget.option}, true);
    ''';
    super.initState();
  }

  @override
  void didUpdateWidget(EchartsWeb oldWidget) {
    if (oldWidget.height != widget.height) {
      if (mounted) setState(() {});
    }
    if (oldWidget.width != widget.width) {
      if (mounted) setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: widget.width,
      height: widget.height,
      builder: (w, h) {
        _setup(w, h);
        return AbsorbPointer(
          child: RepaintBoundary(
            child: HtmlElementView(
              key: widget.key,
              viewType: 'iframe-echart',
            ),
          ),
        );
      },
    );
  }

  static final _iframeElementMap = Map<Key, html.IFrameElement>();

  /// Setup the [IFrameElement] within the html view
  void _setup(double? width, double? height) {
    final key = widget.key ?? ValueKey('');

    ui.platformViewRegistry.registerViewFactory('iframe-echart', (int viewId) {
      if (_iframeElementMap[key] == null) {
        _iframeElementMap[key] = html.IFrameElement();
      }
      final element = _iframeElementMap[key]!
        ..style.border = '0'
        ..allowFullscreen = false
        ..height = height?.toInt().toString()
        ..width = width?.toInt().toString();
      String _src = "data:text/html;charset=utf-8," +
          Uri.encodeComponent(wrapHtml(_jsScript));
      element..src = _src;
      return element;
    });
  }
}
