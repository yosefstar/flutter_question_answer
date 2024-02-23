import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

// UserServiceクラスの定義
class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // コンストラクタのReader引数を削除
  UserService();

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        final DocumentSnapshot docSnap =
            await _firestore.collection('users').doc(user.uid).get();
        if (docSnap.exists) {
          print('ニックネーム: ${docSnap.get('nickname')}');
          return true; // ログイン成功
        } else {
          print('ユーザーが存在しません');
          return false; // ユーザーが存在しない
        }
      }
    } catch (e) {
      print('エラー: $e');
      return false; // エラーが発生した
    }
    return false; // ログイン失敗
  }
}

// UserServiceのインスタンスを提供するProvider
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
