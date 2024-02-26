import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_question_answer/Pages/dashboard.dart';
import 'package:flutter_question_answer/auth_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBarの高さを80に設定
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.049,
            ),
            child: SizedBox(
              height: 146.0,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(); // 画面を戻るアクション
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2C4B9),
                        border: Border.all(
                          color: Colors.black, // 枠線の色を白に設定
                          width: 2.0, // 枠線の太さを2.0に設定
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 24, 24, 55), // 影の色を設定
                            spreadRadius: 1, // 影の広がりを設定
                            blurRadius: 0, // 影のぼかしを設定
                            offset: Offset(1, 3), // 影の位置を設定// 影の位置を設定
                          ),
                        ], // 角の丸み
                      ),
                      child: Image.asset('assets/back_arrow.png'), // 画像を使用
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: 56),
                        child: Text(
                          '設定',
                          style: TextStyle(
                            fontFamily: 'NotoSansJP', // フォントファミリーを追加
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.049,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1E5), // Containerの背景色を設定
                border: Border.all(
                  color: Colors.black, // 枠線の色
                  width: 1.5, // 枠線の太さ
                ),
                borderRadius: BorderRadius.circular(10), // 角の丸み
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 24, // 幅を設定
                    height: 24, // 高さを設定
                    child: SvgPicture.asset(
                        'assets/icon_notification.svg'), // SVGファイルを表示
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    'アプリからの通知',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _isSwitched,
                    onChanged: (bool value) {
                      setState(() {
                        _isSwitched = value; // スイッチの状態を更新
                      });
                    },
                    activeColor: Colors.black, // スイッチがオンのときの色
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            /// この部分をriverpodで書き換える
            Consumer(
              builder: (context, ref, child) {
                // authStateProviderから認証状態を監視
                final userAsyncValue = ref.watch(authStateNotifierProvider);

                return userAsyncValue.when(
                  data: (User? user) {
                    if (user == null) {
                      // ユーザーがログインしていない場合、新規登録ボタンを表示
                      return ElevatedButton(
                        onPressed: () {
                          // 新規登録処理をここに実装
                        },
                        child: const Text('新規登録'),
                      );
                    } else {
                      // ユーザーがログインしている場合、ログアウトボタンを表示
                      return ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('ログアウト'),
                      );
                    }
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text('エラーが発生しました'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void logout(BuildContext context) {
  FirebaseAuth.instance.signOut().then((_) {
    // ログアウト後、ログインページに遷移
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => DashboardPage()), // LoginPageに遷移する
    );
  }).catchError((error) {
    // エラー処理をここに記述
  });
}
