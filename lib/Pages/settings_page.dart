import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController nicknameController = TextEditingController();
  int selectedIconIndex = 0;
  List<String> iconUrls = [
    'http://flat-icon-design.com/f/f_object_112/s512_f_object_112_0bg.png',
    'http://flat-icon-design.com/f/f_object_149/s512_f_object_149_0bg.png',
    'http://flat-icon-design.com/f/f_object_174/s512_f_object_174_0bg.png',
    'http://flat-icon-design.com/f/f_object_169/s512_f_object_169_0bg.png',
    'http://flat-icon-design.com/f/f_object_157/s512_f_object_157_2bg.png',
    'http://flat-icon-design.com/f/f_object_111/s512_f_object_111_0bg.png'
    // アイコンのURLをここに追加
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nicknameController,
              decoration: InputDecoration(labelText: 'ニックネーム'),
            ),
            Container(
              height: 68.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: iconUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 55.0,
                    decoration: BoxDecoration(
                      color: index == selectedIconIndex
                          ? Colors.blue
                          : null, // 選択されたアイコンに色を付ける
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIconIndex = index; // タップしたアイコンのインデックスを保存
                          });
                        },
                        child: ClipOval(
                          child: Image.network(
                            iconUrls[index],
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              child: Text('保存'),
              onPressed: () async {
                final FirebaseAuth auth = FirebaseAuth.instance;
                final User? user = auth.currentUser;
                final String uid = user != null ? user.uid : '';

                final userData = <String, dynamic>{
                  "nickname": nicknameController.text,
                  "iconUrl": iconUrls[selectedIconIndex],
                };

                FirebaseFirestore db = FirebaseFirestore.instance;
                try {
                  await db.collection("users").doc(uid).update(userData).then(
                      (void value) => print('User updated with ID: $uid'));
                  Navigator.of(context).pop(); // 設定画面を閉じる
                } catch (e) {
                  print('エラー: $e');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
