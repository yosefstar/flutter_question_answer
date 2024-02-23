import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'question_detail.dart';

class QuestionViewPage extends StatelessWidget {
  final String text1;
  final String text2;
  final String iconUrl;

  QuestionViewPage(
      {Key? key,
      required this.text1,
      required this.text2,
      required this.iconUrl})
      : super(key: key);

  final String userUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<String> getUserIconUrl() async {
    if (userUid.isEmpty) return '';

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .get();
      return userDoc['iconUrl'] ?? '';
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text1,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    return Material(
      color: Color(0xFFFFECEB),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.0512),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 子ウィジェットを左端に配置
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 175.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ), // 横の余白を大きくする
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2E8), // コンテナの色を変更
                      border: Border.all(
                        color: Colors.black, // 枠の色
                        width: 1.5, // 枠の幅
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 丸みの半径
                      boxShadow: [
                        // 影を追加
                        BoxShadow(
                          color: const Color.fromARGB(255, 24, 24, 55)
                              .withOpacity(1), // 影の色を設定
                          spreadRadius: 0.1, // 影の広がりを設定
                          blurRadius: 1, // 影のぼかしを設定
                          offset: const Offset(3, 3), // 影の位置を設定
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 23, bottom: 19),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 18.0),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Stack(
                                            children: <Widget>[
                                              Positioned(
                                                top: 24,
                                                child: Container(
                                                  width: textPainter.width,
                                                  height: 6.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFB99BF),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom:
                                                        5), // 線の厚み分だけテキストを下にずらす
                                                child: Text(
                                                  text1,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFFFFF), // 背景色を設定
                                    border: Border.all(
                                      color: Colors.black, // 枠線の色を黒に設定
                                      width: 2.0, // 枠線の太さを2.0に設定
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        10.0), // 角の丸みを半径10に設定
                                  ), // コンテナの高さを42に設定

                                  child: Column(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.end,
                                    children: <Widget>[
                                      const SizedBox(height: 4.0),
                                      Text(
                                        text2,
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
                              const SizedBox(height: 21),
                              Container(
                                width: 43.0, // 直径43ピクセル
                                height: 43.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(iconUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: Colors.black, // 線の色を設定
                                    width: 1.0, // 線の幅を設定
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color.fromARGB(255, 24, 24, 55)
                                              .withOpacity(1),
                                      spreadRadius: 0.3,
                                      blurRadius: 0,
                                      offset: const Offset(1.5, 2.5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '15分前',
                                style: TextStyle(
                                  fontSize: 10.0, // フォントサイズを10に設定
                                ),
                              ),
                              const SizedBox(height: 53),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    // Firestoreのインスタンスを取得
                    FirebaseFirestore firestore = FirebaseFirestore.instance;

                    // 現在の日時を取得
                    DateTime now = DateTime.now();

                    // questionsコレクションにデータを追加し、ドキュメントIDを取得
                    DocumentReference docRef =
                        await firestore.collection('questions').add({
                      'created_at': Timestamp.fromDate(now), // 現在の日時
                      'iconUrl': iconUrl, // このページで表示されているアイコンのURL
                      'text1': text1, // このページで表示されているテキスト1
                      'text2': text2, // このページで表示されているテキスト2
                      'uid': userUid, // 現在のユーザーのUID
                    });

                    // ドキュメントIDを取得
                    String docId = docRef.id;

                    // QuestionDetailPageに遷移し、戻ることを禁止
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => QuestionDetailPage(
                          questionId: docId, // docIdを遷移先に渡す
                          showPostedMessage: true,
                        ),
                      ),
                    );
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
                      '投稿', // ボタンのテキスト
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
