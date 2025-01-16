import 'package:flutter/material.dart';
import 'package:purevpn/purevpn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VpnDemo(),
    );
  }
}

class VpnDemo extends StatefulWidget {
  @override
  _VpnDemoState createState() => _VpnDemoState();
}

class _VpnDemoState extends State<VpnDemo> {
  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  Future<void> initPlugin() async {
    try {
      await PureVpn.setSecretKey("your_secret_key");
      await PureVpn.setAccessToken("your_access_token");
      print("Plugin Initialized");
    } catch (e) {
      print("Initialization error: $e");
    }
  }

  Future<void> connectVpn() async {
    try {
      await PureVpn.connectVPN("US", "UDP");
      print("VPN connected");
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Future<void> disconnectVpn() async {
    try {
      await PureVpn.disconnectVPN();
      print("VPN disconnected");
    } catch (e) {
      print("Disconnection error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VPN Plugin Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: connectVpn, child: Text("Connect VPN")),
            ElevatedButton(
                onPressed: disconnectVpn, child: Text("Disconnect VPN")),
          ],
        ),
      ),
    );
  }
}
