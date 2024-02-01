import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import 'replies_create_page.dart';

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 塗りつぶしのスタイルを適用
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
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

class QuestionDetailPage extends StatefulWidget {
  final String questionId;
  final bool showPostedMessage; // ここにパラメータを追加

  QuestionDetailPage(
      {Key? key, required this.questionId, this.showPostedMessage = false})
      : super(key: key); // コンストラクタを修正

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  bool showMessage = false;

  @override
  void initState() {
    super.initState();
    if (widget.showPostedMessage) {
      // showPostedMessageがtrueの場合、メッセージを表示
      setState(() {
        showMessage = true;
      });
      // 3秒後にメッセージを非表示にする
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          showMessage = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background.jpg'), // 画像ファイルのパスを指定
          fit: BoxFit.cover, // 画像が全画面になるように設定
        ),
      ),
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
                  BackPageArrowButton(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 56),
                      child: Stack(
                        alignment: Alignment.center, // Stack内のウィジェットを中央に配置
                        children: [
                          Center(
                            child: Text(
                              '質問',
                              style: TextStyle(
                                fontFamily: 'NotoSansJP', // フォントファミリーを追加
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          if (showMessage)
                            Container(
                              height: 40,
                              width: 208,
                              decoration: BoxDecoration(
                                color: Color(0xFFE9421E),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // 子ウィジェットのサイズに合わせてContainerのサイズを調整
                                children: [
                                  SizedBox(width: 8.0),
                                  SvgPicture.asset(
                                    'assets/icon_checkmark_orange.svg', // SVGファイルのパス
                                    width: 25.0, // 幅を25に設定
                                    height: 25.0, // 高さを25に設定
                                  ),
                                  SizedBox(width: 12.0), // アイコンとテキストの間隔
                                  Text(
                                    '投稿が完了しました!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E5), // 背景色を設定
                          border: Border.all(
                            color: Colors.black, // 枠線の色を黒に設定
                            width: 2.0, // 枠線の太さを2.0に設定
                          ),
                          borderRadius:
                              BorderRadius.circular(10.0), // 角の丸みを半径10に設定
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
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 174.0,
                                padding: const EdgeInsets.only(
                                    left: 23, top: 15, bottom: 15),
                                // decoration: BoxDecoration(
                                //   border: Border.all(
                                //     color: Colors.black, // 枠線の色
                                //     width: 1.0, // 枠線の太さ
                                //   ),
                                // ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // SizedBox(height: 18.0),
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
                                                        color: const Color(
                                                            0xFFFB99BF),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(3),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        bottom:
                                                            5), // 線の厚み分だけテキストを下にずらす
                                                    child: Text(
                                                      questionData['text1'],
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'NotoSansJP',
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                            fontWeight:
                                                FontWeight.bold, // 太字に設定
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
                                        color:
                                            const Color(0xFFFFFFFF), // 背景色を設定
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
                                            questionData['text2'],
                                            style: const TextStyle(
                                              fontFamily: 'NotoSansJP',
                                              fontWeight:
                                                  FontWeight.bold, // 太字に設定
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
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return const Text('エラーが発生しました');
                                            } else {
                                              Map<String, dynamic> userData =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                    width: 43.0, // 直径43ピクセル
                                                    height: 43.0,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            userData[
                                                                'iconUrl']),
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                      border: Border.all(
                                                        color: Colors
                                                            .black, // 線の色を設定
                                                        width: 1.0, // 線の幅を設定
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color
                                                                  .fromARGB(255,
                                                                  24, 24, 55)
                                                              .withOpacity(1),
                                                          spreadRadius: 0.3,
                                                          blurRadius: 0,
                                                          offset: const Offset(
                                                              1.5, 2.5),
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
                                            color: Color(
                                                0xFF000000), // テキストの色を黒(#000000)に設定
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
                                    child:
                                        Image.asset('assets/icon_bookmark.png'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                const SizedBox(height: 15),
                // ボタンとの間隔を設ける
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RepliesCreatePage(questionId: widget.questionId),
                      ),
                    );
                  },
                  child: Container(
                    width: 387,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0CD64), // 背景色を設定
                      borderRadius: BorderRadius.circular(29.0), // 角の丸みを半径29に設定
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
                      'この質問に回答する',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black, // テキストの色を設定
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                RepliesList(
                  questionId: widget.questionId,
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

class BackPageArrowButton extends StatelessWidget {
  const BackPageArrowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}

class RepliesList extends StatefulWidget {
  final String questionId;
  // final int selectedIndex;

  RepliesList({
    Key? key,
    required this.questionId,
  }) : super(key: key);

  @override
  _RepliesListState createState() => _RepliesListState();
}

class _RepliesListState extends State<RepliesList> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14.0), // 下部に14のマージンを追加
        decoration: BoxDecoration(
          color: const Color(0xFFFFBFAF), // 背景色を設定
          border: Border.all(
            color: Colors.black, // 枠線の色を黒に設定
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
          ],
        ),
        child: Column(
          // Columnウィジェットを追加
          children: <Widget>[
            Container(
              color: const Color(0x00ffbfaf), // 背景色をFFBFAFに設定
              // 1つ目のContainer
              height: 62,
              child: Row(
                children: [
                  const SizedBox(width: 22),
                  const Text(
                    'みんなの回答',
                    style: TextStyle(
                      fontSize: 18, // テキストサイズを18に設定
                      fontWeight: FontWeight.bold, // 太字に設定
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: List.generate(4, (index) => _buildTab(index)),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Container(
              height: 2.0,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFFFF1E5),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getRepliesStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    // 読み込み中かどうか
                    bool isLoading =
                        snapshot.connectionState == ConnectionState.waiting;
                    // エラーが発生しているかどうか
                    bool hasError = snapshot.hasError;
                    // データが存在するかどうか
                    bool hasData =
                        snapshot.hasData && snapshot.data!.docs.isNotEmpty;

                    return Column(
                      children: <Widget>[
                        Offstage(
                          offstage: !isLoading, // 読み込み中でなければ非表示
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        Offstage(
                          offstage:
                              !(hasError && !isLoading), // エラーがあり、読み込み中でなければ非表示
                          child: Center(child: Text('エラーが発生しました')),
                        ),
                        Expanded(
                          child: Offstage(
                            offstage:
                                isLoading || hasError, // 読み込み中またはエラーがあれば非表示
                            child: ListView.builder(
                              itemCount:
                                  hasData ? snapshot.data!.docs.length : 0,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document =
                                    snapshot.data!.docs[index];
                                Map<String, dynamic> replyData =
                                    document.data()! as Map<String, dynamic>;
                                List<dynamic> likedByList =
                                    replyData['likedBy'] != null
                                        ? List<dynamic>.from(
                                            replyData['likedBy'])
                                        : [];
                                User? currentUser =
                                    FirebaseAuth.instance.currentUser;

                                return LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    final textSpan = TextSpan(
                                      text: replyData['text'],
                                      style:
                                          const TextStyle(color: Colors.black),
                                    );
                                    final textPainter = TextPainter(
                                      text: textSpan,
                                      maxLines: 5,
                                      textDirection: TextDirection.ltr,
                                    );
                                    textPainter.layout(
                                      minWidth: constraints.minWidth,
                                      maxWidth: constraints.maxWidth,
                                    );

                                    return AnswersFromUsersBuilder(
                                      replyData: replyData,
                                      widget: widget,
                                      document: document,
                                      likedByList: likedByList,
                                      currentUser: currentUser,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.0),
        height: 22,
        width: 50,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFF0CD64) : Color(0xFFFFF2E8),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color:
                isSelected ? Colors.black : Color(0xFF333333).withOpacity(0.5),
            width: 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          _getTabText(index),
          style: TextStyle(
            fontSize: 10,
            color:
                isSelected ? Colors.black : Color(0xFF333333).withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  // ここに_getRepliesStreamメソッドを定義
  Stream<QuerySnapshot> _getRepliesStream() {
    var repliesQuery = FirebaseFirestore.instance
        .collection('questions')
        .doc(widget.questionId)
        .collection('replies');

    switch (_selectedIndex) {
      case 0: // 新着順
        return repliesQuery.orderBy('createdAt', descending: true).snapshots();
      case 1: // 古い順
        return repliesQuery.orderBy('createdAt', descending: false).snapshots();
      case 2: // 人気順
        return repliesQuery.orderBy('likes', descending: true).snapshots();
      case 3: // 保存済み
        User? currentUser = FirebaseAuth.instance.currentUser;
        return repliesQuery
            .where('likedBy', arrayContains: currentUser?.uid)
            .snapshots();
      default:
        return repliesQuery.snapshots();
    }
  }

  String _getTabText(int index) {
    switch (index) {
      case 0:
        return '新着順';
      case 1:
        return '古い順';
      case 2:
        return '人気順';
      case 3:
        return '保存済み';
      default:
        return '';
    }
  }
}

class AnswersFromUsersBuilder extends StatelessWidget {
  const AnswersFromUsersBuilder({
    super.key,
    required this.replyData,
    required this.widget,
    required this.document,
    required this.likedByList,
    required this.currentUser,
  });

  final Map<String, dynamic> replyData;
  final RepliesList widget;
  final DocumentSnapshot<Object?> document;
  final List likedByList;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
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
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(replyData['iconUrl']),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Stack(
                    clipBehavior: Clip.none, // クリップを無効にして、子が親の範囲外に描画できるようにする
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
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          replyData['text'],
                          style: const TextStyle(
                            color: Colors.black,
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
          FavoriteThumbup(
              widget: widget,
              document: document,
              likedByList: likedByList,
              currentUser: currentUser),
        ],
      ),
    );
  }
}

class FavoriteThumbup extends StatelessWidget {
  const FavoriteThumbup({
    super.key,
    required this.widget,
    required this.document,
    required this.likedByList,
    required this.currentUser,
  });

  final RepliesList widget;
  final DocumentSnapshot<Object?> document;
  final List likedByList;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              // ユーザーがログインしていない場合の処理
              return;
            }
            final uid = currentUser.uid;
            final documentReference = FirebaseFirestore.instance
                .collection('questions')
                .doc(widget.questionId)
                .collection('replies')
                .doc(document.id);

            FirebaseFirestore.instance.runTransaction((transaction) async {
              // usersコレクションのカレントユーザードキュメントを先に読み込む
              DocumentReference userDocRef =
                  FirebaseFirestore.instance.collection('users').doc(uid);
              DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
              Map<String, dynamic> favoriteList =
                  (userSnapshot.data() as Map<String, dynamic>? ??
                          {})['favoriteList'] as Map<String, dynamic>? ??
                      {};

              // repliesコレクションのドキュメントを読み込む
              DocumentSnapshot snapshot =
                  await transaction.get(documentReference);
              if (!snapshot.exists) {
                throw Exception("Document does not exist!");
              }
              final data = snapshot.data() as Map<String, dynamic>?;
              if (data == null) {
                throw Exception("Document data is null!");
              }
              int likes = data.containsKey('likes') ? data['likes'] as int : 0;
              List<dynamic> likedBy = List.from(
                  data.containsKey('likedBy') ? data['likedBy'] as List : []);

              bool isLiked = likedBy.contains(uid);
              if (isLiked) {
                // すでにいいねしている場合は、いいねを取り消す
                likedBy.remove(uid);
                likes--;
                favoriteList.remove(document.id); // favoriteListから削除
              } else {
                // いいねしていない場合は、いいねを追加する
                likedBy.add(uid);
                likes++;
                favoriteList[document.id] =
                    widget.questionId; // questionIdは対応する質問のIDを表す文字列
              }

              // repliesコレクションのドキュメントを更新
              transaction.update(
                  documentReference, {'likedBy': likedBy, 'likes': likes});

              // usersコレクションのドキュメントを更新
              transaction.update(userDocRef, {'favoriteList': favoriteList});
            });
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 6,
              right: 6,
              bottom: 2,
            ),
            child: SvgPicture.asset(
              likedByList.contains(currentUser?.uid)
                  ? 'assets/icon_thumbup_black.svg'
                  : 'assets/icon_thumbup_white.svg',
              semanticsLabel: 'thumbup',
              width: 20,
              height: 20,
            ),
          ),
        ),
        Container(
          child: likedByList.length > 0
              ? Text(
                  '${likedByList.length}', // いいね数を表示
                  style: TextStyle(
                    fontSize: 14, // フォントサイズを適宜調整
                    color: Colors.black,
                  ),
                )
              : SizedBox(), // いいね数が0の場合は何も表示しない
        ),
      ],
    );
  }
}
