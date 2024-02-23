import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'quesiton_view_page.dart';

class QuestionCreatePage extends StatefulWidget {
  @override
  _QuestionCreatePageState createState() => _QuestionCreatePageState();
}

class _QuestionCreatePageState extends State<QuestionCreatePage> {
  // ここにメンバ変数とメソッドを移動します
  final _text1Controller = TextEditingController();
  final _text2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFFFECEB),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.0512),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左端に配置
                children: <Widget>[
                  SizedBox(
                    height: 56,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE8A3), // 背景色をFFE8A3に設定
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5, // 枠線の色を黒に設定
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 枠の角を丸くする
                    ),
                    width: 46.0, // 幅を46に設定
                    height: 20.0,
                    child: Text(
                      'だれ',
                      style: TextStyle(
                        color: Colors.black, // テキストの色を黒に設定
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold, // フォントサイズを適切に設定
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        // TextFormFieldをExpandedウィジェットでラップする
                        child: TextFormField(
                          controller: _text1Controller,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black, // 枠線の色
                                width: 1.5, // 枠線の幅
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8.5)), // 角の半径を8.5に設定
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue, // フォーカス時の枠線の色
                                width: 1.5, // フォーカス時の枠線の幅
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(8.5)), // 角の半径を8.5に設定
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value != null && value.length > 12) {
                              return '12文字以内で入力してください。';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'に、',
                        style: TextStyle(
                          color: Colors.black, // テキストの色を黒に設定
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold, // フォントサイズを適切に設定
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 44,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE8A3), // 背景色をFFE8A3に設定
                      border: Border.all(
                        color: Colors.black,
                        width: 1.5, // 枠線の色を黒に設定
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 枠の角を丸くする
                    ),
                    width: 58.0, // 幅を46に設定
                    height: 20.0,
                    child: Text(
                      'なんて',
                      style: TextStyle(
                        color: Colors.black, // テキストの色を黒に設定
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold, // フォントサイズを適切に設定
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _text2Controller,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black, // 枠線の色
                          width: 1.5, // 枠線の幅
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.5)), // 角の半径を8.5に設定
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue, // フォーカス時の枠線の色
                          width: 1.5, // フォーカス時の枠線の幅
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(8.5)), // 角の半径を8.5に設定
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value != null && value.length > 12) {
                        return '12文字以内で入力してください。';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    'って言われたらなんて返す？',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // テキストを太字に設定
                      fontSize: 19.0, // フォントサイズを19に設定
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () async {
                      // Formのkeyを使用してvalidateを呼び出す
                      if (_formKey.currentState!.validate()) {
                        // バリデーションが成功した場合の処理
                        User? currentUser = FirebaseAuth.instance.currentUser;
                        if (currentUser != null) {
                          String uid = currentUser.uid;
                          // usersコレクションからiconUrlを取得
                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(uid)
                              .get();
                          String iconUrl = userDoc['iconUrl'] ?? '';

                          // 取得したiconUrlを次のページに渡す
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionViewPage(
                                text1: _text1Controller.text,
                                text2: _text2Controller.text,
                                iconUrl: iconUrl,
                              ),
                            ),
                          );
                        }
                      } else {
                    
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
                        '確認', // ボタンのテキスト
                        style: TextStyle(
                          fontSize: 18, // テキストのサイズ
                          color: Colors.black, // テキストの色
                          fontWeight: FontWeight.bold, // テキストの太さ
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop(); // 画面を戻るアクション
            },
            child: Container(
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
                    offset: Offset(1, 3), // 影の位置を設定
                  ),
                ],
              ),
              child: Image.asset('assets/back_arrow.png'), // 画像を使用
            ),
          ),
          const Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 56),
                child: Text(
                  '質問の投稿',
                  style: TextStyle(
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0); // AppBarの高さを80に設定
}
