import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:study/common/const/data.dart';
import 'package:study/common/secure_storage/secure_storage.dart';


final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storeage: storage),
  );

  return dio;
});


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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print("[REQ] [${options.method}] ${options.uri}");

    if (options.headers["accessToken"] == "true") {
      options.headers.remove("accessToken");

      final token = await storeage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({
        "authorization": "Bearer $token",
      });
    }

    super.onRequest(options, handler);
  }

// 2) 응답을 보낼때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("[REP] [${response.requestOptions.method}] ${response.requestOptions.uri}");
    return super.onResponse(response, handler);
  }




// 3) 에러가 났을때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    //401에러가 났을때 (sattus code)
    //토큰을 재발급 받는 시도를하고 토큰이 재발급 되면
    // 다시 새로운 토큰으로 요청을 한다.
    print("[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}");

    final refreshToken = await storeage.read(key: REFRESH_TOKEN_KEY);

    //refreshToken 아예 없으면
    //당연히 에러처리
    if (refreshToken == null) {
      //에러 던지는 방법
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == "/auth/token";

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try {
        final response = await dio.post(
          "http://$ip/auth/token",
          options: Options(
            headers: {
              "authorization": "Bearer $refreshToken",
            },
          ),
        );

        final accessToken = response.data["accessToken"];

        final options = err.requestOptions;
        options.headers.addAll({
          "authorization": "Bearer $accessToken",
        });

        await storeage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        //요청 재전송
        //dio.fetch()
        final resp = await dio.fetch(options);
        return handler.resolve(resp);

      } on DioError catch (e) {
        return handler.reject(e);
      }

      //handler.resolve(response) 를하면 에러가나도 에러가 안난것처럼 처리할 수 있음.
      //handler.reject(err) 를 하면 그냥 그대로 에러처리.
    }
    return handler.reject(err);
  }
}
