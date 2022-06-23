import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:wxpay/wxpay.dart';
import 'package:wxpay/wxpay_method_channel.dart';
import 'package:wxpay/wxpay_platform_interface.dart';

class MockWxpayPlatform
    with MockPlatformInterfaceMixin
    implements WxpayPlatform {
  @override
  Future<String?> wxpay(String? paymentString, String? universalLink) =>
      Future.value('42');

  @override
  Stream<dynamic> respStream() => const Stream.empty();
}

void main() {
  final WxpayPlatform initialPlatform = WxpayPlatform.instance;

  test('$MethodChannelWxpay is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWxpay>());
  });

  test('getPlatformVersion', () async {
    Wxpay wxpayPlugin = Wxpay();
    MockWxpayPlatform fakePlatform = MockWxpayPlatform();
    WxpayPlatform.instance = fakePlatform;

    expect(await wxpayPlugin.wxpay('', ''), '42');
  });
}
