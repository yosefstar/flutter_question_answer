import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_question_answer/Pages/settings_page.dart';

import 'notification_page.dart';
import 'question_create_page.dart';
import 'question_detail.dart';
import 'question_search.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String email;

  HomePage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    String? email = user != null ? user.email : 'No user signed in';

    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc(user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("エラーが発生しました");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // 画像ファイルのパスを指定
                fit: BoxFit.cover, // 画像が全画面になるように設定
              ),
            ),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xFF455EA6), // AppBarの色を変更
                toolbarHeight: 80,
                leading: Padding(
                  padding:
                      EdgeInsets.only(top: 10.0, left: 10.0), // 上部にパディングを追加
                  child: Align(
                    alignment: Alignment.topCenter, // 上部に配置
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('${data['iconUrl']}'),
                          fit: BoxFit.scaleDown,
                        ),
                        border: Border.all(
                          // 線を追加
                          color: Colors.black, // 線の色を設定
                          width: 1.0, // 線の幅を設定
                        ),
                        boxShadow: [
                          // 影を追加
                          BoxShadow(
                            color: Color.fromARGB(255, 24, 24, 55)
                                .withOpacity(1), // 影の色を設定
                            spreadRadius: 0.1, // 影の広がりを設定
                            blurRadius: 1, // 影のぼかしを設定
                            offset: Offset(3, 3), // 影の位置を設定
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      // 通知ページに遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage()),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      // 設定ページに遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                ],

                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFffd8b4),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // ここに新しい処理を書く
                            },
                            child: Text('みんなの投稿'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            color: Color(0xFFffd8b4),
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                              // "自分の投稿"ボタンが押されたときの処理
                            },
                            child: Text('自分の投稿'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Container(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('questions')
                      .where('uid', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('エラーが発生しました');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("読み込み中...");
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;

                        return Container(
                          width: 200.0, // 幅を設定
                          height: 200.0,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ), // 横の余白を大きくする
                            decoration: BoxDecoration(
                              color: Color(0xFFffd8b4), // コンテナの色を変更
                              border: Border.all(
                                color: Colors.black, // 枠の色
                                width: 1, // 枠の幅
                              ),
                              borderRadius:
                                  BorderRadius.circular(15.0), // 丸みの半径
                            ),

                            child: ListTile(
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center, // 中央に配置
                                children: <Widget>[
                                  Transform.translate(
                                    offset: Offset(-30, 0), // 左に20ピクセル移動
                                    child: Align(
                                      alignment: Alignment.centerLeft, // 左端に配置
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Colors.black, // 枠の色
                                            width: 1, // 枠の幅
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              15.0), // 丸みの半径
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              '${data['text1']}に言われたら、なんて返す？'),
                                        ),
                                        color: Color(0xFF97d9f8),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(
                                        16.0), // テキストの周りにパディングを追加
                                    child: Transform.translate(
                                      offset: Offset(30, 0), // 右に30ピクセル移動
                                      child: Text(
                                        data['text2'],
                                        style: TextStyle(
                                          fontSize: 24.0, // フォントサイズを大きく設定
                                          fontWeight:
                                              FontWeight.bold, // テキストを太字に設定
                                        ),
                                        textAlign:
                                            TextAlign.center, // テキストを中央揃えに設定
                                      ),
                                    ),
                                  ),
                                  FutureBuilder<DocumentSnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(data['uid'])
                                        .get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Icon(Icons.error);
                                      } else {
                                        Map<String, dynamic> userData =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, // これでRow内の要素が中央揃えになる
                                          children: <Widget>[
                                            Transform.translate(
                                              offset:
                                                  Offset(30, 0), // 右に30ピクセル移動
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: NetworkImage(
                                                        userData['iconUrl']),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    10), // アイコンとニックネームの間にスペースを追加
                                            Transform.translate(
                                              offset:
                                                  Offset(30, 0), // 右に30ピクセル移動
                                              child: Text(userData['nickname']),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () {
                                  // 押されたquestionsのドキュメントIDを保持
                                  String questionDocId =
                                      snapshot.data!.docs[index].id;

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String replyText = '';
                                      return FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(data['uid'])
                                            .get(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<DocumentSnapshot>
                                                snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Icon(Icons.error);
                                          } else {
                                            Map<String, dynamic> userData =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            return AlertDialog(
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                        '${data['text1']}に言われたら、なんて返す？'),
                                                    Text(data['text2']),
                                                    Image.network(
                                                        userData['iconUrl']),
                                                    Text(userData['nickname']),
                                                    TextField(
                                                      onChanged: (value) {
                                                        replyText = value;
                                                      },
                                                    ),
                                                    StreamBuilder<
                                                        QuerySnapshot>(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'questions')
                                                          .doc(questionDocId)
                                                          .collection('replies')
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              'エラーが発生しました');
                                                        }

                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Text(
                                                              "読み込み中...");
                                                        }

                                                        return SingleChildScrollView(
                                                          child: Column(
                                                            children: snapshot
                                                                .data!.docs
                                                                .map((doc) {
                                                              Map<String,
                                                                      dynamic>
                                                                  data =
                                                                  doc.data() as Map<
                                                                      String,
                                                                      dynamic>;

                                                              return FutureBuilder<
                                                                  DocumentSnapshot>(
                                                                future: FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users')
                                                                    .doc(data[
                                                                        'uid'])
                                                                    .get(),
                                                                builder: (BuildContext
                                                                        context,
                                                                    AsyncSnapshot<
                                                                            DocumentSnapshot>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return CircularProgressIndicator();
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Icon(
                                                                        Icons
                                                                            .error);
                                                                  } else {
                                                                    Map<String,
                                                                        dynamic> userData = snapshot
                                                                            .data!
                                                                            .data()
                                                                        as Map<
                                                                            String,
                                                                            dynamic>;
                                                                    return ListTile(
                                                                      title: Text(
                                                                          userData[
                                                                              'nickname']),
                                                                      subtitle:
                                                                          Text(data[
                                                                              'reply']),
                                                                      trailing:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <Widget>[
                                                                          Text(data['likes']?.toString() ??
                                                                              '0'), // いいねの数を表示
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(
                                                                              Icons.thumb_up,
                                                                              color: (data['likedBy'] as List<dynamic>?)?.contains(user?.uid) ?? false ? Colors.red : null,
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              if ((data['likedBy'] as List<dynamic>?)?.contains(user?.uid) ?? false) {
                                                                                // すでにいいねしている場合はいいねを取り消す
                                                                                await FirebaseFirestore.instance.collection('questions').doc(questionDocId).collection('replies').doc(doc.id).update({
                                                                                  'likes': FieldValue.increment(-1),
                                                                                  'likedBy': FieldValue.arrayRemove([
                                                                                    user?.uid
                                                                                  ]),
                                                                                });
                                                                              } else {
                                                                                // まだいいねしていない場合はいいねを追加
                                                                                await FirebaseFirestore.instance.collection('questions').doc(questionDocId).collection('replies').doc(doc.id).update({
                                                                                  'likes': FieldValue.increment(1),
                                                                                  'likedBy': FieldValue.arrayUnion([
                                                                                    user?.uid
                                                                                  ]),
                                                                                });
                                                                              }
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                              );
                                                            }).toList(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        // 保持しておいたquestionsのドキュメントIDを使用して、repliesサブコレクションを作成
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'questions')
                                                            .doc(questionDocId)
                                                            .collection(
                                                                'replies')
                                                            .add({
                                                          'uid': user?.uid,
                                                          'reply': replyText,
                                                          'likes':
                                                              0, // Initialize likes to 0
                                                          'likedBy':
                                                              [], // Initialize likedBy to an empty array
                                                        });
                                                      },
                                                      child: Text('保存'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              bottomNavigationBar: Container(
                height: 100.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF08BB5),
                  border: Border(
                    top: BorderSide(
                      color: Colors.black, // 線の色を設定します。必要に応じて値を調整してください。
                      width: 2.0, // 線の幅を設定します。必要に応じて値を調整してください。
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionSearchPage()),
                        );
                      },
                      child: Text('質問を探す'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionCreatePage()),
                        );
                      },
                      child: Text('質問してみる'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
