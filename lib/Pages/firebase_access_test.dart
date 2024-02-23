// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '/Provider/auth_notifier.dart';

// class FirebaseAccessTest extends StatefulWidget {
//   @override
//   FirebaseAccessTestState createState() => FirebaseAccessTestState();
// }

// class FirebaseAccessTestState extends State<FirebaseAccessTest> {
//   User? user;
//   final AuthNotifier authNotifier = AuthNotifier();

//   Future<void> signIn() async {
//     try {
//       await authNotifier.signIn("test12@gmail.com", "password");
//       user = authNotifier.user;
//       print("ログイン成功: ${user!.email}");
//     } catch (e) {
//       print('エラー: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firebase Access Test'),
//       ),
//       body: Column(
//         children: <Widget>[
//           ElevatedButton(
//             child: Text('ユーザー情報を表示'),
//             onPressed: () {
//               signIn();
//             },
//           ),
//           Expanded(
//             child: FutureBuilder<QuerySnapshot>(
//               future: FirebaseFirestore.instance.collection('users').get(),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text('エラー: ${snapshot.error}');
//                 } else {
//                   return ListView(
//                     children: snapshot.data!.docs.map((doc) {
//                       Map<String, dynamic> data =
//                           doc.data() as Map<String, dynamic>;
//                       return ListTile(
//                         title: Text('ドキュメントID: ${doc.id}'),
//                         subtitle: Text('データ: $data'),
//                         onTap: () async {
//                           // ここでログイン処理を行う
//                           String email = data['email']; // データからメールアドレスを取得
//                           String password = data['password']; // データからパスワードを取得

//                           try {
//                             UserCredential userCredential = await FirebaseAuth
//                                 .instance
//                                 .signInWithEmailAndPassword(
//                               email: email,
//                               password: password,
//                             );
//                             user = userCredential.user;
//                             setState(() {});
//                           } catch (e) {
//                             print('エラー: $e');
//                           }
//                         },
//                       );
//                     }).toList(),
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
