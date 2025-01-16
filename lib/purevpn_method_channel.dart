// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart';
//
// import 'purevpn_platform_interface.dart';
//
// /// An implementation of [PurevpnPlatform] that uses method channels.
// class MethodChannelPurevpn extends PurevpnPlatform {
//   /// The method channel used to interact with the native platform.
//   @visibleForTesting
//   final methodChannel = const MethodChannel('purevpn');
//
//   @override
//   Future<String?> getPlatformVersion() async {
//     final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
//     return version;
//   }
// }
