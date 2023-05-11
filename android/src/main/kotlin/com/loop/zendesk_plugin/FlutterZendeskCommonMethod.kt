package com.loop.zendesk_plugin

import android.util.Log
import io.flutter.plugin.common.MethodCall
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


     fun initializeAnonymous(
        urlString: String,
        appId: String,
        clientId: String,
        nameIdentifier: String,
    ) {
          
            Zendesk.INSTANCE.init(this, urlString, appId, clientId)
            val identity: Identity = AnonymousIdentity()
            Zendesk.INSTANCE.setIdentity(nameIdentifier)
            Support.INSTANCE.init(Zendesk.INSTANCE)
            plugin.isInitialize = true
          channel.invokeMethod(initializeSuccess, null)
    }


      fun showRequestList(call: MethodCall) {
        val osPlatForm = CustomField(4419801704337, "Android")
        val osVersion = CustomField( 4419806853649, call.argument<String>("osVersion") ?: "")
        val devModel = CustomField( 4419802058513, call.argument<String>("model") ?: "")
        val userId = CustomField( 4419806761105, call.argument<String>("id") ?: "")
        val appVersion  = CustomField( 4419806867601, call.argument<String>("appVersion") ?: "")
        Log.e("TAG", "requestHelpCenterActivity: os "+osPlatForm.value)
        Log.e("TAG", "requestHelpCenterActivity: osVersion "+call.argument<String>("osVersion") )
        Log.e("TAG", "requestHelpCenterActivity: devModel "+call.argument<String>("model"))
        Log.e("TAG", "requestHelpCenterActivity: userId "+call.argument<String>("id"))
        Log.e("TAG", "requestHelpCenterActivity: appVersion "+call.argument<String>("appVersion"))

        val x =  RequestActivity.builder().withCustomFields(Arrays.asList(osPlatForm,osVersion,devModel,userId,appVersion)).config()
        RequestListActivity.builder().show(plugin.activity!!,x)
    }

   
}