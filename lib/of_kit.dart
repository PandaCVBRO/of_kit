import 'dart:async';

import 'package:flutter/services.dart';

class OfKit {
  static const MethodChannel _channel =
      const MethodChannel('of_kit');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
