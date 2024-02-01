import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // DateFormatを使用するために必要

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通知'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('notifications')
            .orderBy('timestamp', descending: true) // 最初にこのフィールドでorderByを行う
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(
                    DateTime.now().subtract(Duration(days: 1))))
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
              // タイムスタンプをDateTimeに変換
              DateTime notificationTime =
                  (data['timestamp'] as Timestamp).toDate();
              // 現在時刻との差を計算
              Duration timeAgo = DateTime.now().difference(notificationTime);
              // 通知の文言をタイプに応じて設定
              String message = 'デフォルトのメッセージ';
              switch (data['type']) {
                case 'like':
                  message = '${data['senderNickname']}さんがあなたの投稿に「いいね」しました。';
                  break;
                case 'reply':
                  message = '${data['senderNickname']}さんがあなたの投稿にコメントしました。';
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
              // ListTileを返す
              return ListTile(
                title: Text(message),
                subtitle: Text(timeAgoText), // ここに時間を表示
                onTap: () {
                  // 通知を既読にする
                  doc.reference.update({'read': true});
                },
                tileColor: data['read'] == 1
                    ? Colors.white
                    : (data['read'] == 2 ? Colors.grey : Colors.blue),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
