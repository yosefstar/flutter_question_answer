import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFECEB),
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
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.049,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 12),
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: Color(0xFFFFF1E5), // Containerの背景色を設定
                border: Border.all(
                  color: Colors.black, // 枠線の色
                  width: 1.5, // 枠線の太さ
                ),
                borderRadius: BorderRadius.circular(10), // 角の丸み
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    width: 24, // 幅を設定
                    height: 24, // 高さを設定
                    child: SvgPicture.asset(
                        'assets/icon_notification.svg'), // SVGファイルを表示
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'アプリからの通知',
                    style: TextStyle(
                      fontSize: 14, // フォントサイズを14に設定
                      fontWeight: FontWeight.bold, // フォントを太字に設定
                      // 他に必要なスタイルがあればここに追加
                    ),
                  ),
                  Spacer(),
                  CupertinoSwitch(
                    value: _isSwitched,
                    onChanged: (bool value) {
                      setState(() {
                        _isSwitched = value; // スイッチの状態を更新
                      });
                    },
                    activeColor: Colors.black, // スイッチがオンのときの色
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
