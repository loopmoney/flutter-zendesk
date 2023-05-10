import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_zendesk_platform.dart';

/// An implementation of [MethodChannelFlutterZendesk] that uses method channels.
class MethodChannelFlutterZendesk extends FlutterZendeskPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_zendesk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
