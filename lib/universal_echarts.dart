export 'package:universal_echarts/src/unsupported.dart'
    if (dart.library.html) 'package:universal_echarts/src/web.dart'
    if (dart.library.io) 'package:universal_echarts/src/mobile.dart';
