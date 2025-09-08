import 'package:flutter/material.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:permission_handler/permission_handler.dart'; // 导入权限插件

class WifiScanner extends StatefulWidget {
  const WifiScanner({super.key});

  @override
  State<WifiScanner> createState() => _WifiScannerState();
}

class _WifiScannerState extends State<WifiScanner> {
  List<WifiNetwork> _wifiList = [];
  bool _isScanning = false;
  String? _connectedSsid;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartScan(); // 初始化时检查权限并扫描
  }

  // 检查并请求位置权限（使用 permission_handler）
  Future<void> _checkPermissionsAndStartScan() async {
    // 检查位置权限（Android 扫描WiFi必须）
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      // 请求位置权限
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      // 权限通过，开始扫描WiFi
      _startScan();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('需要位置权限才能扫描WiFi')),
        );
      }
    }
  }

  // 扫描WiFi列表
  Future<void> _startScan() async {
    setState(() => _isScanning = true);

    // 确保WiFi已开启
    await WiFiForIoTPlugin.setEnabled(true);

    // 扫描WiFi（最新版本返回的是 List<WifiNetwork>）
    List<WifiNetwork> wifiList = await WiFiForIoTPlugin.loadWifiList();

    // 获取当前连接的WiFi名称（去除引号）
    String? connectedSsid = await WiFiForIoTPlugin.getSSID();
    connectedSsid = connectedSsid?.replaceAll('"', '');

    setState(() {
      _wifiList = wifiList;
      _isScanning = false;
      _connectedSsid = connectedSsid;
    });
  }

  // 连接WiFi
  Future<void> _connectToWifi(String ssid, String password) async {
    try {
      // 断开当前连接
      if (_connectedSsid != null) {
        await WiFiForIoTPlugin.disconnect();
      }

      // 连接WiFi（最新版本的参数格式）
      bool isConnected = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: NetworkSecurity.WPA, // 根据WiFi加密方式选择（WPA/WPA2/WEP等）
        joinOnce: false,
      );

      if (isConnected) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('已连接到 $ssid')),
          );
        }
        setState(() => _connectedSsid = ssid);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('连接失败，请检查密码')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('连接错误: $e')),
        );
      }
    }
  }

  // 断开连接
  Future<void> _disconnect() async {
    try {
      await WiFiForIoTPlugin.disconnect();
      setState(() => _connectedSsid = null);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('已断开连接')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('断开失败: $e')),
        );
      }
    }
  }

  // 显示密码输入框
  void _showPasswordDialog(String ssid) {
    _passwordController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('连接到 $ssid'),
        content: TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'WiFi密码',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _connectToWifi(ssid, _passwordController.text);
            },
            child: const Text('连接'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi 扫描器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _startScan,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isScanning) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_wifiList.isEmpty) {
      return const Center(child: Text('未发现WiFi，请刷新重试'));
    }
    return ListView.builder(
      itemCount: _wifiList.length,
      itemBuilder: (context, index) {
        WifiNetwork wifi = _wifiList[index];
        bool isConnected = _connectedSsid == wifi.ssid;
        return ListTile(
          leading: Icon(
            Icons.wifi,
            color: isConnected ? Colors.green : null,
          ),
          title: Text(wifi.ssid ?? '未知网络'),
          subtitle: Text('信号强度: ${wifi.level} dBm'),
          trailing: isConnected
              ? ElevatedButton(
                  onPressed: _disconnect,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('断开'),
                )
              : IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _showPasswordDialog(wifi.ssid ?? ''),
                ),
        );
      },
    );
  }
}
