import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:study/common/const/data.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storeage;

  CustomInterceptor({
    required this.storeage,
  });

  // 1) 요청을 보낼때
  // 요청이 보내질때마다
  // 만약에 요청의 Header에 accessToken : true 라는 값이 있다면
  // 실제 토큰을 가져와서 추가한다.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print("[REQ] [${options.method}] ${options.uri}");

    if(options.headers["accessToken"] == "true") {
      options.headers.remove("accessToken");

      final token = await storeage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        "authorization" : "Bearer $token",
      });
    }

    super.onRequest(options, handler);
  }
// 2) 응답을 보낼때
// 3) 에러가 났을때

}
