import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'question_create_page.dart';
import 'question_detail.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addNotificationIfNotExists(
      String userId, String type, String replyId, String likerUserId) async {
    // notificationsサブコレクションでreplyIdとlikerUserIdの組み合わせを検索
    var existingNotificationSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('replyId', isEqualTo: replyId)
        .where('likerUserId', isEqualTo: likerUserId)
        .limit(1)
        .get();

    // 既に存在する場合は何もしない
    if (existingNotificationSnapshot.docs.isEmpty) {
      // 存在しない場合は新しい通知を追加
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'type': type,
        'replyId': replyId,
        'likerUserId': likerUserId,
        'timestamp': FieldValue.serverTimestamp(),
        'read': 1,
      });
    }
  }

  Future<void> addReplyNotification(String questionOwnerId, String questionId,
      String replierUserId, String replierNickname) async {
    // replierNicknameを引数に追加
    // notificationsサブコレクションでquestionIdとreplierUserIdの組み合わせを検索

    // 存在しない場合は新しい通知を追加
    await _firestore
        .collection('users')
        .doc(questionOwnerId)
        .collection('notifications')
        .add({
      'type': 'reply',
      'questionId': questionId,
      'replierUserId': replierUserId,
      'senderNickname': replierNickname, // 返信者のニックネームを保存
      'timestamp': FieldValue.serverTimestamp(), // サーバーのタイムスタンプを使用
      'read': 1, // 未読状態を示す
    });
  }

  Future<void> saveReply(String questionId, String text, String? userId) async {
    if (userId != null) {
      // ユーザーのドキュメントを取得
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      String nickname = userData['nickname']; // ユーザーのnicknameを取得

      // 返信とともにnicknameも保存
      await _firestore
          .collection('questions')
          .doc(questionId)
          .collection('replies')
          .add({
        'text': text,
        'uid': userId,
        'nickname': nickname, // nicknameも保存
      });
    } else {
      // userIdがnullの場合、nicknameなしで保存
      await _firestore
          .collection('questions')
          .doc(questionId)
          .collection('replies')
          .add({
        'text': text,
        'uid': userId,
      });
    }
  }
}

class HomeMyPage extends StatefulWidget {
  const HomeMyPage({
    Key? key,
  }) : super(key: key);

  @override
  _HomeMyPageState createState() => _HomeMyPageState();
}

