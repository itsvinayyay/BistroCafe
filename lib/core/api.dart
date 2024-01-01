import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String BASE_URL = "https://fcm.googleapis.com/fcm/send";
const Map<String, dynamic> HEADERS = {
  'Content-Type': 'application/json; charset=UTF-8',
  'Authorization':
      'key=AAAAKqW61uc:APA91bG8v0vVFd8njGMjuSSH9AAxpwBMbSka-24IzkEjp68aSCn4AG5ApowbwZ2l9-ryMz3-OlxkXPms5ghwWdOwncpLVTc6s43WwJxRuWaXOQRcRDWVtUj9KExCFQLcE3XYAgYO5NUA'
};

class Api {
  final _dio = Dio();

  Api() {
    _dio.options.baseUrl = BASE_URL;
    _dio.options.headers = HEADERS;
    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
      ),
    );
  }

  Dio get sendRequest => _dio;

  Future<void> sendMessage(
      {required String tokenID,
      required String title,
      required String description}) async {
    try {
      await _dio.post(
        "",
        data: jsonEncode({
          'to': tokenID,
          'priority': 'high',
          'notification': {
            'title': title,
            'body': description,
          }
        }),
      );
    } catch (e) {
      log("Error thrown while sending Message in the Send Message");
      rethrow;
    }
  }
}
