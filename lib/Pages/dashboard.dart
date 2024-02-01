import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'register_page.dart';
import 'sign_in_page.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController, // PageControllerをPageViewに接続
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_0.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_1.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_3.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/dashboard_4.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 40,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _pageController, // PageControllerを渡す
                      count: 5, // ページの数を4に変更
                      effect: WormEffect(
                        dotHeight: 8, // 点の高さを小さくする
                        dotWidth: 8, // 点の幅を小さくする
                        activeDotColor: Colors.grey[800]!, // アクティブな点の色を濃い灰色にする
                        dotColor: Colors.grey[400]!, // 非アクティブな点の色を薄い灰色にする
                      ), // インジケータのエフェクト
                      onDotClicked: (index) {
                        _pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.116),
                  child: Container(
                    height: 50, // お好みの高さに設定してください
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0CD64), // 背景色
                      borderRadius: BorderRadius.circular(29.0), // 角の丸み
                      border: Border.all(
                        color: Colors.black, // 枠線の色
                        width: 2.0, // 枠線の太さ
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 24, 24, 55), // 影の色
                          spreadRadius: 1, // 影の広がり
                          blurRadius: 0, // 影のぼかし
                          offset: Offset(1, 3), // 影の位置
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: const Text(
                                '新規登録', // ボタンのテキスト
                                style: TextStyle(
                                  fontSize: 18, // テキストのサイズ
                                  color: Colors.black, // テキストの色
                                  fontWeight: FontWeight.bold, // テキストの太さ
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.116),
                  child: Container(
                    height: 50, // お好みの高さに設定してください
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF), // 背景色
                      borderRadius: BorderRadius.circular(29.0), // 角の丸み
                      border: Border.all(
                        color: Colors.black, // 枠線の色
                        width: 2.0, // 枠線の太さ
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 24, 24, 55), // 影の色
                          spreadRadius: 1, // 影の広がり
                          blurRadius: 0, // 影のぼかし
                          offset: Offset(1, 3), // 影の位置
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: const Text(
                                'ログイン', // ボタンのテキスト
                                style: TextStyle(
                                  fontSize: 18, // テキストのサイズ
                                  color: Colors.black, // テキストの色
                                  fontWeight: FontWeight.bold, // テキストの太さ
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
