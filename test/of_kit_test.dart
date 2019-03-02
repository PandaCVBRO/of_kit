import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:of_kit/of_kit.dart';

void main() {
  const MethodChannel channel = MethodChannel('of_kit');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OfKit.platformVersion, '42');
  });
}
