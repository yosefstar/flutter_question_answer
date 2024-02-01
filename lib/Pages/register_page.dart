import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_access_test.dart';
import 'profile.dart';
import 'sign_in_page.dart';

class IconSelector extends StatefulWidget {
  final List<String> iconUrls;
  final Function(String) onIconSelected;

  const IconSelector({
    Key? key,
    required this.iconUrls,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  int selectedIconIndex = 0;
  late String iconUrl;

  @override
  void initState() {
    super.initState();
    iconUrl = widget.iconUrls[selectedIconIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 230,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(35, 0), // 右に20ポイント移動
                child: Container(
                  width: 173,
                  height: 173,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // 枠線の色
                      width: 5, // 枠線の幅
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(iconUrl,
                        fit: BoxFit.cover), // カレントユーザーのアイコンを表示
                  ),
                ),
              ),
              Positioned(
                bottom: 0, // 下端に配置
                right: 0, // 右端に配置
                child: SvgPicture.asset(
                  'assets/icon_check_mark.svg',
                  width: 63, // 画像の幅
                  height: 63, // 画像の高さ
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Container(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.iconUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIconIndex = index;
                    iconUrl = widget.iconUrls[index];
                  });
                  widget.onIconSelected(iconUrl);
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // 枠線の色
                        width: 3, // 枠線の幅
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(widget.iconUrls[index],
                          fit: BoxFit.cover), // アイコンを横に並べて表示
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  int selectedIconIndex = 0; // 選択されたアイコンのインデックス
  List<String> iconImages = [
    'icon1',
    'icon2',
    'icon3',
    'icon4',
    'icon5',
    'icon6'
  ];
  List<String> iconUrls = [
    'http://flat-icon-design.com/f/f_object_112/s512_f_object_112_0bg.png',
    'http://flat-icon-design.com/f/f_object_149/s512_f_object_149_0bg.png',
    'http://flat-icon-design.com/f/f_object_174/s512_f_object_174_0bg.png',
    'http://flat-icon-design.com/f/f_object_169/s512_f_object_169_0bg.png',
    'http://flat-icon-design.com/f/f_object_157/s512_f_object_157_2bg.png',
    'http://flat-icon-design.com/f/f_object_111/s512_f_object_111_0bg.png'
  ];

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
                        '新規登録',
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
            IconSelector(
              iconUrls: iconUrls, // アイコンのURLリストを渡す
              onIconSelected: (selectedUrl) {
                // アイコンが選択された時の処理
                setState(() {
                  // ここで選択されたアイコンのURLを使用して何かをする
                  // 例えば、ユーザーのプロフィール画像を更新する
                });
              },
            ),

            SizedBox(
              height: 60,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_nickname.svg',
                  width: 15, // 画像の幅
                  height: 13, // 画像の高さ
                ),
                SizedBox(width: 7), // 間隔を設定
                Text(
                  'ニックネーム',
                  style: TextStyle(
                    fontSize: 14, // テキストのサイズを14に設定
                    fontWeight: FontWeight.bold, // テキストを太字に設定
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 枠線の色
                    width: 1.5, // 枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // フォーカス時の枠線の色
                    width: 1.5, // フォーカス時の枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 8,
            ), //
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 枠線の色
                    width: 1.5, // 枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // フォーカス時の枠線の色
                    width: 1.5, // フォーカス時の枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_keyword.svg',
                  width: 15, // 画像の幅
                  height: 13, // 画像の高さ
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
            SizedBox(
              height: 8,
            ), //
            TextFormField(
              controller: nicknameController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 枠線の色
                    width: 1.5, // 枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // フォーカス時の枠線の色
                    width: 1.5, // フォーカス時の枠線の幅
                  ),
                  borderRadius:
                      BorderRadius.all(Radius.circular(8.5)), // 角の半径を8.5に設定
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            InkWell(
              onTap: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;

                final UserCredential userCredential =
                    await auth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                );
                final User? user = userCredential.user;
                final String uid = user != null ? user.uid : '';

                final userData = <String, dynamic>{
                  "uid": uid,
                  "email": emailController.text,
                  "password": passwordController.text,
                  "nickname": nicknameController.text,
                  "iconUrl": iconUrls[selectedIconIndex],
                  "createdAt": FieldValue.serverTimestamp(), // 選択されたアイコンのURL
                };

                FirebaseFirestore db = FirebaseFirestore.instance;
                try {
                  await db
                      .collection("users")
                      .doc(uid)
                      .set(userData)
                      .then((void value) => print('User added with ID: $uid'));
                  Navigator.of(context)
                      .pushReplacementNamed('/home'); // ホーム画面に遷移
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
                  '新規登録', // ボタンのテキスト
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
