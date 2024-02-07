import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '/Provider/auth_notifier.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFECEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBarの高さを80に設定
        child: SafeArea(
          child: Container(
            height: 146.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0), // 左右のパディング
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // 画面を戻るアクション
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 13), // 左側に23のマージンを追加
                    width: 44,
                    height: 44,
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
                        'ログイン',
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.049),
        child: Column(
          children: <Widget>[
            SizedBox(height: 80),
            SvgPicture.asset(
              'assets/welcomeback.svg',
              width: 334, // 画像の幅
              height: 126, // 画像の高さ
            ),
            SizedBox(height: 72),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_mail.svg',
                  width: 15, // 画像の幅
                  height: 13, // 画像の高さ
                ),
                SizedBox(width: 7), // 間隔を設定
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14, // テキストのサイズを14に設定
                    fontWeight: FontWeight.bold, // テキストを太字に設定
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'メールアドレス',
                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 枠線の色
                    width: 2.0, // 枠線の幅
                  ),
                  borderRadius: BorderRadius.circular(8.5), // 枠線の角の丸みを8.5に設定
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // フォーカス時の枠線の色
                    width: 2.0, // フォーカス時の枠線の幅
                  ),
                  borderRadius: BorderRadius.circular(8.5), // 枠線の角の丸みを8.5に設定
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 33),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_keyword.svg',
                  width: 15, // 画像の幅
                  height: 15, // 画像の高さ
                ),
                SizedBox(width: 7), // 間隔を設定
                Text(
                  'パスワード',
                  style: TextStyle(
                    fontSize: 14, // テキストのサイズを14に設定
                    fontWeight: FontWeight.bold, // テキストを太字に設定
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                hintText: 'パスワード',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 枠線の色
                    width: 2.0, // 枠線の幅
                  ),
                  borderRadius: BorderRadius.circular(8.5), // 枠線の角の丸みを8.5に設定
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // フォーカス時の枠線の色
                    width: 2.0, // フォーカス時の枠線の幅
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 28),
            InkWell(
              onTap: () async {
                String email = emailController.text;
                String password = passwordController.text;
                print('入力されたメールアドレス: $email'); // メールアドレスを出力
                print('入力されたパスワード: $password'); // パスワードを出力
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  User? user = userCredential.user;
                  if (user != null) {
                    final DocumentSnapshot docSnap = await FirebaseFirestore
                        .instance
                        .collection('users')
                        .doc(user.uid)
                        .get();
                    if (docSnap.exists) {
                      print('ニックネーム: ${docSnap.get('nickname')}');
                      // ログイン成功時の処理
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    } else {
                      // ユーザーが存在しない場合の処理
                      print('ユーザーが存在しません');
                    }
                  }
                } catch (e) {
                  print('エラー: $e');
                }
              },
              child: Container(
                width: double.infinity, // Containerを画面幅いっぱいに広げる
                height: 50, // ボタンの高さ
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD64), // ボタンの背景色
                  borderRadius: BorderRadius.circular(29.0), // ボタンの角の丸み
                  border: Border.all(
                    color: Colors.black, // ボタンの枠線の色
                    width: 2.0, // ボタンの枠線の太さ
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 24, 24, 55), // ボタンの影の色
                      spreadRadius: 1, // 影の広がり
                      blurRadius: 0, // 影のぼかし
                      offset: Offset(1, 3), // 影の位置
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ログイン', // ボタンのテキスト
                  style: TextStyle(
                    fontSize: 18, // テキストのサイズ
                    color: Colors.black, // テキストの色
                    fontWeight: FontWeight.bold, // テキストの太さ
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
