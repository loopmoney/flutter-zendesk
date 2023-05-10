import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zendesk/flutter_zendesk.dart';
import 'package:flutter_zendesk/flutter_zendesk_method_channel.dart';
import 'package:flutter_zendesk/flutter_zendesk_platform.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZendeskFlutterCombinationPlatform
    with MockPlatformInterfaceMixin
    implements FlutterZendeskPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterZendeskPlatform initialPlatform =
      FlutterZendeskPlatform.instance;

  test('$MethodChannelFlutterZendesk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterZendesk>());
  });

  test('getPlatformVersion', () async {
    FlutterZendesk zendeskFlutterCombinationPlugin = FlutterZendesk();
    MockZendeskFlutterCombinationPlatform fakePlatform =
        MockZendeskFlutterCombinationPlatform();
    FlutterZendeskPlatform.instance = fakePlatform;

    expect(await zendeskFlutterCombinationPlugin.getPlatformVersion(), '42');
  });
}
