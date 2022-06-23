import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wxpay/wxpay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _payResult = 'Unknown';
  final _wxpayPlugin = Wxpay();

  late final StreamSubscription<dynamic> _respSubs;

  @override
  void initState() {
    super.initState();
    _respSubs = _wxpayPlugin.platformInstance.respStream().listen((event) {
      Map map = event;
      setState(() {
        _payResult = map.toString();
      });
    });
  }

  @override
  void dispose() {
    _respSubs.cancel();
    super.dispose();
  }

  Future<void> startPay() async {
    String payResult;
    try {
      var paymentString =
          "{\"appid\":\"wx0d48a98252a2fe7a\",\"timestamp\":\"1655969283\",\"noncestr\":\"N8QCV_pW1YCyQsnj-4LamAJF7iQtiS6y\",\"package\":\"Sign=WXPay\",\"partnerid\":\"1408261902\",\"prepayid\":\"wx2315280309551019b620be68a309200000\",\"sign\":\"C7BEFF93A538CD7A62A92BD4F6B29071\"}";
      payResult = await _wxpayPlugin.wxpay(
              paymentString, 'https://mp-test.everonet.com/demo/') ??
          'Unknown payment result';
    } on PlatformException {
      payResult = 'Failed to get pay result.';
    }

    if (!mounted) return;

    setState(() {
      _payResult = payResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Payment result: $_payResult\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: startPay,
          child: const Icon(Icons.share_outlined),
        ),
      ),
    );
  }
}
