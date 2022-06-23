import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'wxpay_platform_interface.dart';

/// An implementation of [WxpayPlatform] that uses method channels.
class MethodChannelWxpay extends WxpayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final methodChannel = const MethodChannel('wxpay')
    ..setMethodCallHandler(_handler);

  final StreamController<dynamic> _respStreamController =
      StreamController<dynamic>.broadcast();

  @override
  Future<String?> wxpay(String? paymentString, String? universalLink) async {
    final version = await methodChannel.invokeMethod<String>('wxpay',
        {'paymentString': paymentString, 'universalLink': universalLink});
    return version;
  }

  @override
  Stream<dynamic> respStream() => _respStreamController.stream;

  Future<dynamic> _handler(MethodCall call) async {
    log(call.method);
    if (call.method == 'onResp') {
      final Map<String, dynamic> data =
          (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
      _respStreamController.add(data);
    }
  }
}
