import 'dart:convert';
import 'dart:io';

import 'package:fluoroscopy_tool/store/globalFunction.dart';
import 'package:fluoroscopy_tool/store/globalData.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 示例：使用本地存储

class MideaApi {
  static const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static final Dio _dioWebus = Dio(
    BaseOptions(
        baseUrl: env == 'dev'
            ? 'https://us-test.mideaibp.com/api/apps-device-cloud/v1/'
            : 'https://us.ibuildinghvac.com/api/apps-device-cloud/v1/',
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {'language': 'zh-CN'}),
  );

  static final Dio _dioWeb = Dio(
    BaseOptions(
      baseUrl: 'https://$apiHost/api/mibp-basic-ota/v1/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://$apiHost/api/apps-device-cloud/v1/',
      connectTimeout: Duration(seconds: 5 * 60),
      receiveTimeout: Duration(seconds: 5 * 60),
    ),
  );

  // 初始化（建议在应用启动时调用）
  static Future<void> init() async {
    print(apiHost);
    // 添加请求拦截器（可在此处获取动态令牌，如从本地存储）
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, handler) {
          // 检查响应数据中的 errorCode
          if (response.data is Map && response.data.containsKey('errorCode')) {
            final int errorCode = response.data['errorCode'];
            final String errorMsg = response.data['errorMsg'] ?? '';

            // 处理未登录错误
            if (errorCode == 1001) {
              tologout(); // 调用登出方法
              return handler.reject(DioError(
                requestOptions: response.requestOptions,
                error: '未登录: $errorMsg',
              ));
            }
          }

          return handler.next(response);
        },
        onError: (DioError error, handler) {
          // 处理网络错误
          print('API 请求错误: ${error.message}');
          return handler.next(error);
        },
        onRequest: (RequestOptions options, handler) async {
          // 示例：从本地存储获取 sso-session（需提前初始化 SharedPreferences）
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? ssoSession = prefs.getString('token');

          if (ssoSession != null && ssoSession.isNotEmpty) {
            options.headers['sso-session'] = ssoSession; // 添加头部
            options.headers['sso_session_id'] = ssoSession; // 添加头部

            options.headers['app-id'] = '1002'; // 添加头部
          } else {
            // 处理未登录情况（如跳转登录页）
            print('sso-session 未获取到，可能未登录');
          }

          return handler.next(options); // 继续处理请求
        },
      ),
    );

    _dioWeb.interceptors.add(
      InterceptorsWrapper(
        onResponse: (Response response, handler) {
          // 检查响应数据中的 errorCode
          if (response.data is Map && response.data.containsKey('errorCode')) {
            final int errorCode = response.data['errorCode'];
            final String errorMsg = response.data['errorMsg'] ?? '';

            // 处理未登录错误
            if (errorCode == 1001) {
              // tologout(); // 调用登出方法
              return handler.reject(DioError(
                requestOptions: response.requestOptions,
                error: '未登录: $errorMsg',
              ));
            }
          }

          return handler.next(response);
        },
        onError: (DioError error, handler) {
          // 处理网络错误
          print('API 请求错误: ${error.message}');
          return handler.next(error);
        },
        onRequest: (RequestOptions options, handler) async {
          // 示例：从本地存储获取 sso-session（需提前初始化 SharedPreferences）
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? ssoSession = prefs.getString('token');

          if (ssoSession != null && ssoSession.isNotEmpty) {
            options.headers['sso-session'] = ssoSession; // 添加头部
            options.headers['sso_session_id'] = ssoSession; // 添加头部

            options.headers['app-id'] = '1002'; // 添加头部
          } else {
            // 处理未登录情况（如跳转登录页）
            print('sso-session 未获取到，可能未登录');
          }

          return handler.next(options); // 继续处理请求
        },
      ),
    );
  }

