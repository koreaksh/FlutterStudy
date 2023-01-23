import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/common/const/data.dart';
import 'package:study/common/layout/default_layout.dart';
import 'package:study/common/view/root_tab.dart';
import 'package:study/user/view/login_screen.dart';

import '../const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void deleteToken() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    final dio = Dio();
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    try {
      final response = await dio.post("http://$ip/auth/token", options: Options(
        headers: {
          "authorization" : "Bearer $refreshToken",
        },
      ),);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => RootTab(),
          ),
              (route) => false);
    } catch(e) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
              (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    // deleteToken();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "asset/img/logo/logo.png",
              width: MediaQuery.of(context).size.width / 2,
            ),
            const SizedBox(
              height: 16.0,
            ),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
