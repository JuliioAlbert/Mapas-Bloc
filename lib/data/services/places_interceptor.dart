import 'package:dio/dio.dart';

class PlacesInterceptor extends Interceptor {
  final accessToken =
      'pk.eyJ1IjoianVsaWlvYWxiZXJ0OTgiLCJhIjoiY2t5Mmd0MTI2MGtvYTMwdDR3azYwbndzeSJ9.8xsqKi7IfL5qmupWGsx3sQ';
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      "access_token": accessToken,
      "language": "es",
      "country": "mx",
    });

    super.onRequest(options, handler);
  }
}
