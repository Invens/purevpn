package com.appmontizesg.purevpn;

import androidx.annotation.NonNull;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.atom.sdk.android.AtomManager;
import com.atom.sdk.android.VPNStateListener;
import com.atom.sdk.android.exceptions.AtomException;
import com.atom.sdk.android.models.AtomConfiguration;
import com.atom.sdk.android.models.AtomNotification;
import com.atom.sdk.android.models.ConnectionDetails;
import com.atom.sdk.android.models.Country;
import com.atom.sdk.android.models.Protocol;
import com.atom.sdk.android.models.VPNCredentials;
import com.atom.sdk.android.models.VPNProperties;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PureVpn implements FlutterPlugin, MethodChannel.MethodCallHandler {

  private MethodChannel channel;
  private Context context;

  private AtomManager atomManager;
  private String secretKey;
  private String accessToken;
  private VPNCredentials vpnCredentials;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "vpn_plugin_channel");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "setSecretKey":
        setSecretKey(call.argument("secretKey"));
        result.success(null);
        break;

      case "setAccessToken":
        setAccessToken(call.argument("accessToken"));
        result.success(null);
        break;

      case "setVpnCredentials":
        setVpnCredentials(call.argument("username"), call.argument("password"));
        result.success(null);
        break;

      case "fetchServerDetails":
        fetchServerDetails(result);
        break;

      case "initialize":
        initializeAtomSdk(result);
        break;

      case "connect":
        connectVPN(call.argument("country"), call.argument("protocol"), result);
        break;

      case "disconnect":
        disconnectVPN(result);
        break;

      default:
        result.notImplemented();
        break;
    }
  }

  private void setSecretKey(String secretKey) {
    this.secretKey = secretKey;
  }

  private void setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  private void setVpnCredentials(String username, String password) {
    this.vpnCredentials = new VPNCredentials(username, password);
  }

  private void fetchServerDetails(MethodChannel.Result result) {
    List<Map<String, Object>> serverList = new ArrayList<>();
    AtomManager.getInstance().getCountries((countries) -> {
      for (Country country : countries) {
        Map<String, Object> server = new HashMap<>();
        server.put("id", country.getId());
        server.put("name", country.getName());
        server.put("protocols", country.getProtocols());
        serverList.add(server);
      }
      result.success(serverList);
    }, (exception) -> {
      Log.e("VpnPlugin", "Error fetching server details: " + exception.getMessage());
      result.error("FETCH_SERVER_ERROR", exception.getMessage(), null);
    });
  }

  private void initializeAtomSdk(MethodChannel.Result result) {
    if (secretKey == null || secretKey.isEmpty()) {
      result.error("INIT_ERROR", "Secret key is not set", null);
      return;
    }

    AtomNotification notification = new AtomNotification.Builder(
            1,
            "VPN Connection",
            "You are connected securely",
            R.drawable.ic_launcher_foreground,
            0xFF0000FF
    ).build();

    AtomConfiguration configuration = new AtomConfiguration.Builder(secretKey)
            .setVpnInterfaceName("My VPN Plugin")
            .setNotification(notification)
            .build();

    atomManager = AtomManager.initialize(context, configuration, () -> Log.d("VpnPlugin", "Atom SDK Initialized"));

    result.success(null);
  }

  private void connectVPN(String country, String protocol, MethodChannel.Result result) {
    if (vpnCredentials == null) {
      result.error("CONNECT_ERROR", "VPN credentials are not set", null);
      return;
    }

    atomManager.setVPNCredentials(vpnCredentials);

    VPNProperties.Builder vpnPropertiesBuilder = new VPNProperties.Builder(new Country(country), new Protocol(protocol));
    VPNProperties vpnProperties = vpnPropertiesBuilder.build();

    atomManager.connect(vpnProperties, new VPNStateListener() {
      @Override
      public void onConnected(ConnectionDetails connectionDetails) {
        Log.d("VpnPlugin", "VPN Connected: " + connectionDetails.toString());
        result.success("VPN Connected");
      }

      @Override
      public void onDisconnected(ConnectionDetails connectionDetails) {
        Log.d("VpnPlugin", "VPN Disconnected: " + connectionDetails.toString());
      }

      @Override
      public void onConnecting(VPNProperties vpnProperties, AtomConfiguration atomConfiguration) {
        Log.d("VpnPlugin", "VPN Connecting...");
      }

      @Override
      public void onDialError(AtomException exception, ConnectionDetails connectionDetails) {
        Log.e("VpnPlugin", "VPN Connection Error: " + exception.getMessage());
        result.error("CONNECT_ERROR", exception.getMessage(), null);
      }

      @Override
      public void onUnableToAccessInternet(AtomException exception, ConnectionDetails connectionDetails) {
        Log.e("VpnPlugin", "No Internet Access: " + exception.getMessage());
      }

      @Override
      public void onDisconnecting(ConnectionDetails connectionDetails) {
        Log.d("VpnPlugin", "VPN Disconnecting...");
      }

      @Override
      public void onRedialing(AtomException exception, ConnectionDetails connectionDetails) {
        Log.d("VpnPlugin", "VPN Redialing...");
      }
    });
  }

  private void disconnectVPN(MethodChannel.Result result) {
    atomManager.disconnect(context);
    result.success("VPN Disconnected");
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
