import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'flutter_zendesk_platform.dart';

enum ZendeskMessagingMessageType {
  initializeSuccess,
  initializeFailure,
  loginSuccess,
  loginFailure,
  logoutSuccess,
  logoutFailure,
}

/// Used by ZendeskMessaging to attach custom async observers
class ZendeskMessagingObserver {
  final bool removeOnCall;
  final Function(Map? args) func;

  ZendeskMessagingObserver(this.removeOnCall, this.func);
}

class FlutterZendesk {
  static const MethodChannel _channel = MethodChannel('flutter_zendesk');
  static const channelMethodToMessageType = {
    "initialize_success": ZendeskMessagingMessageType.initializeSuccess,
    "initialize_failure": ZendeskMessagingMessageType.initializeFailure,
    "login_success": ZendeskMessagingMessageType.loginSuccess,
    "login_failure": ZendeskMessagingMessageType.loginFailure,
    "logout_success": ZendeskMessagingMessageType.logoutSuccess,
    "logout_failure": ZendeskMessagingMessageType.logoutFailure,
  };
  static Function(ZendeskMessagingMessageType type, Map? arguments)? _handler;

  /// Allow end-user to use local observer when calling some methods
  static final Map<ZendeskMessagingMessageType, ZendeskMessagingObserver>
      _observers = {};

  Future<String?> getPlatformVersion() {
    return FlutterZendeskPlatform.instance.getPlatformVersion();
  }

  /// Attach a global observer for incoming messages
  static void setMessageHandler(
      Function(ZendeskMessagingMessageType type, Map? arguments)? handler) {
    _handler = handler;
  }

  static Future<void> initialize(
      {required String urlString,
      required String appId,
      required String clientId,
      required String nameIdentifier}) async {
    if (appId.isEmpty || clientId.isEmpty) {
      debugPrint('ZendeskMessaging - initialize - ids can not be empty');
      return;
    }

    if (nameIdentifier.isEmpty) {
      debugPrint('ZendeskMessaging - initialize - name id can not be empty');
      return;
    }

    try {
      _channel.setMethodCallHandler(
          _onMethodCall); // start observing channel messages
      await _channel.invokeMethod('initialize', {
        'urlString': urlString,
        'appId': appId,
        'clientId': clientId,
        'nameIdentifier': nameIdentifier,
      });
    } catch (e) {
      debugPrint('ZendeskMessaging - initialize - Error: $e}');
    }
  }

  static Future<void> anonymousIdentity(
      {required String urlString,
      required String appId,
      required String clientId,
      required String nameIdentifier}) async {
    if (appId.isEmpty || clientId.isEmpty) {
      debugPrint('ZendeskMessaging - initialize - ids can not be empty');
      return;
    }

    if (nameIdentifier.isEmpty) {
      debugPrint('ZendeskMessaging - initialize - name id can not be empty');
      return;
    }

    try {
      _channel.setMethodCallHandler(
          _onMethodCall); // start observing channel messages
      await _channel.invokeMethod('anonymousIdentity', {
        'urlString': urlString,
        'appId': appId,
        'clientId': clientId,
        'nameIdentifier': nameIdentifier,
      });
    } catch (e) {
      debugPrint('ZendeskMessaging - initialize - Error: $e}');
    }
  }

  static Future<void> showRequestList(
      {required String id,
      required String appVersion,
      required String osVersion,
      required String model}) async {
    try {
      await _channel.invokeMethod('showRequestList', {
        'id': id,
        'appVersion': appVersion,
        'osVersion': osVersion,
        'model': model,
      });
    } catch (e) {
      debugPrint('ZendeskMessaging - showRequestList - Error: $e}');
    }
  }

  static Future<dynamic> _onMethodCall(final MethodCall call) async {
    if (!channelMethodToMessageType.containsKey(call.method)) {
      return;
    }

    final ZendeskMessagingMessageType type =
        channelMethodToMessageType[call.method]!;
    var globalHandler = _handler;
    if (globalHandler != null) {
      globalHandler(type, call.arguments);
    }

    // call all observers too
    final ZendeskMessagingObserver? observer = _observers[type];
    if (observer != null) {
      observer.func(call.arguments);
      if (observer.removeOnCall) {
        _setObserver(type, null);
      }
    }
  }

  /// Add an observer for a specific type
  static _setObserver(
      ZendeskMessagingMessageType type, Function(Map? args)? func,
      {bool removeOnCall = true}) {
    if (func == null) {
      _observers.remove(type);
    } else {
      _observers[type] = ZendeskMessagingObserver(removeOnCall, func);
    }
  }
}
