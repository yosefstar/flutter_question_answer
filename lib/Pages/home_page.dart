import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'home_all_page.dart' as all_page;
import 'home_all_page.dart'; // エイリアス all_page を追加
import 'home_my_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'notification_page.dart';
import 'profile.dart';
import 'settings_page.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;

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
  Widget build(BuildContext context) {
    User? user = auth.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("エラーが発生しました");
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (!snapshot.hasData) {
              return const Text("データが存在しません");
            }
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
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(80.0), // AppBarの高さを設定
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 0.0512),
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
                            highlightColor:
                                Colors.transparent, // タップ時のハイライト色を透明に
                            splashColor: Colors.transparent,
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
                            onTap: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                final userId = user.uid;
                                final firestore = FirebaseFirestore.instance;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NotificationPage(),
                                  ),
                                );
                                final userNotificationsRef = firestore
                                    .collection('users')
                                    .doc(userId)
                                    .collection('notifications');

                                // Firestoreのバッチ処理を開始
                                final batch = firestore.batch();

                                // すべての通知のreadCountを1増やす
                                final querySnapshotIncrement =
                                    await userNotificationsRef.get();
                                for (var doc in querySnapshotIncrement.docs) {
                                  batch.update(doc.reference,
                                      {'readCount': FieldValue.increment(1)});
                                }

                                // readCountが10のドキュメントを検索して削除
                                final querySnapshotDelete =
                                    await userNotificationsRef
                                        .where('readCount', isEqualTo: 10)
                                        .get();
                                for (var doc in querySnapshotDelete.docs) {
                                  batch.delete(doc.reference);
                                }

                                // バッチ処理をコミットして更新と削除を適用
                                await batch.commit();

                                // NotificationPageに遷移
                              }
                            },
                            highlightColor:
                                Colors.transparent, // タップ時のハイライト色を透明に
                            splashColor: Colors.transparent,
                            child: SizedBox(
                              height: 36,
                              width: 25,
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 6,
                                    child: SvgPicture.asset(
                                      'assets/icon_bell.svg',
                                      width: 22,
                                      height: 24,
                                    ),
                                  ),
                                  Positioned(
                                    left: 11.0,
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser?.uid)
                                          .collection('notifications')
                                          .where('readCount', isEqualTo: 1)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Text('Loading...');
                                          default:
                                            // ドキュメントの数が0より大きい場合のみContainerを表示
                                            if (snapshot
                                                    .data?.docs.isNotEmpty ==
                                                true) {
                                              return Container(
                                                // 下部に1のパディングを追加
                                                width: 12.0, // 円の直径
                                                height: 12.0, // 円の直径
                                                decoration: BoxDecoration(
                                                  color: Colors.red, // 背景色を赤に設定
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        Colors.black, // 枠の色を設定
                                                    width: 1.0, // 枠の幅を設定
                                                  ), // 形状を円に設定
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    '${snapshot.data?.docs.length ?? 0}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 6,
                                                      fontWeight: FontWeight
                                                          .bold, // テキストのサイズを適切に調整
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else {
                                              // ドキュメントの数が0の場合は何も表示しない
                                              return SizedBox.shrink();
                                            }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                  ),
                  body: SearchBar(),
                ),
              ),
            );
        }
      },
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late TabController _tabController;
  bool _isTextFieldEmpty = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _searchController = TextEditingController();

    _searchController.addListener(() {
      setState(() {
        // テキストフィールドが空かどうかをチェック
        _isTextFieldEmpty = _searchController.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                padding: const EdgeInsets.only(right: 120.0), // 左側に余白を追加
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10.0),
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
        if (_isTextFieldEmpty) ...[
          CustomTabBarContainer(
            tabController: _tabController,
          ),
        ] else ...[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('questions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('エラーが発生しました');
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                // クライアントサイドでのフィルタリング
                var filteredDocs = snapshot.data!.docs.where((document) {
                  String text1 = document['text1'];
                  String text2 = document['text2'];
                  String searchText = _searchController.text.toLowerCase();
                  return text1.toLowerCase().contains(searchText) ||
                      text2.toLowerCase().contains(searchText);
                }).toList();

                // return ListView(
                //   children: filteredDocs.map((DocumentSnapshot document) {
                //     Map<String, dynamic> data =
                //         document.data()! as Map<String, dynamic>;
                //     return ListTile(
                //       title: Text(data['text1'] ?? '無題'),
                //       subtitle: Text(data['text2'] ?? '無し'),
                //     );
                //   }).toList(),
                // );
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.0512),
                  child: all_page.QuestionCard(snapshot: filteredDocs),
                ); // all_page エイリアスを使用
              },
            ),
          ),
        ],
      ],
    );
  }
}

class CustomTabBarContainer extends StatelessWidget {
  final TabController tabController;

  const CustomTabBarContainer({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 386.0, // 幅を設定
            height: 68.0, // 高さを設定
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E5),
              border: Border.all(color: Colors.black, width: 2), // 枠を設定
              borderRadius: BorderRadius.circular(10), // 角を丸くする
            ),
            child: CustomTabBar(tabController: tabController),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                HomeAllPage(),
                HomeMyPage(), // HomeMyPage widget
              ],
            ),
          ),
        ],
      ),
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
