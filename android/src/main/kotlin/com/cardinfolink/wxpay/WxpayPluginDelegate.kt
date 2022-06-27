package com.cardinfolink.wxpay

import androidx.annotation.NonNull
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class WxpayPluginDelegate() {

    companion object {
        lateinit var wxapi: IWXAPI
        lateinit var channel: MethodChannel
    }

    fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        if (call.method == "wxpay") {
            val paymentString = call.argument<String>("paymentString")
            val map = jsonToMap(paymentString ?: "{}")
            val appid = map["appid"] as String
            val timestamp = map["timestamp"] as String
            val noncestr = map["noncestr"] as String
            val packageValue = map["package"] as String
            val partnerid = map["partnerid"] as String
            val prepayid = map["prepayid"] as String
            val sign = map["sign"] as String

            wxapi.registerApp(appid)

            val payReq = PayReq()
            payReq.appId = appid
            payReq.timeStamp = timestamp
            payReq.nonceStr = noncestr
            payReq.packageValue = packageValue
            payReq.partnerId = partnerid
            payReq.prepayId = prepayid
            payReq.sign = sign
            wxapi.sendReq(payReq)

            result.success("opening wechat...")

        } else {
            result.notImplemented()
        }
    }

    fun onAttachedToActivity(binding: ActivityPluginBinding) {
        wxapi = WXAPIFactory.createWXAPI(binding.activity, null)
    }

    fun onDetachedFromActivity() {

    }

    private fun jsonToMap(json: String): HashMap<String, Any> {
        val map = HashMap<String, Any>()
        try {
            val jsonObject = JSONObject(json)
            val keys = jsonObject.keys()
            keys.forEach { key ->
                map[key] = jsonObject[key]
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return map
    }
}