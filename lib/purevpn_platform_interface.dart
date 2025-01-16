// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// import 'purevpn_method_channel.dart';
//
// abstract class PurevpnPlatform extends PlatformInterface {
//   /// Constructs a PurevpnPlatform.
//   PurevpnPlatform() : super(token: _token);
//
//   static final Object _token = Object();
//
//   static PurevpnPlatform _instance = MethodChannelPurevpn();
//
//   /// The default instance of [PurevpnPlatform] to use.
//   ///
//   /// Defaults to [MethodChannelPurevpn].
//   static PurevpnPlatform get instance => _instance;
//
//   /// Platform-specific implementations should set this with their own
//   /// platform-specific class that extends [PurevpnPlatform] when
//   /// they register themselves.
//   static set instance(PurevpnPlatform instance) {
//     PlatformInterface.verifyToken(instance, _token);
//     _instance = instance;
//   }
//
//   Future<String?> getPlatformVersion() {
//     throw UnimplementedError('platformVersion() has not been implemented.');
//   }
// }