// 获取固件列表
  static Future<Map<dynamic, dynamic>> projectManagerPagePost(
      Map<dynamic, dynamic> data) async {
    final response =
        await _dio.post('/project/projectManagerPagePost', data: data);
    return response.data;
  }

  // 获取设备上报记录
  static Future<Map<dynamic, dynamic>> getDeviceReportRecord(
      Map<dynamic, dynamic> data) async {
    final response = await _dio.get(
        '/professionalTools/getDeviceReportRecord?uid=${data['uid']}',
        data: data);
    return response.data;
  }

  // web - 固件管理
  static Future<Map<dynamic, dynamic>> getChipsList(
      Map<dynamic, dynamic> data) async {
    final response = await _dioWeb.post('/user/components/list', data: data);
    return response.data;
  }

  // web - 固件详情
  static Future<Map<dynamic, dynamic>> getChipsGet(
      Map<dynamic, dynamic> data) async {
    final response = await _dioWeb.post('/user/component/get', data: data);
    return response.data;
  }

  // web - 固件详情
  static Future<Map<dynamic, dynamic>> getChipsPackageList(
      Map<dynamic, dynamic> data) async {
    final response = await _dioWeb.post('/user/packages/list', data: data);
    return response.data;
  }

  // web - 固件下载
  static Future<Map<dynamic, dynamic>> getChipsDownloadUrl(
      Map<dynamic, dynamic> data) async {
    final response =
        await _dioWeb.post('/user/package/file/downloadUrl/create', data: data);
    return response.data;
  }

  // 水机 - 报告列表
  static Future<Map<dynamic, dynamic>> waterMachineDebuggingPage(
      Map<dynamic, dynamic> data) async {
    final response = await _dio.post('/waterMachineDebugging/page', data: data);
    return response.data;
  }

  // 水机 - 报告上传
  static Future<Map<String, dynamic>> waterMachineDebuggingSubmit(
      Map<String, dynamic> data) async {
    final response =
        await _dio.post('/waterMachineDebugging/submit', data: data);
    return response.data;
  }

  // 水机 - 报告上传
  static Future<Map<String, dynamic>> sendEmail(
      Map<String, dynamic> data) async {
    final response =
        await _dio.post('/professionalTools/sendEmail', data: data);
    return response.data;
  }

  static Future<Map<String, dynamic>> uploadSignatureImage(
      String base64Image) async {
    try {
      // 1. 将 Base64 字符串转换为 Uint8List
      final bytes = base64Decode(
          base64Image.split(',').last); // 处理"data:image/png;base64,"前缀
      final fileName =
          'signature_${DateTime.now().millisecondsSinceEpoch}.jpg'; // 生成唯一文件名

      // 2. 创建 FormData
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });

      // 4. 发送 POST 请求
      final response = await _dio.post(
        '/professionalTools/img/upload',
        data: formData,
      );

      return response.data;
    } catch (e) {
      // 处理异常（如网络错误、服务器错误）
      if (e is DioError) {
        if (e.response?.statusCode == 401) {
          throw Exception('请先登录'); // 处理未认证错误
        }
        throw Exception('网络请求失败：${e.message}');
      }
      throw Exception('上传失败：$e');
    }
  }

  static Future<Map<String, dynamic>> uploadExcelFile(String filePath) async {
    try {
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('文件不存在: $filePath');
      }

      // 2. 创建 FormData
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      // 4. 发送 POST 请求
      final response = await _dio.post(
        '/professionalTools/img/upload',
        data: formData,
      );

      return response.data;
    } catch (e) {
      // 处理异常（如网络错误、服务器错误）
      if (e is DioError) {
        if (e.response?.statusCode == 401) {
          throw Exception('请先登录'); // 处理未认证错误
        }
        throw Exception('网络请求失败：${e.message}');
      }
      throw Exception('上传失败：$e');
    }
  }

  static Future<Map<String, dynamic>> uploadDBFile(String filePath) async {
    try {
      // 检查文件是否存在
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('文件不存在: $filePath');
      }

      // 2. 创建 FormData
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: file.path.split('/').last,
        ),
      });

      // 4. 发送 POST 请求
      final response = await _dio.post(
        '/professionalTools/uploadDBFile',
        data: formData,
      );

      return response.data;
    } catch (e) {
      // 处理异常（如网络错误、服务器错误）
      if (e is DioError) {
        if (e.response?.statusCode == 401) {
          throw Exception('请先登录'); // 处理未认证错误
        }
        throw Exception('网络请求失败：${e.message}');
      }
      throw Exception('上传失败：$e');
    }
  }

  // 测试读取db发送
  static Future<Map<String, dynamic>> getDBAndSend(
      Map<String, dynamic> data) async {
    final response =
        await _dio.post('/professionalTools/getDBAndSend', data: data);
    return response.data;
  }

  // 水机 - 查询水机串口记录
  static Future<Map<String, dynamic>> getWaterSerialPortRecordList(
      Map<String, dynamic> data) async {
    final response = await _dio
        .post('/professionalTools/getWaterSerialPortRecordList', data: data);
    return response.data;
  }

  // 水机 - 上传水机串口记录
  static Future<Map<String, dynamic>> uploadWaterSerialPortRecord(
      Map<String, dynamic> data) async {
    final response = await _dio
        .post('/professionalTools/uploadWaterSerialPortRecord', data: data);
    return response.data;
  }

  // 水机 - 查询水机设备状态
  static Future<Map<String, dynamic>> queryWaterMachineStatus(
      Map<String, dynamic> data) async {
    print('queryWaterMachineStatusUs:' +
        _dio.options.baseUrl +
        '     data:' +
        jsonEncode(data));

    final response = await _dio
        .post('/professionalTools/queryWaterMachineStatus', data: data);
    return response.data;
  }

  // 水机 - 查询水机设备状态
  static Future<Map<String, dynamic>> queryWaterMachineStatusUs(
      Map<String, dynamic> data) async {
    print('queryWaterMachineStatusUs:' +
        _dioWebus.options.baseUrl +
        '     data:' +
        jsonEncode(data));

    final response = await _dioWebus
        .post('/professionalTools/queryWaterMachineStatus', data: data);

    return response.data;
  }

  // 水机 - 查询水机设备状态上报
  static Future<Map<String, dynamic>> saveQueryRecord(
      Map<String, dynamic> data) async {
    final response =
        await _dio.post('/professionalTools/saveQueryRecord', data: data);
    return response.data;
  }

  // 水机 - 查询水机设备状态
  static Future<Map<String, dynamic>> getWaterMachineCheckRecordList(
      Map<String, dynamic> data) async {
    final response = await _dio
        .post('/professionalTools/getWaterMachineCheckRecordList', data: data);
    return response.data;
  }

  // 旧改 - 获取安装图片 {"pageSize":20,"projectCode":"JG25-07-16MD0002","pageIndex":1}
  static Future<Map<String, dynamic>> getFluorineEnergyImgList(
      Map<String, dynamic> data) async {
    final response = await _dio.post('/fluorine/energy/img/list', data: data);
    return response.data;
  }

  // 旧改 - 获取安装图片 {"pageSize":20,"projectCode":"JG25-07-16MD0002","pageIndex":1}
  static Future<Map<String, dynamic>> getFluorineEnergyImgDetail(
      String systemId) async {
    final response = await _dio
        .get('/fluorine/energy/img/detail?systemId=$systemId', data: {});
    return response.data;
  }
}
