import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';

import 'home_page.dart';
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
  final bool showPostedMessage;
  final bool showDialog;
  final bool fromQuestionViewPage;

  QuestionDetailPage({
    Key? key,
    required this.questionId,
    this.showPostedMessage = false,
    this.showDialog = false,
    this.fromQuestionViewPage = false, // デフォルト値をfalseに設定
  }) : super(key: key);

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
// クラスのメンバ変数として定義
  ValueNotifier<bool> showMessage = ValueNotifier<bool>(false);
  String currentUserNickname = '匿名';
  String currentUserIconUrl = '匿名';
  @override
  void initState() {
    super.initState();
    _fetchCurrentUserNickname(); // ここでメソッドを呼び出す
    if (widget.showPostedMessage) {
      // showPostedMessageがtrueの場合、メッセージを表示
      showMessage.value = true;

      // 3秒後にメッセージを非表示にする
      Future.delayed(Duration(seconds: 3), () {
        showMessage.value = false;
      });
    }

    if (widget.showDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              insetPadding: EdgeInsets.fromLTRB(21, 150, 21, 280),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFBFAF),
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Center(
                              child: Text(
                                '回答完了',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                          border: Border(
                            top: BorderSide(width: 0.1, color: Colors.black),
                            left: BorderSide(width: 2.0, color: Colors.black),
                            right: BorderSide(width: 2.0, color: Colors.black),
                            bottom: BorderSide(width: 2.0, color: Colors.black),
                          ),
                          color: Color(0xFFF5D8D6),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 32,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 28.0,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    child: Image.asset(
                                      'assets/success.png',
                                      width: 328.0,
                                      height: 140.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Text(
                                    'ご回答ありがとうございます！',
                                    style: TextStyle(
                                      fontSize: 16.0, // フォントサイズを14に設定
                                      fontWeight: FontWeight.bold, // テキストを太字に設定
                                    ),
                                  ),
                                  SizedBox(
                                    height: 48,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HomePage()),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 46.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFF2E8),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(29),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(255, 24,
                                                      24, 55), // 影の色を設定
                                                  spreadRadius: 1, // 影の広がりを設定
                                                  blurRadius: 0, // 影のぼかしを設定
                                                  offset:
                                                      Offset(1, 3), // 影の位置を設定
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '他の質問に回答',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 46.0,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0CD64),
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(29),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(255, 24,
                                                      24, 55), // 影の色を設定
                                                  spreadRadius: 1, // 影の広がりを設定
                                                  blurRadius: 0, // 影のぼかしを設定
                                                  offset:
                                                      Offset(1, 3), // 影の位置を設定
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                '閉じる',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                            ), // 3つ目のContainer
                          ],
                        ),
                      ),
                    ),
                    // 他の子ウィジェット...
                  ],
                ),
              ),
            );
          },
        );
      });
    }
  }

  Future<void> _fetchCurrentUserNickname() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userDoc.exists) {
        // data()メソッドの結果をMap<String, dynamic>にキャスト
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          currentUserNickname = userData['nickname'] ?? '匿名';
          currentUserIconUrl = userData['iconUrl'] ?? '';
        });
      }
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
                  BackPageArrowButton(
                    showPostedMessage: widget.showPostedMessage,
                    fromQuestionViewPage: widget.fromQuestionViewPage, // この行を追加
                  ),
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
                          ValueListenableBuilder<bool>(
                            valueListenable: showMessage,
                            builder: (context, value, child) {
                              if (value) {
                                return Container(
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
                                );
                              } else {
                                return SizedBox
                                    .shrink(); // showMessageがfalseの場合は何も表示しない
                              }
                            },
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
                                              String currentUserNickname =
                                                  userData['nickname'] ?? '匿名';
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
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('questions')
                                            .doc(widget.questionId)
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.data != null) {
                                            Map<String, dynamic> questionData =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            User? currentUser = FirebaseAuth
                                                .instance.currentUser;
                                            bool isUserQuestion =
                                                currentUser?.uid ==
                                                    questionData['uid'];

                                            // 条件に基づいてDeleteButtonまたはBookmarkButtonを表示
                                            return isUserQuestion
                                                ? DeleteButton(
                                                    textPainter: textPainter,
                                                    data: questionData,
                                                    userIconUrl:
                                                        questionData['iconUrl'],
                                                    questionId:
                                                        widget.questionId,
                                                  )
                                                : StreamBuilder<
                                                    DocumentSnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid) // カレントユーザーのUIDを使用
                                                        .collection('bookmarks')
                                                        .doc(widget
                                                            .questionId) // 現在の質問IDをドキュメントIDとして使用
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      Widget bookmarkWidget;
                                                      if (snapshot.hasData &&
                                                          snapshot
                                                              .data!.exists) {
                                                        // bookmarksサブコレクションに現在のquestionIdが存在する場合、黒のブックマークを表示
                                                        bookmarkWidget =
                                                            InkWell(
                                                          onTap: () {
                                                            // ブックマークを削除する処理
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'bookmarks')
                                                                .doc(widget
                                                                    .questionId)
                                                                .delete();
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icon_bookmark_black.svg',
                                                            width: 18,
                                                            height: 18,
                                                            key: UniqueKey(),
                                                          ),
                                                        );
                                                      } else {
                                                        // bookmarksサブコレクションに現在のquestionIdが存在しない場合、白のブックマークを表示
                                                        bookmarkWidget =
                                                            InkWell(
                                                          onTap: () {
                                                            // ブックマークを作成する処理
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'bookmarks')
                                                                .doc(widget
                                                                    .questionId)
                                                                .set({
                                                              'qid': widget
                                                                  .questionId,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(), // 現在のタイムスタンプを保存
                                                              'uid': FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .uid,
                                                            }); // 必要に応じて他のデータも保存
                                                          },
                                                          child:
                                                              SvgPicture.asset(
                                                            'assets/icon_bookmark_white.svg',
                                                            width: 18,
                                                            height: 18,
                                                            key: UniqueKey(),
                                                          ),
                                                        );
                                                      }
                                                      return bookmarkWidget;
                                                    },
                                                  );
                                          } else {
                                            return CircularProgressIndicator(); // データの読み込み中はローディングを表示
                                          }
                                        },
                                      )),
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
                  currentUserNickname: currentUserNickname,
                  currentUserIconUrl: currentUserIconUrl,
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

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.textPainter,
    required this.data,
    required this.userIconUrl,
    required this.questionId,
  });

  final TextPainter textPainter;
  final Map<String, dynamic> data;
  final String userIconUrl;
  final String questionId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.fromLTRB(21, 150, 21, 250),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFBFAF),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 36.0),
                              child: Text(
                                '投稿を削除',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/icon_close.svg',
                              width: 24, height: 24), // SVGアイコンを指定
                          onPressed: () {
                            Navigator.of(context).pop(); // ダイアログを閉じる
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        border: Border(
                          top: BorderSide(width: 0.1, color: Colors.black),
                          left: BorderSide(width: 2.0, color: Colors.black),
                          right: BorderSide(width: 2.0, color: Colors.black),
                          bottom: BorderSide(width: 2.0, color: Colors.black),
                        ),
                        color: Color(0xFFF5D8D6),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 32,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 28.0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icon_attention_orange.svg', // SVGファイルのパス
                                          width: 24, // アイコンの幅
                                          height: 24, // アイコンの高さ
                                        ),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          '以下の投稿を削除します',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFE9421E),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 28,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF2E8), // コンテナの色を変更
                                    border: Border.all(
                                      color: Colors.black, // 枠の色
                                      width: 1.5, // 枠の幅
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(10.0), // 丸みの半径
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // margin: const EdgeInsets.only(left: 23, bottom: 19),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top: 18,
                                                              child: Container(
                                                                width:
                                                                    textPainter
                                                                        .width,
                                                                height: 6.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFFB99BF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5), // 線の厚み分だけテキストを下にずらす
                                                              child: Text(
                                                                data['text1'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'NotoSansJP',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .black,
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
                                                      fontWeight: FontWeight
                                                          .bold, // 太字に設定
                                                      fontSize: 18,
                                                      color: Colors
                                                          .black, // テキストの色を指定
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                height: 42.0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFFFFFFF), // 背景色を設定
                                                  border: Border.all(
                                                    color: Colors
                                                        .black, // 枠線の色を黒に設定
                                                    width: 2.0, // 枠線の太さを2.0に設定
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // 角の丸みを半径10に設定
                                                ), // コンテナの高さを42に設定

                                                child: Column(
                                                  children: <Widget>[
                                                    const SizedBox(height: 6.0),
                                                    Text(
                                                      data['text2'],
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'NotoSansJP',
                                                        fontWeight: FontWeight
                                                            .bold, // 太字に設定
                                                        fontSize:
                                                            18, // テキストサイズを22に設定
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
                                                  fontWeight:
                                                      FontWeight.bold, // 太字に設定
                                                  fontSize: 18, // テキストサイズを22に設定
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 174.0,
                                        margin:
                                            const EdgeInsets.only(right: 14.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(height: 21),
                                            Container(
                                              width: 43.0, // 直径43ピクセル
                                              height: 43.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(userIconUrl),
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
                                                    offset:
                                                        const Offset(1.5, 2.5),
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
                                SizedBox(
                                  height: 24,
                                ),
                                InkWell(
                                  onTap: () async {
                                    User? currentUser =
                                        FirebaseAuth.instance.currentUser;
                                    if (currentUser != null) {
                                      // サブコレクションのドキュメントを削除する関数
                                      Future<void> deleteSubcollection(
                                          DocumentReference parentDoc,
                                          String subcollectionName) async {
                                        // サブコレクション内のドキュメントを取得
                                        QuerySnapshot subcollectionSnapshot =
                                            await parentDoc
                                                .collection(subcollectionName)
                                                .get();

                                        // 各ドキュメントを削除
                                        for (QueryDocumentSnapshot doc
                                            in subcollectionSnapshot.docs) {
                                          await doc.reference.delete();
                                        }
                                      }

                                      // questionsコレクションのドキュメントリファレンスを取得
                                      DocumentReference questionDocRef =
                                          FirebaseFirestore.instance
                                              .collection('questions')
                                              .doc(this.questionId);
                                      // サブコレクション（例：replies）も削除
                                      await deleteSubcollection(
                                          questionDocRef, 'replies');

                                      // 親ドキュメントを削除
                                      await questionDocRef.delete();

                                      // ダイアログを閉じる
                                      Navigator.of(context).pop();

// HomePageに遷移し、以前のすべてのルートを削除する
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 46.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFE9421E),
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      borderRadius: BorderRadius.circular(29),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(
                                              255, 24, 24, 55), // 影の色を設定
                                          spreadRadius: 1, // 影の広がりを設定
                                          blurRadius: 0, // 影のぼかしを設定
                                          offset: Offset(1, 3), // 影の位置を設定
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        'この投稿を削除する',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ), // 3つ目のContainer
                        ],
                      ),
                    ),
                  ),
                  // 他の子ウィジェット...
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 20.0,
        width: 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11.5),
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: Colors.black,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 24, 24, 55).withOpacity(1),
              spreadRadius: 1,
              blurRadius: 0.1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '削除',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class BackPageArrowButton extends StatelessWidget {
  final bool fromQuestionViewPage;
  final bool showPostedMessage;

  const BackPageArrowButton({
    super.key,
    this.fromQuestionViewPage = false,
    this.showPostedMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (showPostedMessage) {
          // showPostedMessageがtrueの場合、HomePageに遷移する
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
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
  final String currentUserNickname;
  final String currentUserIconUrl;

  RepliesList({
    Key? key,
    required this.questionId,
    required this.currentUserNickname,
    required this.currentUserIconUrl,
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
                                      currentUserNickname:
                                          widget.currentUserNickname,
                                      currentUserIconUrl:
                                          widget.currentUserIconUrl,
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
    required this.currentUserNickname,
    required this.currentUserIconUrl,
  });

  final Map<String, dynamic> replyData;
  final RepliesList widget;
  final DocumentSnapshot<Object?> document;
  final List likedByList;
  final User? currentUser;
  final String currentUserNickname;
  final String currentUserIconUrl;

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
            currentUser: currentUser,
            currentUserNickname: currentUserNickname,
            currentUserIconUrl: currentUserIconUrl,
          ),
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
    required this.currentUserNickname,
    required this.currentUserIconUrl, // ここに追加
  });

  final RepliesList widget;
  final DocumentSnapshot<Object?> document;
  final List likedByList;
  final User? currentUser;
  final String currentUserNickname;
  final String currentUserIconUrl; // ここに追加

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

              if (!isLiked) {
                // 返信をしたユーザーのUIDを取得
                String replyUserUid = data['uid']; // 返信ドキュメントにユーザーUIDを保存していると仮定

                // 自分自身の投稿にいいねをした場合は、通知を作成しない
                if (uid != replyUserUid) {
                  // 返信をしたユーザーのドキュメント参照を取得
                  DocumentReference replyUserDocRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(replyUserUid);

                  // いいねをしたユーザーのニックネームを取得
                  String likerNickname = currentUserNickname;

                  // 既存の通知がないかをチェック
                  QuerySnapshot existingNotifications = await FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(replyUserUid)
                      .collection('notifications')
                      .where('senderUid', isEqualTo: uid)
                      .where('repliesId', isEqualTo: document.id)
                      .get();

                  if (existingNotifications.docs.isEmpty) {
                    // 返信をしたユーザーのnotificationsサブコレクションにドキュメントを追加
                    DocumentReference notificationRef =
                        replyUserDocRef.collection('notifications').doc();
                    transaction.set(notificationRef, {
                      'senderUid': uid, // いいねをしたユーザーのUID
                      'senderNickname': likerNickname, // いいねをしたユーザーのニックネーム
                      'qid': widget.questionId, // 質問ID
                      'repliesId': document.id, // 返信のID
                      'createdAt': FieldValue.serverTimestamp(), // 作成日時
                      'type': 'like', // 通知のタイプ
                      'sendAgainCount': 1,
                      'readCount': 1,
                    });
                  }
                }
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
