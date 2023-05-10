package com.loop.zendesk_plugin

import io.flutter.plugin.common.MethodChannel
import zendesk.core.JwtIdentity
import zendesk.core.Zendesk
import zendesk.support.CustomField
import zendesk.support.Support
import zendesk.support.guide.HelpCenterActivity
import zendesk.support.request.RequestActivity
import zendesk.support.requestlist.RequestListActivity
import java.util.Arrays

class FlutterZendeskCommonMethod (private val plugin: FlutterZendeskPlugin, private val channel: MethodChannel) {

    companion object {
        const val tag = "[ZendeskMessaging]"
        const val initializeSuccess: String = "initialize_success"

    }

    fun initialize(
        urlString: String,
        appId: String,
        clientId: String,
        nameIdentifier: String,
    ) {
        println("$tag - clientId== - $clientId")

        Zendesk.INSTANCE.init( plugin.activity!!, urlString, appId, clientId)
        Zendesk.INSTANCE.setIdentity(JwtIdentity(nameIdentifier))
        Support.INSTANCE.init(Zendesk.INSTANCE)


        plugin.isInitialize = true


        channel.invokeMethod(initializeSuccess, null)
    }

    fun showHelpCenter(){
        HelpCenterActivity.builder().show(plugin.activity!!);
    }

    fun showRequestList(){
        val osPlatForm = CustomField(4419801704337, "Android")

        val x =  RequestActivity.builder().withCustomFields(Arrays.asList(osPlatForm)).config()
        RequestListActivity.builder().show(plugin.activity!!,x)
    }

    fun showRequest(){
        RequestActivity.builder().show(plugin.activity!!)
    }
}