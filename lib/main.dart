import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_question_answer/Pages/register_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Pages/first_page.dart';
import 'Pages/home_page.dart';
import 'Pages/profile.dart';
import 'Provider/tab_index_provider.dart';
import 'services/firebase_initializer.dart';
import 'Provider/auth_notifier.dart';

Future<void> _backgroundHandler(RemoteMessage message) async {
  // ここでバックグラウンドで受信したメッセージを処理します
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabIndexProvider()),
        ChangeNotifierProvider(
          create: (context) => AuthNotifier(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(
            create: (context) =>
                UserProfileProvider()), // UserProfileProviderを追加
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
