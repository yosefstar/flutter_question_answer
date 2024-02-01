import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import 'replies_view_page.dart';

class RepliesCreatePage extends StatefulWidget {
  final String questionId;

  RepliesCreatePage({required this.questionId});

  @override
  _RepliesCreatePageState createState() => _RepliesCreatePageState();
}

class _RepliesCreatePageState extends State<RepliesCreatePage> {
  final TextEditingController controller = TextEditingController();

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
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: <Widget>[
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('questions')
                      .doc(widget.questionId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('エラーが発生しました');
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> questionData =
                          snapshot.data!.data() as Map<String, dynamic>;

                      final textPainter = TextPainter(
                        text: TextSpan(
                          text: questionData['text1'],
                          style: const TextStyle(
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        textDirection: TextDirection.ltr,
                      );
                      textPainter.layout();
                      return QuestionCard(
                          textPainter: textPainter, questionData: questionData);
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 36),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'あなたの回答',
                    style: TextStyle(
                      fontSize: 14.0, // フォントサイズを14に設定
                      fontWeight: FontWeight.bold, // テキストを太字に設定
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 387, // 幅を387に設定
                  // 高さはTextFieldのmaxLinesとpaddingで調整
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: '1文字〜60文字で入力してください。',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.5),
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.5),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5, // 高さを近似的に調整するための行数
                  ),
                ),
                Container(
                  width: 387, // 幅を387に設定
                  height: 174, // 高さを174に設定
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepliesViewPage(
                            questionId: widget.questionId,
                            text: controller.text,
                          ),
                        ),
                      );
                    },
                    // InkWellの子要素をここに配置
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getNickname(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['nickname'] ?? '匿名';
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.textPainter,
    required this.questionData,
  });

  final TextPainter textPainter;
  final Map<String, dynamic> questionData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1E5), // 背景色を設定
        border: Border.all(
          color: Colors.black, // 枠線の色を黒に設定
          width: 2.0, // 枠線の太さを2.0に設定
        ),
        borderRadius: BorderRadius.circular(10.0), // 角の丸みを半径10に設定
        boxShadow: [
          // 影を追加
          BoxShadow(
            color:
                const Color.fromARGB(255, 24, 24, 55).withOpacity(1), // 影の色を設定
            spreadRadius: 0.1, // 影の広がりを設定
            blurRadius: 1, // 影のぼかしを設定
            offset: const Offset(3, 3), // 影の位置を設定
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 174.0,
              padding: const EdgeInsets.only(left: 23, top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // SizedBox(height: 18.0),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 24,
                                  child: Container(
                                    width: textPainter.width,
                                    height: 6.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFB99BF),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5), // 線の厚み分だけテキストを下にずらす
                                  child: Text(
                                    questionData['text1'],
                                    style: const TextStyle(
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Text(
                        'に、',
                        style: TextStyle(
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.bold, // 太字に設定
                          fontSize: 21,
                          color: Colors.black, // テキストの色を指定
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 42.0,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF), // 背景色を設定
                      border: Border.all(
                        color: Colors.black, // 枠線の色を黒に設定
                        width: 2.0, // 枠線の太さを2.0に設定
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 角の丸みを半径10に設定
                    ), // コンテナの高さを42に設定

                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 4.0),
                        Text(
                          questionData['text2'],
                          style: const TextStyle(
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.bold, // 太字に設定
                            fontSize: 21, // テキストサイズを22に設定
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 11.0),
                  const Text(
                    'って言われたらなんて返す？',
                    style: TextStyle(
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.bold, // 太字に設定
                      fontSize: 21, // テキストサイズを22に設定
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 174.0,
            width: 51.0,
            margin: const EdgeInsets.only(right: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 21),
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(questionData['uid'])
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text('エラーが発生しました');
                          } else {
                            Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 43.0, // 直径43ピクセル
                                  height: 43.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(userData['iconUrl']),
                                      fit: BoxFit.scaleDown,
                                    ),
                                    border: Border.all(
                                      color: Colors.black, // 線の色を設定
                                      width: 1.0, // 線の幅を設定
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 24, 24, 55)
                                            .withOpacity(1),
                                        spreadRadius: 0.3,
                                        blurRadius: 0,
                                        offset: const Offset(1.5, 2.5),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '15分前',
                        style: TextStyle(
                          fontSize: 10, // フォントサイズを10に設定
                          color: Color(0xFF000000), // テキストの色を黒(#000000)に設定
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(
                    right: 1,
                    bottom: 15,
                  ),
                  child: Image.asset('assets/icon_bookmark.png'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
