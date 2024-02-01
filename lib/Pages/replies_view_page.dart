import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'question_detail.dart';

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 塗りつぶしのスタイルを適用
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke; // 枠線のスタイルを適用

    final path = Path();
    // 左下を起点にし、さらに下げる
    path.moveTo(0, size.height * 1.5); // 高さを少し小さく調整
    // 右下へ線を引くが、上にあげる
    path.lineTo(size.width / 2, size.height * 1); // 高さを少し小さく調整
    // 上中央へ線を引く
    path.lineTo(size.width / 2, size.height * 0.1); // 高さを少し小さく調整
    // 最初の点に戻る
    path.close();

    // 塗りつぶしのパスを描画
    canvas.drawPath(path, paint);
    // 枠線のパスを描画
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SpeechBubblePainterWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 塗りつぶしのスタイルを適用
    // final borderPaint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 1.0
    //   ..style = PaintingStyle.stroke; // 枠線のスタイルを適用

    final path = Path();
    // 左下を起点にし、さらに下げる
    path.moveTo(0, size.height * 1.5); // 高さを少し小さく調整
    // 右下へ線を引くが、上にあげる
    path.lineTo(size.width / 2, size.height * 1); // 高さを少し小さく調整
    // 上中央へ線を引く
    path.lineTo(size.width / 2, size.height * 0.1); // 高さを少し小さく調整
    // 最初の点に戻る
    path.close();

    // 塗りつぶしのパスを描画
    canvas.drawPath(path, paint);
    // 枠線のパスを描画
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class RepliesViewPage extends StatefulWidget {
  final String questionId;
  final String text;

  RepliesViewPage({required this.questionId, required this.text});

  @override
  _RepliesViewPageState createState() => _RepliesViewPageState();
}

class _RepliesViewPageState extends State<RepliesViewPage> {
  Future<String> getIconUrl() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return userData['iconUrl'] ?? '';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xFFFFECEB),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0), // AppBarの高さを80に設定
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
                          '回答の投稿',
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
          body: Padding(
            padding: EdgeInsets.all(16.0),
            // child: Text(widget.text),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 8.0),
                  child: Row(
                    // これを追加
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FutureBuilder<String>(
                                  future: getIconUrl(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator(); // ロード中はスピナーを表示
                                    } else {
                                      return Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.0,
                                          ),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(snapshot.data!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Stack(
                                clipBehavior:
                                    Clip.none, // クリップを無効にして、子が親の範囲外に描画できるようにする
                                children: [
                                  Positioned(
                                    left: -8, // 吹き出しの位置を左に調整
                                    bottom: 15, // 吹き出しの位置を上に調整
                                    child: CustomPaint(
                                      painter: SpeechBubblePainter(),
                                      size: const Size(20, 10), // 吹き出しのサイズを指定
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Text(
                                      widget.text,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Positioned(
                                    left: -8, // 吹き出しの位置を左に調整
                                    bottom: 15, // 吹き出しの位置を上に調整
                                    child: CustomPaint(
                                      painter: SpeechBubblePainterWhite(),
                                      size: const Size(20, 10), // 吹き出しのサイズを指定
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Container(
                  child: InkWell(
                    onTap: () async {
                      User? currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(currentUser.uid)
                            .get();
                        Map<String, dynamic> userData =
                            userDoc.data() as Map<String, dynamic>;

                        await FirebaseFirestore.instance
                            .collection('questions')
                            .doc(widget.questionId)
                            .collection('replies')
                            .add({
                          'createdAt': FieldValue.serverTimestamp(),
                          'iconUrl': userData['iconUrl'],
                          'nickname': userData['nickname'],
                          'text': widget.text,
                          'uid': currentUser.uid,
                        });

                        BuildContext context = this.context;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuestionDetailPage(
                                questionId: widget.questionId),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 387,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0CD64), // 背景色を設定
                        borderRadius:
                            BorderRadius.circular(29.0), // 角の丸みを半径29に設定
                        border: Border.all(
                            color: Colors.black, width: 2.0), // 枠線を黒に設定、太さ2.0
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 24, 24, 55), // 影の色を設定
                            spreadRadius: 1, // 影の広がりを設定
                            blurRadius: 0, // 影のぼかしを設定
                            offset: Offset(1, 3), // 影の位置を設定
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '確認',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black, // テキストの色を設定
                          fontWeight: FontWeight.bold,
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
    );
  }

  void saveReply(String text) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference replies =
        FirebaseFirestore.instance.collection('replies');
    await replies.add({
      'questionId': widget.questionId,
      'text': text,
      'uid': currentUser?.uid, // ユーザーIDを保存
      'userName': currentUser?.displayName, // ユーザー名を保存
      // 必要に応じて他のフィールドを追加
    });
  }

  Future<String> getNickname(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['nickname'] ?? '匿名';
  }
}
