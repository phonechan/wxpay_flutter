package com.cardinfolink.wxpay

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** WxpayPlugin */
class WxpayPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel

    private val delegate = WxpayPluginDelegate()

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "wxpay")
        WxpayPluginDelegate.channel = channel
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        delegate.onMethodCall(call, result)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        delegate.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        delegate.onDetachedFromActivity()
    }
}
