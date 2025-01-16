import 'package:flutter_test/flutter_test.dart';
import 'package:purevpn/purevpn.dart';
import 'package:purevpn/purevpn_platform_interface.dart';
import 'package:purevpn/purevpn_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPurevpnPlatform
    with MockPlatformInterfaceMixin
    implements PurevpnPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PurevpnPlatform initialPlatform = PurevpnPlatform.instance;

  test('$MethodChannelPurevpn is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPurevpn>());
  });

  test('getPlatformVersion', () async {
    Purevpn purevpnPlugin = Purevpn();
    MockPurevpnPlatform fakePlatform = MockPurevpnPlatform();
    PurevpnPlatform.instance = fakePlatform;

    expect(await purevpnPlugin.getPlatformVersion(), '42');
  });
}
