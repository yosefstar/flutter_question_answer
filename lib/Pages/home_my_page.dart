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
  final String email;

  const HomeMyPage({Key? key, required this.email}) : super(key: key);

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
    return Scaffold(
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
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
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
    );
  }
}

class QuestionCard extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;

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
                      const Text(
                        '15分前',
                        style: TextStyle(
                          fontSize: 10.0, // フォントサイズを10に設定
                        ),
                      ),
                      const SizedBox(height: 53),
                      // この部分を削除します
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 18,
                          height: 18,
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
                            child: StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseAuth.instance.currentUser != null
                                  ? FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('bookmarks')
                                      .doc(questionId)
                                      .snapshots()
                                  : null,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                } else if (snapshot.hasData &&
                                    snapshot.data!.exists) {
                                  return SvgPicture.asset(
                                    'assets/icon_bookmark_black.svg',
                                    key: UniqueKey(),
                                  ); // ブックマークあり
                                } else {
                                  return SvgPicture.asset(
                                    'assets/icon_bookmark_white.svg',
                                    key: UniqueKey(),
                                  ); // ブックマークなし
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
