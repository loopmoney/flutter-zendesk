import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_zendesk_method_channel.dart';

abstract class FlutterZendeskPlatform extends PlatformInterface {
  /// Constructs a ZendeskFlutterCombinationPlatform.
  FlutterZendeskPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterZendeskPlatform _instance = MethodChannelFlutterZendesk();

  /// The default instance of [FlutterZendeskPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterZendesk].
  static FlutterZendeskPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterZendeskPlatform] when
  /// they register themselves.
  static set instance(FlutterZendeskPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
