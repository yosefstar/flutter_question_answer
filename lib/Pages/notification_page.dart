import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // DateFormatを使用するために必要

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFECEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0), // AppBarの高さを80に設定
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.049,
            ),
            child: Container(
              height: 146.0,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop(); // 画面を戻るアクション
                    },
                    child: Container(
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
                          '設定',
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
      ),
      // StreamBuilderの閉じカッコが不足しています。以下のように修正してください。

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('notifications')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print('エラーが発生しました: ${snapshot.error}');
            return Text('何か問題が発生しました');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("読み込み中...");
          }

          if (snapshot.data!.docs.isEmpty) {
            return Text("未読の通知はありません");
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime notificationTime =
                  (data['createdAt'] as Timestamp).toDate();
              // 現在時刻との差を計算
              Duration timeAgo = DateTime.now().difference(notificationTime);
              // 通知の文言をタイプに応じて設定
              String message = 'デフォルトのメッセージ';
              switch (data['type']) {
                case 'like':
                  message = 'さんがあなたの回答に「いいね」しました。';
                  break;
                case 'reply':
                  message = 'さんがあなたの質問に回答しました。';
                  break;
                // 他の通知タイプに応じたケースを追加
                // defaultケースは省略
              }
              // 時間を「何分前」の形式で表示
              String timeAgoText = timeAgo.inMinutes.toString() + '分前';
              if (timeAgo.inMinutes > 60) {
                timeAgoText = timeAgo.inHours.toString() + '時間前';
              }
              if (timeAgo.inHours > 24) {
                timeAgoText = (timeAgo.inDays).toString() + '日前';
              }
              // 以下の部分を変更
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(data['senderUid'])
                    .get(),
                builder:
                    (context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (userSnapshot.hasError || !userSnapshot.hasData) {
                    return ListTile(
                      leading: CircleAvatar(),
                      title: Text('ユーザー情報の取得に失敗しました'),
                    );
                  }
                  Map<String, dynamic> userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  String iconUrl = userData['iconUrl'] ?? '';
                  String nickname = userData['nickname'] ?? '';
                  // 通知の文言と時間の計算は同じ
                  // ListTileのleadingにユーザーアイコンを表示

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.049,
                    ),
                    child: Container(
                      height: 100,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF1E5),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 24, 24, 55), // 影の色を設定
                            spreadRadius: 1, // 影の広がりを設定
                            blurRadius: 0, // 影のぼかしを設定
                            offset: Offset(1, 3), // 影の位置を設定// 影の位置を設定
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          doc.reference.update({'read': true});
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(iconUrl), // ユーザーアイコンのURL
                                  fit: BoxFit.scaleDown,
                                ),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 24, 24, 55)
                                        .withOpacity(1),
                                    spreadRadius: 0.1,
                                    blurRadius: 1,
                                    offset: const Offset(3, 3),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    nickname + message, // 通知のメッセージ
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Spacer(), // テキスト間のスペース
                                  Text(
                                    timeAgoText, // 通知の時間
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 垂直方向の中央配置
                              crossAxisAlignment:
                                  CrossAxisAlignment.center, // 水平方向の中央配置
                              children: [
                                if (data['readCount'] ==
                                    2) // readCountが2の場合のみ赤い点を表示
                                  Container(
                                    width: 10.0, // 円の直径
                                    height: 10.0, // 円の直径
                                    decoration: BoxDecoration(
                                      color: Colors.red, // 背景色を赤に設定
                                      shape: BoxShape.circle, // 形状を円に設定
                                    ),
                                  ),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
