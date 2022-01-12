import 'package:dio/dio.dart';

class TrafficInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoianVsaWlvYWxiZXJ0OTgiLCJhIjoiY2t5Mmd0MTI2MGtvYTMwdDR3azYwbndzeSJ9.8xsqKi7IfL5qmupWGsx3sQ';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      "alternatives": true,
      "geometries": "polyline6",
      "overview": "simplified",
      "steps": false,
      "access_token": accessToken,
    });

    super.onRequest(options, handler);
  }
}
