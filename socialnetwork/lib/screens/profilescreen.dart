import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/components/customrefresher.dart';
import 'package:socialnetwork/screens/editprofilescreen.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userInfo = {};
  @override
  void initState() {
    super.initState();
    _fetchAndPrintUserInfo();
    fetchPost();
  }

  Future<void> _fetchAndPrintUserInfo() async {
    try {
      final response = await GetToken().getUserCurrent();
      setState(() {
        userInfo = response;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  List<dynamic> listPost = [];
  bool _isLoading = true;

  Future<void> fetchPost() async {
    final res = await GetToken().getUserCurrent();

    try {
      final response = await http.get(Uri.parse(
          'http://10.0.2.2:8000/post/list-by-user/${res!['idUser'].toString()}'));
      if (response.statusCode == 200) {
        setState(() {
          listPost = json.decode(response.body);
          _isLoading = false;
          print('Bài post của bạn: $listPost');
        });
        print(listPost);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  Future<void> _fetchData() async {
    // logic để tải lại dữ liệu
    await Future.delayed(Duration(seconds: 2));
    fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    // final GetToken getToken = GetToken();
    return CustomRefresher(
      onRefresh: _fetchData,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Smoker', style: MyTextstyle.textLarge),
            actions: [
              ButtonIcon(
                onTapped: () {},
                imageIcon: 'add_post.png',
                widthIcon: 25,
                colorIcon: Colors.black,
              ),
              SizedBox(width: 25),
              ButtonIcon(
                onTapped: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
                imageIcon: 'option_account.png',
                widthIcon: 25,
                colorIcon: Colors.black,
              ),
              SizedBox(width: 25),
            ],
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [];
                  },
                  body: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Center(
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: ClipOval(
                                        child: Image.network(
                                          'https://oppw4-20-en.bn-ent.net/images/character/smoker/img_01.jpg',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(userInfo!['username'],
                                        style: MyTextstyle.textSmall),
                                    SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                MyTextstyle().formatNumber(
                                                    userInfo!['post']
                                                        .toString()),
                                                style: MyTextstyle.textMedium_,
                                              ),
                                              Text(
                                                'Post',
                                                style: MyTextstyle.textSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                MyTextstyle().formatNumber(
                                                    userInfo!['follower']
                                                        .toString()),
                                                style: MyTextstyle.textMedium_,
                                              ),
                                              Text(
                                                'Follower',
                                                style: MyTextstyle.textSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Text(
                                                MyTextstyle().formatNumber(
                                                    userInfo!['following']
                                                        .toString()),
                                                style: MyTextstyle.textMedium_,
                                              ),
                                              Text(
                                                'following',
                                                style: MyTextstyle.textSmall,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ButtonNormal(
                                            onTapped: () {},
                                            text: 'Edit profile',
                                            paddingVertical: 15,
                                            radius: 7,
                                            bgColor: Color(0xffeeeeee),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        ButtonTextIcon(
                                          onTapped: () {},
                                          icon: 'add-user.png',
                                          widthIcon: 20,
                                          padding: 15,
                                          radius: 7,
                                          bgColor: Color(0xffeeeeee),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      userInfo!['bio'] ??
                                          'Thêm tiểu sử của bạn',
                                      style: MyTextstyle.textSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Material(
                              child: TabBar(
                                indicatorColor: Colors.black,
                                indicatorWeight:
                                    3.0, // Điều chỉnh độ dày của thanh gạch
                                indicatorSize: TabBarIndicatorSize
                                    .tab, // Điều chỉnh chiều rộng của thanh gạch (theo tab)
                                indicatorPadding:
                                    EdgeInsets.symmetric(horizontal: 60),
                                tabs: [
                                  Tab(
                                      icon: Image.asset(
                                    'assets/icon/list_post.png',
                                    width: 25,
                                  )),
                                  Tab(
                                    icon: Image.asset(
                                      'assets/icon/list_video.png',
                                      width: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverFillRemaining(
                        child: TabBarView(
                          children: [
                            Center(
                              child: listPost.isNotEmpty
                                  ? GridView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3, // Mỗi hàng có 3 cột
                                        crossAxisSpacing:
                                            1.0, // Khoảng cách giữa các cột
                                        mainAxisSpacing:
                                            1.0, // Khoảng cách giữa các hàng
                                      ),
                                      itemCount: listPost.length,
                                      itemBuilder: (context, index) {
                                        final post = listPost[index]!['url'];
                                        return GestureDetector(
                                          onTap: () {},
                                          child: Image.network(
                                            'http://10.0.2.2:8000/${post?[0]['url']}',
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      },
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(height: 20),
                                        Text(
                                          'Chia sẻ những bức ảnh \n với tất cả mọi người',
                                          style: MyTextstyle.textLarge_,
                                        ),
                                        ButtonText(
                                          onTapped: () {},
                                          text: 'Tạo ảnh đầu tiên',
                                        )
                                      ],
                                    ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Text(
                                    'Chia sẻ khoảnh khắc \n với tất cả mọi người',
                                    style: MyTextstyle.textLarge_,
                                  ),
                                  ButtonText(
                                    onTapped: () {},
                                    text: 'Tạo thước phim đầu tiên',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
