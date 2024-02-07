import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'question_detail.dart';

class IconSelector extends StatefulWidget {
  final List<String> iconUrls;
  final String initialIconUrl;
  final Function(String) onIconSelected;

  const IconSelector({
    Key? key,
    required this.iconUrls,
    required this.initialIconUrl,
    required this.onIconSelected,
  }) : super(key: key);

  @override
  _IconSelectorState createState() => _IconSelectorState();
}

class _IconSelectorState extends State<IconSelector> {
  int selectedIconIndex = 0;
  late String iconUrl;

  @override
  void initState() {
    super.initState();
    // iconUrlsリストからinitialIconUrlに一致するアイテムのインデックスを取得し、
    // そのインデックスをselectedIconIndexに設定します。
    // 一致するアイテムがない場合は、selectedIconIndexを0（リストの最初のアイテム）に設定します。
    selectedIconIndex = widget.iconUrls.indexOf(widget.initialIconUrl);
    if (selectedIconIndex == -1) {
      selectedIconIndex = 0; // 一致するアイテムがない場合のデフォルト値
    }
    iconUrl = widget.iconUrls[selectedIconIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 43,
        ),
        Container(
          width: 230,
          child: Stack(
            children: [
              Transform.translate(
                offset: Offset(35, 0), // 右に20ポイント移動
                child: Container(
                  width: 144,
                  height: 144,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // 枠線の色
                      width: 4.2, // 枠線の幅
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(iconUrl,
                        fit: BoxFit.cover), // カレントユーザーのアイコンを表示
                  ),
                ),
              ),
              Positioned(
                bottom: 0, // 下端に配置
                right: 38, // 右端に配置
                child: SvgPicture.asset(
                  'assets/icon_check_mark.svg',
                  width: 52, // 画像の幅
                  height: 52, // 画像の高さ
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Container(
          height: 75,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.iconUrls.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIconIndex = index;
                    iconUrl = widget.iconUrls[index];
                  });
                  widget.onIconSelected(iconUrl);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 5.5),
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // 枠線の色
                      width: 2.5, // 枠線の幅
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      widget.iconUrls[index],
                      fit: BoxFit.cover,
                      width: 56,
                      height: 56,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 塗りつぶしのスタイルを適用
    final borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke; // 枠線のスタイルを適用

    final path = Path();
    // 左下を起点にし、さらに下げる
    path.moveTo(0, size.height * 1.5); // 高さを少し小さく調整
    // 右下へ線を引くが、上にあげる
    path.lineTo(size.width / 2, size.height * 1); // 高さを少し小さく調整
    // 上中央へ線を引く
    path.lineTo(size.width / 2, size.height * 0.1); // 高さを少し小さく調整
    // 最初の点に戻る
    path.close();

    // 塗りつぶしのパスを描画
    canvas.drawPath(path, paint);
    // 枠線のパスを描画
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class SpeechBubblePainterWhite extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill; // 塗りつぶしのスタイルを適用
    // final borderPaint = Paint()
    //   ..color = Colors.black
    //   ..strokeWidth = 1.0
    //   ..style = PaintingStyle.stroke; // 枠線のスタイルを適用

    final path = Path();
    // 左下を起点にし、さらに下げる
    path.moveTo(0, size.height * 1.5); // 高さを少し小さく調整
    // 右下へ線を引くが、上にあげる
    path.lineTo(size.width / 2, size.height * 1); // 高さを少し小さく調整
    // 上中央へ線を引く
    path.lineTo(size.width / 2, size.height * 0.1); // 高さを少し小さく調整
    // 最初の点に戻る
    path.close();

    // 塗りつぶしのパスを描画
    canvas.drawPath(path, paint);
    // 枠線のパスを描画
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class UserProfileProvider with ChangeNotifier {
  String _nickname = '';
  String _iconUrl = '';

  String get nickname => _nickname;
  String get iconUrl => _iconUrl;

  void updateProfile(String newNickname, String newIconUrl) {
    _nickname = newNickname;
    _iconUrl = newIconUrl;
    notifyListeners(); // リスナーに変更を通知
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nicknameController = TextEditingController();
  String selectedIconUrl = '';

  @override
  void dispose() {
    // ウィジェットのライフサイクルが終了するときにコントローラーを破棄
    nicknameController.dispose();
    super.dispose();
  }

  int selectedIconIndex = 0; // 選択されたアイコンのインデックス
  List<String> iconImages = [
    'icon1',
    'icon2',
    'icon3',
    'icon4',
    'icon5',
    'icon6'
  ];
  List<String> iconUrls = [
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/1.png?alt=media&token=5fef8a01-f454-45ae-a0ee-4aef9ba7bdd1',
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/2.png?alt=media&token=747c989a-6dba-4115-b2de-1a1402523be0',
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/3.png?alt=media&token=db713cdc-4206-4ca1-899c-33fdf4a397e4',
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/4.png?alt=media&token=60cef998-af0f-4af6-8d74-ceb6090528ef',
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/5.png?alt=media&token=854d7b3b-8cfe-4969-92c2-948af7f99672',
    'https://firebasestorage.googleapis.com/v0/b/flutter-question-answer.appspot.com/o/6.png?alt=media&token=9370a145-8efd-4e8b-82a4-a68ccbff93e8'
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
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
              preferredSize: const Size.fromHeight(80.0), // AppBarの高さを80に設定
              child: Container(
                height: 146.0,
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(); // 画面を戻るアクション
                      },
                      child: Container(
                        // 左側に23のマージンを追加
                        width: 44,
                        height: 44,
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
                            'プロフィール',
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
            body: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 192,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1E5), // 背景色を設定
                      border: Border.all(
                        color: Colors.black, // 枠線の色を黒に設定
                        width: 2.0, // 枠線の太さを2.0に設定
                      ),
                      borderRadius: BorderRadius.circular(10.0), // 角の丸みを半径10に設定
                      boxShadow: [
                        // 影を追加
                        BoxShadow(
                          color: const Color.fromARGB(255, 24, 24, 55)
                              .withOpacity(1), // 影の色を設定
                          spreadRadius: 0.1, // 影の広がりを設定
                          blurRadius: 1, // 影のぼかしを設定
                          offset: const Offset(3, 3), // 影の位置を設定
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("エラーが発生しました");
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // データの読み込み中に表示
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.data() == null) {
                              return Text("データが存在しません");
                            }

                            Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            String iconUrl = userData['iconUrl'];
                            String nickname = userData['nickname'] ?? '匿名';
                            DateTime createdAt =
                                (userData['createdAt'] as Timestamp).toDate();
                            // intlパッケージを使用して年と月を取得
                            String registrationDate =
                                intl.DateFormat('yyyy年MM月').format(createdAt);

                            return Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // 中央に配置
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          insetPadding: EdgeInsets.fromLTRB(
                                              21, 150, 21, 130),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFFBFAF),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 2.0,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10.0),
                                                      topRight:
                                                          Radius.circular(10.0),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Container(
                                                          margin: EdgeInsets.only(
                                                              left:
                                                                  36), // 右に36のマージンを追加
                                                          child: Center(
                                                            child: Text(
                                                              'プロフィールの編集',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Image.asset(
                                                          'assets/icon_close_orange.png', // 画像ファイルのパスを指定
                                                          width:
                                                              24, // アイコンの幅を指定
                                                          height:
                                                              24, // アイコンの高さを指定
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(); // 画面を戻るアクション
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                10.0),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10.0),
                                                      ),
                                                      border: Border(
                                                        top: BorderSide(
                                                            width: 0.1,
                                                            color:
                                                                Colors.black),
                                                        left: BorderSide(
                                                            width: 2.0,
                                                            color:
                                                                Colors.black),
                                                        right: BorderSide(
                                                            width: 2.0,
                                                            color:
                                                                Colors.black),
                                                        bottom: BorderSide(
                                                            width: 2.0,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      color: Color(0xFFF5D8D6),
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        IconSelector(
                                                          iconUrls: iconUrls,
                                                          initialIconUrl:
                                                              iconUrl, // アイコンのURLリストを渡す
                                                          onIconSelected:
                                                              (String url) {
                                                            setState(() {
                                                              selectedIconUrl =
                                                                  url; // 選択されたアイコンのURLをselectedIconUrlに設定
                                                              print(
                                                                  '選択されたアイコンのURL: $selectedIconUrl');
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 32,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 28.0,
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                    'ニックネーム',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller: nicknameController
                                                                  ..text = userData[
                                                                          'nickname'] ??
                                                                      'ニックネームを入力してください',
                                                                decoration:
                                                                    InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left:
                                                                              10.0), // 左に10.0のパディングを追加
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .black, // 枠線の色
                                                                      width:
                                                                          2.0, // 枠線の幅
                                                                    ),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .blue, // フォーカス時の枠線の色
                                                                      width:
                                                                          2.0, // フォーカス時の枠線の幅
                                                                    ),
                                                                  ),
                                                                  filled: true,
                                                                  fillColor:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 28,
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  // ニックネームとアイコンURLの変更を保存するための変数
                                                                  String
                                                                      newNickname =
                                                                      nicknameController
                                                                          .text; // TextFormFieldのControllerを使用
                                                                  String
                                                                      newIconUrl =
                                                                      selectedIconUrl; // IconSelectorから選択されたアイコンのURL

                                                                  try {
                                                                    // FirebaseAuthから現在のユーザーIDを取得
                                                                    String
                                                                        userId =
                                                                        FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid;

                                                                    // Firestoreのusersコレクションにある現在のユーザーのドキュメントを更新
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            userId)
                                                                        .update({
                                                                      'nickname':
                                                                          newNickname, // 新しいニックネーム
                                                                      'iconUrl':
                                                                          newIconUrl, // 新しいアイコンURL
                                                                    });

                                                                    // アイコンURLの状態を更新してUIを再構築
                                                                    setState(
                                                                        () {
                                                                      iconUrl =
                                                                          newIconUrl;
                                                                    });
                                                                    // 成功した場合の処理（例：トーストメッセージの表示、画面遷移など）
                                                                    print(
                                                                        'プロフィールを更新しました');
                                                                    // ダイアログを閉じる
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  } catch (e) {
                                                                    // エラーが発生した場合の処理
                                                                    print(
                                                                        'プロフィールの更新に失敗しました: $e');
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 46.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color(
                                                                        0xFFF0CD64),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            2),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            29),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      '変更を保存',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 16,
                                                              ),
                                                            ],
                                                          ),
                                                        ), // 3つ目のContainer
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                // 他の子ウィジェット...
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 65,
                                    child: Stack(
                                      children: [
                                        Transform.translate(
                                          offset: Offset(3, 0),
                                          child: Container(
                                            width: 58,
                                            height: 58,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(iconUrl),
                                              ),
                                              border: Border.all(
                                                color: Colors.black, // 線の色を設定
                                                width: 1.0, // 線の幅を設定
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 24, 24, 55)
                                                      .withOpacity(1),
                                                  spreadRadius: 0.3,
                                                  blurRadius: 0,
                                                  offset:
                                                      const Offset(1.5, 2.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 2, // 下端に配置
                                          right: 0, // 右端に配置
                                          child: SvgPicture.asset(
                                            'assets/icon_check_mark.svg',
                                            width: 25, // 画像の幅
                                            height: 25, // 画像の高さ
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5), // アイコンとニックネームの間のスペース
                                Text(
                                  nickname,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize:
                                      MainAxisSize.min, // 必要最小限のスペースを使用する
                                  children: <Widget>[
                                    Image.asset('assets/calendar.png'),
                                    Text(
                                      '登録日 $registrationDate',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ProfileFourTabs(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getNickname(String uid) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return userData['nickname'] ?? '匿名';
  }
}

class ProfileFourTabs extends StatefulWidget {
  const ProfileFourTabs({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileFourTabsState createState() => _ProfileFourTabsState();
}

class _ProfileFourTabsState extends State<ProfileFourTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 46.0, // 高さを設定
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1E5),
              border: Border.all(color: Colors.black, width: 2), // 枠を設定
              borderRadius: BorderRadius.circular(10), // 角を丸くする
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: _selectedIndex == index
                        ? BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            color: const Color(0xFFF0CD64),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          [
                            'assets/Q.svg',
                            'assets/A.svg',
                            'assets/icon_bookmark_black.svg',
                            'assets/icon_thumbup_black.svg',
                          ][index],
                          width: 15.0,
                          height: 15.0,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ['自分の投稿', '自分の回答', '保存した質問', 'いいねした回答'][index],
                          style: TextStyle(
                            color: _selectedIndex == index
                                ? Colors.black
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: <Widget>[
                _selectedIndex == 0
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore
                            .instance // StreamBuilderの内容stream: FirebaseFirestore.instance
                            .collection('questions')
                            .where('uid',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('エラーが発生しました');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("読み込み中...");
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> data =
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>;
                              String userIconUrl = data['iconUrl'] ??
                                  'http://flat-icon-design.com/f/f_object_111/s512_f_object_111_0bg.png';
                              // TextPainterを使用してテキストの幅を計算
                              TextPainter textPainter = TextPainter(
                                text: TextSpan(
                                  text: data['text1'],
                                  style: const TextStyle(
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                maxLines: 1,
                                textDirection: TextDirection.ltr,
                              );
                              textPainter.layout();

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QuestionDetailPage(
                                        questionId: snapshot.data!.docs[index]
                                            .id, // ドキュメントのIDを渡す
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 200.0, // 幅を設定
                                  height: 175.0,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ), // 横の余白を大きくする
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF2E8), // コンテナの色を変更
                                    border: Border.all(
                                      color: Colors.black, // 枠の色
                                      width: 1.5, // 枠の幅
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(10.0), // 丸みの半径
                                    boxShadow: [
                                      // 影を追加
                                      BoxShadow(
                                        color: const Color.fromARGB(
                                                255, 24, 24, 55)
                                            .withOpacity(1), // 影の色を設定
                                        spreadRadius: 0.1, // 影の広がりを設定
                                        blurRadius: 1, // 影のぼかしを設定
                                        offset: const Offset(3, 3), // 影の位置を設定
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 23, bottom: 19),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              const SizedBox(height: 18.0),
                                              Row(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 5),
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Positioned(
                                                              top: 24,
                                                              child: Container(
                                                                width:
                                                                    textPainter
                                                                        .width,
                                                                height: 6.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xFFFB99BF),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5), // 線の厚み分だけテキストを下にずらす
                                                              child: Text(
                                                                data['text1'],
                                                                style:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      'NotoSansJP',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 22,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const Text(
                                                    'に、',
                                                    style: TextStyle(
                                                      fontFamily: 'NotoSansJP',
                                                      fontWeight: FontWeight
                                                          .bold, // 太字に設定
                                                      fontSize: 21,
                                                      color: Colors
                                                          .black, // テキストの色を指定
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8.0),
                                              Container(
                                                height: 42.0,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFFFFFFF), // 背景色を設定
                                                  border: Border.all(
                                                    color: Colors
                                                        .black, // 枠線の色を黒に設定
                                                    width: 2.0, // 枠線の太さを2.0に設定
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // 角の丸みを半径10に設定
                                                ), // コンテナの高さを42に設定

                                                child: Column(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      data['text2'],
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'NotoSansJP',
                                                        fontWeight: FontWeight
                                                            .bold, // 太字に設定
                                                        fontSize:
                                                            21, // テキストサイズを22に設定
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 11.0),
                                              const Text(
                                                'って言われたらなんて返す？',
                                                style: TextStyle(
                                                  fontFamily: 'NotoSansJP',
                                                  fontWeight:
                                                      FontWeight.bold, // 太字に設定
                                                  fontSize: 21, // テキストサイズを22に設定
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 174.0,
                                        width: 51.0,
                                        margin:
                                            const EdgeInsets.only(right: 14.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            const SizedBox(height: 21),
                                            Container(
                                              width: 43.0, // 直径43ピクセル
                                              height: 43.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image:
                                                      NetworkImage(userIconUrl),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                                border: Border.all(
                                                  color: Colors.black, // 線の色を設定
                                                  width: 1.0, // 線の幅を設定
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: const Color.fromARGB(
                                                            255, 24, 24, 55)
                                                        .withOpacity(1),
                                                    spreadRadius: 0.3,
                                                    blurRadius: 0,
                                                    offset:
                                                        const Offset(1.5, 2.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              '15分前',
                                              style: TextStyle(
                                                fontSize: 10.0, // フォントサイズを10に設定
                                              ),
                                            ),
                                            const SizedBox(height: 53),
                                            Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(
                                                  right: 1),
                                              child: Image.asset(
                                                  'assets/icon_bookmark.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                _selectedIndex == 1
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('questions')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> questionsSnapshot) {
                          if (questionsSnapshot.hasError) {
                            return const Text('エラーが発生しました');
                          }
                          if (questionsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          // カレントユーザーのUIDを取得
                          String currentUserId =
                              FirebaseAuth.instance.currentUser?.uid ?? '';

                          // questionsドキュメントのリストを取得
                          List<DocumentSnapshot> questionDocs =
                              questionsSnapshot.data!.docs;

                          return ListView.builder(
                            itemCount: questionDocs.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot document =
                                  questionsSnapshot.data!.docs[index];
                              DocumentSnapshot questionDoc =
                                  questionDocs[index];
                              Map<String, dynamic> questionData =
                                  questionDoc.data() as Map<String, dynamic>;

                              // repliesサブコレクションのStreamBuilder
                              return StreamBuilder<QuerySnapshot>(
                                stream: questionDoc.reference
                                    .collection('replies')
                                    .where('uid', isEqualTo: currentUserId)
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot>
                                        repliesSnapshot) {
                                  if (repliesSnapshot.hasError) {
                                    return const Text('エラーが発生しました');
                                  }
                                  if (repliesSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  // repliesドキュメントのリストを取得
                                  List<DocumentSnapshot> replyDocs =
                                      repliesSnapshot.data!.docs;

                                  return Column(
                                    //quesitonとrepliesの二つの情報を別で取ってくる必要がある。

                                    children: replyDocs
                                        .map((DocumentSnapshot replyDoc) {
                                      Map<String, dynamic> replyData = replyDoc
                                          .data() as Map<String, dynamic>;

                                      User? currentUser =
                                          FirebaseAuth.instance.currentUser;

                                      return Container(
                                        child: AnswersCardContainsQAndA(
                                          questionData: questionData,
                                          replyData: replyData,
                                          currentUser: currentUser,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                                // ggaga
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                _selectedIndex == 2
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('bookmarks')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> bookmarkSnapshot) {
                          if (bookmarkSnapshot.hasError) {
                            return const Text('エラーが発生しました');
                          }
                          if (bookmarkSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          var bookmarkedQuestionsIds = bookmarkSnapshot
                              .data!.docs
                              .map((doc) =>
                                  doc['qid']) // 'qid'はブックマークされた質問のIDを指します
                              .where((qid) => qid != null) // nullでないIDのみを取得
                              .toList();

                          // bookmarkedQuestionsIdsが空の場合は、何も表示しないか、メッセージを表示します。
                          if (bookmarkedQuestionsIds.isEmpty) {
                            return const Text('ブックマークされた質問はありません。');
                          }

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('questions')
                                .where(FieldPath.documentId,
                                    whereIn: bookmarkedQuestionsIds)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> questionSnapshot) {
                              if (questionSnapshot.hasError) {
                                return const Text('エラーが発生しました');
                              }
                              if (questionSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              return ListView.builder(
                                itemCount: questionSnapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> data =
                                      questionSnapshot.data!.docs[index].data()
                                          as Map<String, dynamic>;
                                  String userIconUrl = data['iconUrl'];
                                  DocumentSnapshot document =
                                      questionSnapshot.data!.docs[index];
                                  String questionId =
                                      document.id; // ここでquestionIdを取得
                                  TextPainter textPainter = TextPainter(
                                    text: TextSpan(
                                      text: data['text1'],
                                      style: const TextStyle(
                                        fontFamily: 'NotoSansJP',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                    maxLines: 1,
                                    textDirection: TextDirection.ltr,
                                  );
                                  textPainter.layout();

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              QuestionDetailPage(
                                            questionId: questionSnapshot.data!
                                                .docs[index].id, // ドキュメントのIDを渡す
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 200.0, // 幅を設定
                                      height: 175.0,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ), // 横の余白を大きくする
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFFFFF2E8), // コンテナの色を変更
                                        border: Border.all(
                                          color: Colors.black, // 枠の色
                                          width: 1.5, // 枠の幅
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            10.0), // 丸みの半径
                                        boxShadow: [
                                          // 影を追加
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 24, 24, 55)
                                                .withOpacity(1), // 影の色を設定
                                            spreadRadius: 0.1, // 影の広がりを設定
                                            blurRadius: 1, // 影のぼかしを設定
                                            offset:
                                                const Offset(3, 3), // 影の位置を設定
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 23, bottom: 19),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const SizedBox(height: 18.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 5),
                                                            child: Stack(
                                                              children: <Widget>[
                                                                Positioned(
                                                                  top: 24,
                                                                  child:
                                                                      Container(
                                                                    width: textPainter
                                                                        .width,
                                                                    height: 6.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                          0xFFFB99BF),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              3),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          5), // 線の厚み分だけテキストを下にずらす
                                                                  child: Text(
                                                                    data[
                                                                        'text1'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'NotoSansJP',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          22,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const Text(
                                                        'に、',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'NotoSansJP',
                                                          fontWeight: FontWeight
                                                              .bold, // 太字に設定
                                                          fontSize: 21,
                                                          color: Colors
                                                              .black, // テキストの色を指定
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Container(
                                                    height: 42.0,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xFFFFFFFF), // 背景色を設定
                                                      border: Border.all(
                                                        color: Colors
                                                            .black, // 枠線の色を黒に設定
                                                        width:
                                                            2.0, // 枠線の太さを2.0に設定
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0), // 角の丸みを半径10に設定
                                                    ), // コンテナの高さを42に設定

                                                    child: Column(
                                                      // mainAxisAlignment:
                                                      //     MainAxisAlignment.end,
                                                      children: <Widget>[
                                                        const SizedBox(
                                                            height: 4.0),
                                                        Text(
                                                          data['text2'],
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'NotoSansJP',
                                                            fontWeight: FontWeight
                                                                .bold, // 太字に設定
                                                            fontSize:
                                                                21, // テキストサイズを22に設定
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 11.0),
                                                  const Text(
                                                    'って言われたらなんて返す？',
                                                    style: TextStyle(
                                                      fontFamily: 'NotoSansJP',
                                                      fontWeight: FontWeight
                                                          .bold, // 太字に設定
                                                      fontSize:
                                                          21, // テキストサイズを22に設定
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 174.0,
                                            width: 51.0,
                                            margin: const EdgeInsets.only(
                                                right: 14.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const SizedBox(height: 21),
                                                Container(
                                                  width: 43.0, // 直径43ピクセル
                                                  height: 43.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          userIconUrl),
                                                      fit: BoxFit.scaleDown,
                                                    ),
                                                    border: Border.all(
                                                      color: Colors
                                                          .black, // 線の色を設定
                                                      width: 1.0, // 線の幅を設定
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color
                                                                .fromARGB(
                                                                255, 24, 24, 55)
                                                            .withOpacity(1),
                                                        spreadRadius: 0.3,
                                                        blurRadius: 0,
                                                        offset: const Offset(
                                                            1.5, 2.5),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                const Text(
                                                  '15分前',
                                                  style: TextStyle(
                                                    fontSize:
                                                        10.0, // フォントサイズを10に設定
                                                  ),
                                                ),
                                                const SizedBox(height: 53),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        User? currentUser =
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser;
                                                        if (currentUser !=
                                                            null) {
                                                          String uid =
                                                              currentUser.uid;
                                                          String questionId =
                                                              questionSnapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id;

                                                          // bookmarksサブコレクションへの参照を取得
                                                          DocumentReference
                                                              bookmarkRef =
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .doc(uid)
                                                                  .collection(
                                                                      'bookmarks')
                                                                  .doc(
                                                                      questionId);

                                                          // ドキュメントが存在するか確認
                                                          DocumentSnapshot
                                                              bookmarkSnapshot =
                                                              await bookmarkRef
                                                                  .get();

                                                          if (!bookmarkSnapshot
                                                              .exists) {
                                                            // ブックマークが存在しない場合は追加
                                                            await bookmarkRef
                                                                .set({
                                                              'qid': questionId,
                                                              'uid': uid,
                                                              'timestamp':
                                                                  FieldValue
                                                                      .serverTimestamp(),
                                                            });
                                                          } else {
                                                            // ブックマークが存在する場合は削除
                                                            await bookmarkRef
                                                                .delete();
                                                          }
                                                        }
                                                      },
                                                      child: StreamBuilder<
                                                          DocumentSnapshot>(
                                                        stream: FirebaseAuth
                                                                    .instance
                                                                    .currentUser !=
                                                                null
                                                            ? FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                                .collection(
                                                                    'bookmarks')
                                                                .doc(questionId)
                                                                .snapshots()
                                                            : null,
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const SizedBox
                                                                .shrink();
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data!
                                                                  .exists) {
                                                            return SvgPicture
                                                                .asset(
                                                              'assets/icon_bookmark_black.svg',
                                                              key: UniqueKey(),
                                                            ); // ブックマークあり
                                                          } else {
                                                            return SvgPicture
                                                                .asset(
                                                              'assets/icon_bookmark_white.svg',
                                                              key: UniqueKey(),
                                                            ); // ブックマークなし
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                _selectedIndex == 3 ? FavoriteQuestionsPage() : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteQuestionsPage extends StatefulWidget {
  @override
  _FavoriteQuestionsPageState createState() => _FavoriteQuestionsPageState();
}

class _FavoriteQuestionsPageState extends State<FavoriteQuestionsPage> {
  Future<Map<String, String>> fetchFavoriteList() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      Map<String, String> favoriteList =
          (userDoc.data() as Map<String, dynamic>)['favoriteList']
                  ?.cast<String, String>() ??
              {};
      return favoriteList;
    } else {
      return {};
    }
  }

  // favoriteListを使用して質問データと回答データを取得し、ウィジェットのリストを返す関数
  Future<List<Widget>> fetchQuestionsAndProcess() async {
    List<Widget> widgets = [];
    Map<String, String> favoriteList = await fetchFavoriteList();

    for (var entry in favoriteList.entries) {
      String replyId = entry.key;
      String questionId = entry.value;

      // 質問データ（questionData）を取得
      DocumentSnapshot questionSnapshot = await FirebaseFirestore.instance
          .collection('questions')
          .doc(questionId)
          .get();
      Map<String, dynamic> questionData =
          questionSnapshot.data() as Map<String, dynamic>? ?? {};

      print('questionData: $questionData');

      // 回答データ（replyData）を取得
      DocumentSnapshot replySnapshot = await FirebaseFirestore.instance
          .collection('questions') // 親コレクション
          .doc(questionId) // 親ドキュメントのID
          .collection('replies') // サブコレクション
          .doc(replyId) // 回答のドキュメントID
          .get();
      Map<String, dynamic> replyData =
          replySnapshot.data() as Map<String, dynamic>? ?? {};

      print('replyData: $replyData');

      // AnswersCardContainsQAndAをリストに追加
      widgets.add(AnswersCardContainsQAndA(
        questionData: questionData,
        replyData: replyData,
        currentUser: FirebaseAuth.instance.currentUser,
      ));
    }

    return widgets; // 修正: widgetsリストを返す
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future:
          fetchQuestionsAndProcess(), // 修正: _buildFavoriteQuestionsWidgets()をfetchQuestionsAndProcess()に置き換え
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("エラーが発生しました");
        } else if (snapshot.hasData) {
          return ListView(
            children: snapshot.data!,
          );
        } else {
          return Text("データがありません");
        }
      },
    );
  }
}

class AnswersCardContainsQAndA extends StatelessWidget {
  const AnswersCardContainsQAndA({
    super.key,
    required this.questionData,
    required this.replyData,
    required this.currentUser,
  });

  final Map<String, dynamic> questionData;
  final Map<String, dynamic> replyData;

  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            top: -6, // 位置の調整
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 6, 0, 6),
              decoration: BoxDecoration(
                color: Color(0xFFFFF1E5), // 背景色
                borderRadius: BorderRadius.circular(19.0), // 角の半径を19に設定
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFF1E5), // 背景色
              borderRadius: BorderRadius.circular(19.0), // 角の半径を19に設定
              border: Border.all(
                color: Colors.black, // 枠線の色
                width: 2.0, // 枠線の幅
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 36,
                ),
                AnswerOnAnswerCard(
                  replyData: replyData,
                  currentUser: currentUser, // widget.questionIdを渡す
                ),
              ],
            ),
          ),
          QuestionOnAnswerCard(questionData: questionData),
        ],
      ),
    );
  }
}

class AnswerOnAnswerCard extends StatelessWidget {
  const AnswerOnAnswerCard({
    super.key,
    required this.replyData,
    required this.currentUser,
  });

  final Map<String, dynamic> replyData;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(6, 10, 0, 10),
      child: Row(
        // これを追加
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  width: 5,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              replyData['iconUrl'] ?? 'デフォルトの画像URL'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Stack(
                    clipBehavior: Clip.none, // クリップを無効にして、子が親の範囲外に描画できるようにする
                    children: [
                      Positioned(
                        left: -8, // 吹き出しの位置を左に調整
                        bottom: 15, // 吹き出しの位置を上に調整
                        child: CustomPaint(
                          painter: SpeechBubblePainter(),
                          size: const Size(20, 10), // 吹き出しのサイズを指定
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Text(
                          replyData['text'] ?? 'デフォルトのテキスト',
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
                      ),
                      Positioned(
                        left: -8, // 吹き出しの位置を左に調整
                        bottom: 15, // 吹き出しの位置を上に調整
                        child: CustomPaint(
                          painter: SpeechBubblePainterWhite(),
                          size: const Size(20, 10), // 吹き出しのサイズを指定
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FavoriteThumbup(
            replyData: replyData,
            currentUser: currentUser,
          ),
        ],
      ),
    );
  }
}

class FavoriteThumbup extends StatelessWidget {
  const FavoriteThumbup({
    super.key,
    required this.replyData,
    required this.currentUser,
  });

  final User? currentUser;
  String get currentUserId => currentUser?.uid ?? '';
  final Map<String, dynamic> replyData;
  bool get isLiked => replyData['likedBy']?.contains(currentUserId) ?? false;

  @override
  Widget build(BuildContext context) {
    int likes = replyData['likes'] ?? 0;
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
            left: 6,
            right: 6,
            bottom: 2,
          ),
          child: SvgPicture.asset(
            isLiked
                ? 'assets/icon_thumbup_black.svg'
                : 'assets/icon_thumbup_white.svg',
            semanticsLabel: 'thumbup',
            width: 20,
            height: 20,
          ),
        ),
        Container(
          child: Text(
            '$likes', // いいね数を表示
            style: TextStyle(
              fontSize: 14, // フォントサイズを適宜調整
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}

class QuestionOnAnswerCard extends StatelessWidget {
  const QuestionOnAnswerCard({
    super.key,
    required this.questionData,
  });

  final Map<String, dynamic> questionData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFE8A3), // 背景色
              borderRadius: BorderRadius.circular(19.0), // 角の半径を19に設定
              border: Border.all(
                color: Colors.black, // 枠線の色
                width: 2.0, // 枠線の幅
              ),
            ),
            height: 36.0,
            //全体の左右のPaddingのwidthを設定。paddingの設定より、少し短い。
            // width: MediaQuery.of(context).size.width * (1 - (0.0555 * 2)),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 14),
                SvgPicture.asset(
                  'assets/Q.svg',
                  width: 24.0,
                  height: 24.0,
                ),
                const SizedBox(width: 8), // アイコンとテキストの間にスペースを追加
                Text(
                  '${questionData['text1']} ➡︎' '「${questionData['text2']}」',
                  style: TextStyle(
                    fontSize: 14.0, // フォントサイズを14に設定
                    fontWeight: FontWeight.bold, // フォントウェイトを太字に設定
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
