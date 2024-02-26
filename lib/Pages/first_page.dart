import 'package:flutter/material.dart';
import 'package:flutter_question_answer/Pages/dashboard.dart';
import 'package:flutter_question_answer/auth_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_question_answer/Pages/home_page.dart'; // AuthStateNotifierのパスを適切に設定

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            final userAsyncValue = ref.watch(authStateNotifierProvider);

            // ユーザーのログイン状態に基づいて適切なページに遷移
            WidgetsBinding.instance.addPostFrameCallback((_) {
              userAsyncValue.maybeWhen(
                data: (user) {
                  Future.delayed(Duration(seconds: 1), () {
                    if (user != null) {
                      // ユーザーがログインしている場合、ダッシュボードページに遷移
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  HomePage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    } else {
                      // ユーザーがログインしていない場合、ログインページに遷移
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DashboardPage(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                                opacity: animation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    }
                  });
                },
                orElse: () => const SizedBox.shrink(),
              );
            });

            // ローディングインジケータを表示
            return Scaffold(
              body: Stack(
                children: <Widget>[
                  // Containerを使用してJPEGを背景に設定
                  Container(
                    decoration: const BoxDecoration(
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
          },
        ),
      ),
    );
  }
}
