import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'home_all_page.dart';
import 'home_my_page.dart'; // Importing home_my_page.dart
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_page.dart';
import 'profile.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key? key, required this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TabController _tabController;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    requestPermission();
    getToken();
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void checkNotificationPermissionStatus() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    print('Notification permission status: ${settings.authorizationStatus}');
  }

  void getToken() async {
    String? token = await messaging.getToken();
    print('Device token: $token');

    saveTokenToDatabase(token);
  }

  void saveTokenToDatabase(String? token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'token':
          token, // Save the token to the 'token' field of the user document
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = auth.currentUser;
    // String? email = user != null ? user.email : 'No user signed in';

    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('users').doc(user?.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("エラーが発生しました");
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
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.0512),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(80.0), // AppBarの高さを設定
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                          child: Container(
                            // margin: const EdgeInsets.only(top: 0, left: 33.0),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      '${data['iconUrl']}'), // ユーザーアイコンのURL
                                  fit: BoxFit.scaleDown,
                                ),
                                border: Border.all(
                                  color: Colors.black, // 線の色を設定
                                  width: 1.0, // 線の幅を設定
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 24, 24, 55)
                                        .withOpacity(1), // 影の色を設定
                                    spreadRadius: 0.1, // 影の広がりを設定
                                    blurRadius: 1, // 影のぼかしを設定
                                    offset: const Offset(3, 3), // 影の位置を設定
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 30.0),
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/test3.svg',
                              semanticsLabel: 'shopping',
                              width: 190,
                              height: 25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5.0),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationPage(),
                              ), // NotificationPageに遷移
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icon_bell.svg',
                            width: 22,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsPage(),
                              ), // NotificationPageに遷移
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icon_settings.svg',
                            width: 22,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 386.0, // 幅を設定
                          height: 57.0,
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff), // 背景色を設定
                            borderRadius: BorderRadius.circular(28.5),
                            border: Border.all(
                              color: Colors.black, // 線の色を設定
                              width: 1.5, // 線の幅を設定
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 24, 24, 55)
                                    .withOpacity(1), // 影の色を設定
                                spreadRadius: 0.1, // 影の広がりを設定
                                blurRadius: 1, // 影のぼかしを設定
                                offset: const Offset(3, 3), // 影の位置を設定
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 120.0), // 左側に余白を追加
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  border: InputBorder.none,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 10.0),
                                    child: Image.asset(
                                      'assets/icon_search.png', // 画像のパスを指定
                                      width: 22.0, // 幅を調整
                                      height: 22.0, // 高さを調整
                                    ),
                                  ),
                                  hintText: '気になる質問を探してみよう...', // ヒントテキストを追加
                                  hintStyle: const TextStyle(
                                    fontSize: 15.0, // フォントサイズを大きくする
                                    color: Colors.grey, // フォントカラーを設定
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 19.0),
                      Container(
                        width: 386.0, // 幅を設定
                        height: 68.0, // 高さを設定
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF1E5),
                          border:
                              Border.all(color: Colors.black, width: 2), // 枠を設定
                          borderRadius: BorderRadius.circular(10), // 角を丸くする
                        ),
                        child: CustomTabBar(tabController: _tabController),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            HomeAllPage(email: widget.email),
                            HomeMyPage(
                                email: widget.email), // HomeMyPage widget
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (widget.tabController.indexIsChanging) {
      if (mounted) {
        // ウィジェットがまだウィジェットツリーに存在するかをチェック
        setState(() {
          _selectedIndex = widget.tabController.index;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection); // リスナーを削除
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide.none,
      ),
      tabs: [
        _buildTab(0, 'assets/icon_question_all.png', 'みんなの投稿'),
        _buildTab(1, 'assets/icon_question_my.png', '自分の投稿'),
      ],
    );
  }

  Widget _buildTab(int index, String iconPath, String text) {
    bool isSelected = index == _selectedIndex;
    return Tab(
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFF0CD64), // 選択されたタブの背景色
                border: Border.all(color: Colors.black, width: 2), // 枠線
                borderRadius: BorderRadius.circular(10), // 角丸
              )
            : null, // 選択されていないタブはスタイルなし
        child: Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(iconPath),
              const SizedBox(width: 8.0),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
