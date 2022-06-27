package com.cardinfolink.wxpay.wxapi

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import com.cardinfolink.wxpay.WxpayPluginDelegate
import com.tencent.mm.opensdk.modelbase.BaseReq
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelpay.PayResp
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler

class WXPayEntryActivity : Activity(), IWXAPIEventHandler {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WxpayPluginDelegate.wxapi.handleIntent(intent, this)
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        WxpayPluginDelegate.wxapi.handleIntent(intent, this)
    }

    override fun onReq(req: BaseReq?) {

    }

    override fun onResp(resp: BaseResp?) {

        val map = HashMap<String, Any>()
        map["errorCode"] = resp?.errCode ?: -1
        if (resp?.errStr != null) {
            map["errorMsg"] = resp.errStr
        }
        if (resp is PayResp) {
            map["returnKey"] = resp.returnKey
        }
        WxpayPluginDelegate.channel.invokeMethod("onResp", map)
    }

}