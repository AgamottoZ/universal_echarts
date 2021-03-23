import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'echarts_script.dart';

class OptionalSizedChild extends StatelessWidget {
  final double? width, height;
  final Widget Function(double?, double?) builder;

  const OptionalSizedChild({
    required this.width,
    required this.height,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (width != null && height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: builder(width, height),
      );
    }
    return LayoutBuilder(
      builder: (context, dimens) {
        final w = width ?? dimens.maxWidth;
        final h = height ?? dimens.maxHeight;
        return SizedBox(
          width: w,
          height: h,
          child: builder(w, h),
        );
      },
    );
  }
}

String wrapHtml(String option) {
  return """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- including ECharts file -->
    <script>$echartsScript</script>
    <title>Document</title>
</head>
<body>
    <div id="main" style="width:600px; height:400px;"></div>
<script type="text/javascript">
        // based on prepared DOM, initialize echarts instance
        var myChart = echarts.init(document.getElementById('main'));

        // specify chart configuration item and data
        var option = $option;

        // use configuration item and data specified to show chart
        myChart.setOption(option);
    </script>
</body>
</html>
  """;
}

String html2Md(String src) => html2md.convert(src);

String md2Html(String src) => markdownToHtml(src);

bool isUrl(String src) =>
    src.startsWith('https://') || src.startsWith('http://');

bool isValidHtml(String src) =>
    src.contains('<html>') && src.contains('</html>');
