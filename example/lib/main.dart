import 'package:flutter/material.dart';
import 'package:purevpn/purevpn.dart'; // Replace with your actual plugin name

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VPN Plugin Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VpnExamplePage(),
    );
  }
}

class VpnExamplePage extends StatefulWidget {
  @override
  _VpnExamplePageState createState() => _VpnExamplePageState();
}

class _VpnExamplePageState extends State<VpnExamplePage> {
  final VpnPlugin _vpnPlugin = VpnPlugin();

  String _status = 'Disconnected';
  List<String> _servers = [];
  String _selectedServer = '';
  String _secretKey = 'your_secret_key_here'; // Replace with your Secret Key
  String _accessToken =
      'your_access_token_here'; // Replace with your Access Token
  String _vpnUsername = 'your_username_here'; // Replace with your VPN Username
  String _vpnPassword = 'your_password_here'; // Replace with your VPN Password

  @override
  void initState() {
    super.initState();
    _initializeVpn();
  }

  Future<void> _initializeVpn() async {
    try {
      await _vpnPlugin.setSecretKey(secretKey: _secretKey);
      _fetchServers();
    } catch (e) {
      print('Error initializing VPN: $e');
    }
  }

  Future<void> _fetchServers() async {
    try {
      final servers = await _vpnPlugin.fetchServers(_accessToken);
      setState(() {
        _servers = servers.map((server) => server['name']).toList();
        if (_servers.isNotEmpty) {
          _selectedServer = _servers[0];
        }
      });
    } catch (e) {
      print('Error fetching servers: $e');
    }
  }

  Future<void> _connectVpn() async {
    try {
      setState(() {
        _status = 'Connecting...';
      });
      await _vpnPlugin.connectVpn(
        username: _vpnUsername,
        password: _vpnPassword,
        server: _selectedServer,
      );
      setState(() {
        _status = 'Connected';
      });
    } catch (e) {
      setState(() {
        _status = 'Connection Failed';
      });
      print('Error connecting VPN: $e');
    }
  }

  Future<void> _disconnectVpn() async {
    try {
      await _vpnPlugin.disconnectVpn();
      setState(() {
        _status = 'Disconnected';
      });
    } catch (e) {
      print('Error disconnecting VPN: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VPN Plugin Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VPN Status: $_status', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            if (_servers.isNotEmpty)
              DropdownButton<String>(
                value: _selectedServer,
                items: _servers
                    .map((server) => DropdownMenuItem(
                          value: server,
                          child: Text(server),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedServer = value!;
                  });
                },
              ),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _connectVpn,
                  child: Text('Connect VPN'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _disconnectVpn,
                  child: Text('Disconnect VPN'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
