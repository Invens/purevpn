import 'package:flutter/services.dart';

class VpnPlugin {
  static const MethodChannel _channel = MethodChannel('vpn_plugin_channel');

  /// Sets the Atom SDK secret key.
  static Future<void> setSecretKey(String secretKey) async {
    await _channel.invokeMethod('setSecretKey', {'secretKey': secretKey});
  }

  /// Sets the access token for the Atom SDK.
  static Future<void> setAccessToken(String accessToken) async {
    await _channel.invokeMethod('setAccessToken', {'accessToken': accessToken});
  }

  /// Sets VPN credentials (username and password).
  static Future<void> setVpnCredentials(
      String username, String password) async {
    await _channel.invokeMethod('setVpnCredentials', {
      'username': username,
      'password': password,
    });
  }

  /// Fetches the server details from the Atom SDK.
  static Future<List<Map<String, dynamic>>> fetchServerDetails() async {
    final List<dynamic> servers =
        await _channel.invokeMethod('fetchServerDetails');
    return servers.cast<Map<String, dynamic>>();
  }

  /// Initializes the Atom SDK.
  static Future<void> initialize() async {
    await _channel.invokeMethod('initialize');
  }

  /// Connects to the VPN.
  ///
  /// [country]: The country code (e.g., "US").
  /// [protocol]: The protocol (e.g., "UDP" or "IKEV").
  static Future<void> connectVPN(String country, String protocol) async {
    await _channel.invokeMethod('connect', {
      'country': country,
      'protocol': protocol,
    });
  }

  /// Disconnects the VPN connection.
  static Future<void> disconnectVPN() async {
    await _channel.invokeMethod('disconnect');
  }
}
