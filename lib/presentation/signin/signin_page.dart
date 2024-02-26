import 'package:flutter/material.dart';
import 'package:flutter_question_answer/Pages/home_page.dart';
import 'package:flutter_question_answer/services/user_service.dart';
import 'package:flutter_svg/svg.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService _userService = UserService();

  SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFECEB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: SafeArea(
          child: Container(
            height: 146.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 13),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2C4B9),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 24, 24, 55),
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset: Offset(1, 3),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/back_arrow.png'),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 56),
                      child: Text(
                        'ログイン',
                        style: TextStyle(
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
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.049),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 80),
            SvgPicture.asset(
              'assets/welcomeback.svg',
              width: 334,
              height: 126,
            ),
            const SizedBox(height: 72),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_mail.svg',
                  width: 15,
                  height: 13,
                ),
                const SizedBox(width: 7),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'メールアドレス',
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.5),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 33),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icon_keyword.svg',
                  width: 15,
                  height: 15,
                ),
                const SizedBox(width: 7),
                const Text(
                  'パスワード',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 15),
                hintText: 'パスワード',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.5),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            InkWell(
              onTap: () async {
                String email = emailController.text.trim();
                String password = passwordController.text.trim();
                bool result = await _userService.signInWithEmailAndPassword(
                    email, password);
                if (result) {
                  // ログイン成功時の処理
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                } else {
                  // ログイン失敗時の処理
                  print('ログインに失敗しました');
                }
              },
              child: Container(
                width: double.infinity, // Containerを画面幅いっぱいに広げる
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0CD64),
                  borderRadius: BorderRadius.circular(29.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 24, 24, 55),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'ログイン',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
