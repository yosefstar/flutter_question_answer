import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_question_answer/Pages/first_page.dart';
import 'package:flutter_question_answer/Pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/firebase_initializer.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  // ここでバックグラウンドで受信したメッセージを処理します
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(
    ProviderScope(
      // ProviderScopeでアプリケーションをラップ
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.notoSansTextTheme(
          Theme.of(context).textTheme,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.orange,
        ),
      ),
      title: 'Flutter Demo',
      initialRoute: '/', // initial screen route
      routes: {
        '/': (context) => FirstPage(),
        '/homePage': (context) =>
            HomePage(), // set registration screen as initial screen// set route for home screen
      },
      // routerConfig: _appRouter.config(),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'), // 画像ファイルのパスを指定
              fit: BoxFit.cover, // 画像が全画面になるように設定
            ),
          ),
          child: child,
        );
      },
    );
  }
}
