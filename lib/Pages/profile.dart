import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;

import 'question_detail.dart';

class IconSelector extends StatefulWidget {
  final List<String> iconUrls;
  final Function(String) onIconSelected;

  const IconSelector({
    Key? key,
    required this.iconUrls,
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
    iconUrl = widget.iconUrls[selectedIconIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          child: Image.network(iconUrl), // カレントユーザーのアイコンを表示
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(widget.iconUrls[index]), // アイコンを横に並べて表示
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;

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
    'http://flat-icon-design.com/f/f_object_112/s512_f_object_112_0bg.png',
    'http://flat-icon-design.com/f/f_object_149/s512_f_object_149_0bg.png',
    'http://flat-icon-design.com/f/f_object_174/s512_f_object_174_0bg.png',
    'http://flat-icon-design.com/f/f_object_169/s512_f_object_169_0bg.png',
    'http://flat-icon-design.com/f/f_object_157/s512_f_object_157_2bg.png',
    'http://flat-icon-design.com/f/f_object_111/s512_f_object_111_0bg.png'
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
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData &&
                                  snapshot.data!.data() != null) {
                                Map<String, dynamic> userData = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                String iconUrl = userData['iconUrl'];
                                String nickname = userData['nickname'] ?? '匿名';
                                DateTime createdAt =
                                    (userData['createdAt'] as Timestamp)
                                        .toDate();
                                // intlパッケージを使用して年と月を取得
                                String registrationDate =
                                    intl.DateFormat('yyyy年MM月')
                                        .format(createdAt);
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
                                                  21, 150, 21, 200),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Container(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Container(
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFFBFAF),
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  10.0),
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Center(
                                                              child: Text(
                                                                'プロフィールの編集',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(Icons
                                                                .close), // 閉じるボタンのアイコン
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // ダイアログを閉じる
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
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
                                                                color: Colors
                                                                    .black),
                                                            left: BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .black),
                                                            right: BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                width: 2.0,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          color:
                                                              Color(0xFFF5D8D6),
                                                        ),
                                                        child: Column(
                                                          children: <Widget>[
                                                            IconSelector(
                                                              iconUrls:
                                                                  iconUrls, // アイコンのURLリストを渡す
                                                              onIconSelected:
                                                                  (selectedUrl) {
                                                                // アイコンが選択された時の処理
                                                                setState(() {
                                                                  // ここで選択されたアイコンのURLを使用して何かをする
                                                                  // 例えば、ユーザーのプロフィール画像を更新する
                                                                });
                                                              },
                                                            ),
                                                            Container(
                                                              child: Align(
                                                                alignment: Alignment
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
                                                            ), // 3つ目のContainer
                                                            Container(
                                                              child:
                                                                  TextFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      '${userData['nickname'] ?? 'ニックネームを入力してください'}',
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
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                // Firebaseに変更を保存する処理を追加
                                                              },
                                                              child: Container(
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
                                                                      width: 2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
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
                                              offset: const Offset(1.5, 2.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8), // アイコンとニックネームの間のスペース
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
                              } else {
                                return const Icon(Icons.account_circle,
                                    size: 100);
                              }
                            }
                            return const CircularProgressIndicator(); // データ取得中はローディングインジケータを表示
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
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
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    color: const Color(0xFFF0CD64),
                                    borderRadius: BorderRadius.circular(8),
                                  )
                                : null,
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 5),
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
                                  [
                                    '自分の投稿',
                                    '自分の回答',
                                    '保存した質問',
                                    'いいねした回答'
                                  ][index],
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // 枠線の色
                          width: 1.0, // 枠線の幅
                        ),
                      ),
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: <Widget>[
                          _selectedIndex == 0
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore
                                      .instance // StreamBuilderの内容stream: FirebaseFirestore.instance
                                      .collection('questions')
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                                builder: (context) =>
                                                    QuestionDetailPage(
                                                  questionId: snapshot
                                                      .data!
                                                      .docs[index]
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
                                              color: const Color(
                                                  0xFFFFF2E8), // コンテナの色を変更
                                              border: Border.all(
                                                color: Colors.black, // 枠の色
                                                width: 1.5, // 枠の幅
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0), // 丸みの半径
                                              boxShadow: [
                                                // 影を追加
                                                BoxShadow(
                                                  color: const Color.fromARGB(
                                                          255, 24, 24, 55)
                                                      .withOpacity(1), // 影の色を設定
                                                  spreadRadius: 0.1, // 影の広がりを設定
                                                  blurRadius: 1, // 影のぼかしを設定
                                                  offset: const Offset(
                                                      3, 3), // 影の位置を設定
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 23,
                                                            bottom: 19),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        const SizedBox(
                                                            height: 18.0),
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
                                                                          top:
                                                                              5),
                                                                  child: Stack(
                                                                    children: <Widget>[
                                                                      Positioned(
                                                                        top: 24,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              textPainter.width,
                                                                          height:
                                                                              6.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFFB99BF),
                                                                            borderRadius:
                                                                                BorderRadius.circular(3),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                5), // 線の厚み分だけテキストを下にずらす
                                                                        child:
                                                                            Text(
                                                                          data[
                                                                              'text1'],
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'NotoSansJP',
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                22,
                                                                            color:
                                                                                Colors.black,
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
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold, // 太字に設定
                                                                fontSize: 21,
                                                                color: Colors
                                                                    .black, // テキストの色を指定
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8.0),
                                                        Container(
                                                          height: 42.0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFFFFFFFF), // 背景色を設定
                                                            border: Border.all(
                                                              color: Colors
                                                                  .black, // 枠線の色を黒に設定
                                                              width:
                                                                  2.0, // 枠線の太さを2.0に設定
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold, // 太字に設定
                                                                  fontSize:
                                                                      21, // テキストサイズを22に設定
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 11.0),
                                                        const Text(
                                                          'って言われたらなんて返す？',
                                                          style: TextStyle(
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
                                                ),
                                                Container(
                                                  height: 174.0,
                                                  width: 51.0,
                                                  margin: const EdgeInsets.only(
                                                      right: 14.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      const SizedBox(
                                                          height: 21),
                                                      Container(
                                                        width: 43.0, // 直径43ピクセル
                                                        height: 43.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                userIconUrl),
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          ),
                                                          border: Border.all(
                                                            color: Colors
                                                                .black, // 線の色を設定
                                                            width:
                                                                1.0, // 線の幅を設定
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      24,
                                                                      24,
                                                                      55)
                                                                  .withOpacity(
                                                                      1),
                                                              spreadRadius: 0.3,
                                                              blurRadius: 0,
                                                              offset:
                                                                  const Offset(
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
                                                      const SizedBox(
                                                          height: 53),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 1),
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
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .collection('bookmarks')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          bookmarkSnapshot) {
                                    if (bookmarkSnapshot.hasError) {
                                      return const Text('エラーが発生しました');
                                    }
                                    if (bookmarkSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    var bookmarkedQuestionsIds = bookmarkSnapshot
                                        .data!.docs
                                        .map((doc) => doc[
                                            'qid']) // 'qid'はブックマークされた質問のIDを指します
                                        .where((qid) =>
                                            qid != null) // nullでないIDのみを取得
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
                                          AsyncSnapshot<QuerySnapshot>
                                              questionSnapshot) {
                                        if (questionSnapshot.hasError) {
                                          return const Text('エラーが発生しました');
                                        }
                                        if (questionSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        }

                                        return ListView.builder(
                                          itemCount: questionSnapshot
                                              .data!.docs.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Map<String, dynamic> data =
                                                questionSnapshot
                                                        .data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>;
                                            String userIconUrl =
                                                data['iconUrl'];
                                            // TextPainterを使用してテキストの幅を計算
                                            TextPainter textPainter =
                                                TextPainter(
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
                                                      questionId: questionSnapshot
                                                          .data!
                                                          .docs[index]
                                                          .id, // ドキュメントのIDを渡す
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 200.0, // 幅を設定
                                                height: 175.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 8.0,
                                                ), // 横の余白を大きくする
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                      0xFFFFF2E8), // コンテナの色を変更
                                                  border: Border.all(
                                                    color: Colors.black, // 枠の色
                                                    width: 1.5, // 枠の幅
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // 丸みの半径
                                                  boxShadow: [
                                                    // 影を追加
                                                    BoxShadow(
                                                      color:
                                                          const Color.fromARGB(
                                                                  255,
                                                                  24,
                                                                  24,
                                                                  55)
                                                              .withOpacity(
                                                                  1), // 影の色を設定
                                                      spreadRadius:
                                                          0.1, // 影の広がりを設定
                                                      blurRadius: 1, // 影のぼかしを設定
                                                      offset: const Offset(
                                                          3, 3), // 影の位置を設定
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            left: 23,
                                                            bottom: 19),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                                height: 18.0),
                                                            Row(
                                                              children: <Widget>[
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <Widget>[
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5),
                                                                      child:
                                                                          Stack(
                                                                        children: <Widget>[
                                                                          Positioned(
                                                                            top:
                                                                                24,
                                                                            child:
                                                                                Container(
                                                                              width: textPainter.width,
                                                                              height: 6.0,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFFB99BF),
                                                                                borderRadius: BorderRadius.circular(3),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(bottom: 5), // 線の厚み分だけテキストを下にずらす
                                                                            child:
                                                                                Text(
                                                                              data['text1'],
                                                                              style: const TextStyle(
                                                                                fontFamily: 'NotoSansJP',
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 22,
                                                                                color: Colors.black,
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'NotoSansJP',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold, // 太字に設定
                                                                    fontSize:
                                                                        21,
                                                                    color: Colors
                                                                        .black, // テキストの色を指定
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 8.0),
                                                            Container(
                                                              height: 42.0,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xFFFFFFFF), // 背景色を設定
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .black, // 枠線の色を黒に設定
                                                                  width:
                                                                      2.0, // 枠線の太さを2.0に設定
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0), // 角の丸みを半径10に設定
                                                              ), // コンテナの高さを42に設定

                                                              child: Column(
                                                                // mainAxisAlignment:
                                                                //     MainAxisAlignment.end,
                                                                children: <Widget>[
                                                                  const SizedBox(
                                                                      height:
                                                                          4.0),
                                                                  Text(
                                                                    data[
                                                                        'text2'],
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          'NotoSansJP',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold, // 太字に設定
                                                                      fontSize:
                                                                          21, // テキストサイズを22に設定
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 11.0),
                                                            const Text(
                                                              'って言われたらなんて返す？',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'NotoSansJP',
                                                                fontWeight:
                                                                    FontWeight
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 14.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          const SizedBox(
                                                              height: 21),
                                                          Container(
                                                            width:
                                                                43.0, // 直径43ピクセル
                                                            height: 43.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image:
                                                                  DecorationImage(
                                                                image: NetworkImage(
                                                                    userIconUrl),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              ),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .black, // 線の色を設定
                                                                width:
                                                                    1.0, // 線の幅を設定
                                                              ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          24,
                                                                          24,
                                                                          55)
                                                                      .withOpacity(
                                                                          1),
                                                                  spreadRadius:
                                                                      0.3,
                                                                  blurRadius: 0,
                                                                  offset:
                                                                      const Offset(
                                                                          1.5,
                                                                          2.5),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          const Text(
                                                            '15分前',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  10.0, // フォントサイズを10に設定
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 53),
                                                          Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
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
                                    );
                                  },
                                )
                              : Container(),
                          _selectedIndex == 2
                              ? StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('questions')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          questionsSnapshot) {
                                    if (questionsSnapshot.hasError) {
                                      return const Text('エラーが発生しました');
                                    }
                                    if (questionsSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }

                                    // カレントユーザーのUIDを取得
                                    String currentUserId = FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        '';

                                    // questionsドキュメントのリストを取得
                                    List<DocumentSnapshot> questionDocs =
                                        questionsSnapshot.data!.docs;

                                    return ListView.builder(
                                      itemCount: questionDocs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DocumentSnapshot questionDoc =
                                            questionDocs[index];
                                        Map<String, dynamic> questionData =
                                            questionDoc.data()
                                                as Map<String, dynamic>;

                                        // repliesサブコレクションのStreamBuilder
                                        return StreamBuilder<QuerySnapshot>(
                                          stream: questionDoc.reference
                                              .collection('replies')
                                              .where('uid',
                                                  isEqualTo: currentUserId)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  repliesSnapshot) {
                                            if (repliesSnapshot.hasError) {
                                              return const Text('エラーが発生しました');
                                            }
                                            if (repliesSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            }

                                            // repliesドキュメントのリストを取得
                                            List<DocumentSnapshot> replyDocs =
                                                repliesSnapshot.data!.docs;

                                            return Column(
                                              //quesitonとrepliesの二つの情報を別で取ってくる必要がある。

                                              children: replyDocs.map(
                                                  (DocumentSnapshot replyDoc) {
                                                Map<String, dynamic> replyData =
                                                    replyDoc.data()
                                                        as Map<String, dynamic>;
                                                String replyIconUrl =
                                                    replyData['iconUrl'];
                                                String replyText =
                                                    replyData['text'];

                                                return Container(
                                                  height: 150, // 高さを指定
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 6, 0, 6),
                                                  child: RepliesCard(
                                                      questionData:
                                                          questionData,
                                                      replyData: replyData),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                )
                              : Container(),
                          _selectedIndex == 3 ? SizedBox() : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
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

class RepliesCard extends StatelessWidget {
  const RepliesCard({
    super.key,
    required this.questionData,
    required this.replyData,
  });

  final Map<String, dynamic> questionData;
  final Map<String, dynamic> replyData;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  AnswerForRepliesCard(replyData: replyData),
                ],
              ),
            ),
          ),
          QuestionBarForRepliesCard(questionData: questionData),
        ],
      ),
    );
  }
}

class AnswerForRepliesCard extends StatelessWidget {
  const AnswerForRepliesCard({
    super.key,
    required this.replyData,
  });

  final Map<String, dynamic> replyData;

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
                          image: NetworkImage(replyData['iconUrl']),
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
                          replyData['text'],
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
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(
                    left: 6,
                    right: 6,
                    bottom: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuestionBarForRepliesCard extends StatelessWidget {
  const QuestionBarForRepliesCard({
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
        // FavoriteThumbup(
        //     widget: widget,
        //     document: document,
        //     likedByList: likedByList,
        //     currentUser: currentUser),
      ],
    );
  }
}

class FavoriteThumbup extends StatelessWidget {
  const FavoriteThumbup({
    super.key,
    required this.widget,
    required this.document,
    required this.likedByList,
    required this.currentUser,
  });

  final RepliesList widget;
  final DocumentSnapshot<Object?> document;
  final List likedByList;
  final User? currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser == null) {
              // ユーザーがログインしていない場合の処理
              return;
            }
            final uid = currentUser.uid;
            final documentReference = FirebaseFirestore.instance
                .collection('questions')
                .doc(widget.questionId)
                .collection('replies')
                .doc(document.id);

            FirebaseFirestore.instance.runTransaction((transaction) async {
              // usersコレクションのカレントユーザードキュメントを先に読み込む
              DocumentReference userDocRef =
                  FirebaseFirestore.instance.collection('users').doc(uid);
              DocumentSnapshot userSnapshot = await transaction.get(userDocRef);
              Map<String, dynamic> favoriteList =
                  (userSnapshot.data() as Map<String, dynamic>? ??
                          {})['favoriteList'] as Map<String, dynamic>? ??
                      {};

              // repliesコレクションのドキュメントを読み込む
              DocumentSnapshot snapshot =
                  await transaction.get(documentReference);
              if (!snapshot.exists) {
                throw Exception("Document does not exist!");
              }
              final data = snapshot.data() as Map<String, dynamic>?;
              if (data == null) {
                throw Exception("Document data is null!");
              }
              int likes = data.containsKey('likes') ? data['likes'] as int : 0;
              List<dynamic> likedBy = List.from(
                  data.containsKey('likedBy') ? data['likedBy'] as List : []);

              bool isLiked = likedBy.contains(uid);
              if (isLiked) {
                // すでにいいねしている場合は、いいねを取り消す
                likedBy.remove(uid);
                likes--;
                favoriteList.remove(document.id); // favoriteListから削除
              } else {
                // いいねしていない場合は、いいねを追加する
                likedBy.add(uid);
                likes++;
                favoriteList[document.id] =
                    widget.questionId; // questionIdは対応する質問のIDを表す文字列
              }

              // repliesコレクションのドキュメントを更新
              transaction.update(
                  documentReference, {'likedBy': likedBy, 'likes': likes});

              // usersコレクションのドキュメントを更新
              transaction.update(userDocRef, {'favoriteList': favoriteList});
            });
          },
          child: Container(
            margin: const EdgeInsets.only(
              left: 6,
              right: 6,
              bottom: 2,
            ),
            child: SvgPicture.asset(
              likedByList.contains(currentUser?.uid)
                  ? 'assets/icon_thumbup_black.svg'
                  : 'assets/icon_thumbup_white.svg',
              semanticsLabel: 'thumbup',
              width: 20,
              height: 20,
            ),
          ),
        ),
        Container(
          child: likedByList.length > 0
              ? Text(
                  '${likedByList.length}', // いいね数を表示
                  style: TextStyle(
                    fontSize: 14, // フォントサイズを適宜調整
                    color: Colors.black,
                  ),
                )
              : SizedBox(), // いいね数が0の場合は何も表示しない
        ),
      ],
    );
  }
}