class _HomeMyPageState extends State<HomeMyPage> {
  User? user;
  bool isBookmarked = false;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser; // 現在のユーザーを取得
  }

  @override
  Widget build(BuildContext context) {
    // User? user = FirebaseAuth.instance.currentUser; // 現在のユーザーを取得
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.0512),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Scaffoldの背景色を透明に設定
        floatingActionButton: CreateQuestion(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('questions')
                    .where('uid',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .orderBy('created_at', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text('エラーが発生しました');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("読み込み中...");
                  }

                  return QuestionCard(snapshot: snapshot);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  String formatElapsedTime(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays >= 1) {
      return '${difference.inDays}日前';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}時間前';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}分前';
    } else {
      return 'たった今';
    }
  }

  const QuestionCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (BuildContext context, int index) {
        Map<String, dynamic> data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;
        String userIconUrl = data['iconUrl'] ??
            'http://flat-icon-design.com/f/f_object_111/s512_f_object_111_0bg.png';
        String questionId = snapshot.data!.docs[index].id;
        // TextPainterを使用してテキストの幅を計算
        TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: data['text1'],
            style: const TextStyle(
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuestionDetailPage(
                  questionId: snapshot.data!.docs[index].id, // ドキュメントのIDを渡す
                ),
              ),
            );
          },
          child: Container(
            width: 200.0, // 幅を設定
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
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5), // 線の厚み分だけテキストを下にずらす
                                        child: Text(
                                          data['text1'],
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
                            borderRadius:
                                BorderRadius.circular(10.0), // 角の丸みを半径10に設定
                          ), // コンテナの高さを42に設定

                          child: Column(
                            // mainAxisAlignment:
                            //     MainAxisAlignment.end,
                            children: <Widget>[
                              const SizedBox(height: 4.0),
                              Text(
                                data['text2'],
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
                            image: NetworkImage(userIconUrl),
                            fit: BoxFit.scaleDown,
                          ),
                          border: Border.all(
                            color: Colors.black, // 線の色を設定
                            width: 1.0, // 線の幅を設定
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 24, 24, 55)
                                  .withOpacity(1),
                              spreadRadius: 0.3,
                              blurRadius: 0,
                              offset: const Offset(1.5, 2.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatElapsedTime(data['created_at']?.toDate() ??
                            DateTime
                                .now()), // TimestampをDateTimeに変換し、nullの場合は現在時刻を使用
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      const SizedBox(height: 53),
                      // この部分を削除します
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          child: GestureDetector(
                            onTap: () async {
                              User? currentUser =
                                  FirebaseAuth.instance.currentUser;
                              if (currentUser != null) {
                                String uid = currentUser.uid;
                                String questionId =
                                    snapshot.data!.docs[index].id;

                                // bookmarksサブコレクションへの参照を取得
                                DocumentReference bookmarkRef =
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(uid)
                                        .collection('bookmarks')
                                        .doc(questionId);

                                // ドキュメントが存在するか確認
                                DocumentSnapshot bookmarkSnapshot =
                                    await bookmarkRef.get();

                                if (!bookmarkSnapshot.exists) {
                                  // ブックマークが存在しない場合は追加
                                  await bookmarkRef.set({
                                    'qid': questionId,
                                    'uid': uid,
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });
                                } else {
                                  // ブックマークが存在する場合は削除
                                  await bookmarkRef.delete();
                                }
                              }
                            },
                            child: FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('questions')
                                  .doc(questionId)
                                  .get(),
                              builder: (context, questionSnapshot) {
                                if (questionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }

                                if (questionSnapshot.hasData &&
                                    questionSnapshot.data!.exists) {
                                  // questionのuidが現在のユーザーのuidと一致するか確認
                                  bool isUserQuestion = questionSnapshot
                                          .data!['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid;

                                  // StreamBuilderをここに配置
                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseAuth.instance.currentUser !=
                                            null
                                        ? FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .collection('bookmarks')
                                            .doc(questionId)
                                            .snapshots()
                                        : null,
                                    builder: (context, bookmarkSnapshot) {
                                      if (bookmarkSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      } else {
                                        if (isUserQuestion) {
                                          // uidが一致する場合は削除ボタンを表示
                                          return DeleteButton(
                                            textPainter: textPainter,
                                            data: data,
                                            userIconUrl: userIconUrl,
                                            snapshot: snapshot,
                                            index: index,
                                          );
                                        } else {
                                          // uidが一致しない場合はブックマークの状態に応じたアイコンを表示
                                          if (bookmarkSnapshot.hasData &&
                                              bookmarkSnapshot.data!.exists) {
                                            return SvgPicture.asset(
                                                width: 18,
                                                height: 18,
                                                'assets/icon_bookmark_black.svg',
                                                key: UniqueKey());
                                          } else {
                                            return SvgPicture.asset(
                                                width: 18,
                                                height: 18,
                                                'assets/icon_bookmark_white.svg',
                                                key: UniqueKey());
                                          }
                                        }
                                      }
                                    },
                                  ); // この行にセミコロンを追加
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.textPainter,
    required this.data,
    required this.userIconUrl,
    required this.snapshot,
    required this.index,
  });

  final TextPainter textPainter;
  final Map<String, dynamic> data;
  final String userIconUrl;
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;

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
                                      String questionId =
                                          snapshot.data!.docs[index].id;

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
                                              .doc(questionId);

                                      // サブコレクション（例：replies）も削除
                                      await deleteSubcollection(
                                          questionDocRef, 'replies');

                                      // 親ドキュメントを削除
                                      await questionDocRef.delete();

                                      // ダイアログを閉じる
                                      Navigator.of(context).pop();
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

class CreateQuestion extends StatelessWidget {
  const CreateQuestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0, // ここで高さを設定します
      width: 80.0, // ここで幅を設定します
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40), // ボタンの半径を設定
        color: const Color(0xFFF0CD64), // ボタンの背景色を設定
        border: Border.all(
          color: Colors.black, // 枠線の色を設定
          width: 1.5, // 枠線の幅を設定
        ),
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
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionCreatePage()),
          );
        },
        backgroundColor: Colors.transparent, // FloatingActionButtonの背景色を透明に設定
        elevation: 0,
        child: const Icon(Icons.add,
            size: 54.0, color: Colors.black), // FloatingActionButtonのデフォルトの影を削除
      ),
    );
  }
}
