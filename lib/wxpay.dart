import 'wxpay_platform_interface.dart';

class Wxpay {
  Future<String?> wxpay(String? paymentString, String? universalLink) {
    return WxpayPlatform.instance.wxpay(paymentString, universalLink);
  }

  WxpayPlatform get platformInstance => WxpayPlatform.instance;
}
