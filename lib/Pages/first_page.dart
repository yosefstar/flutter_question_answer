import 'package:flutter/material.dart';
import 'package:flutter_question_answer/Pages/dashboard.dart';


class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 3秒後にログインページに遷移
    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DashboardPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500), // アニメーションの持続時間を設定
        ),
      );
    });

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Containerを使用してJPEGを背景に設定
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/test12.jpg'),
                fit: BoxFit.cover, // 画像が画面全体に広がるように設定
              ),
            ),
          ),
          // 他のウィジェット...
        ],
      ),
    );
  }
}
