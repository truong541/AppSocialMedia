import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/components/custom_future_builder.dart';
import 'package:socialnetwork/components/custom_icon.dart';
import 'package:socialnetwork/components/round_image.dart';
import 'package:socialnetwork/components/user_follow_item.dart';
import 'package:socialnetwork/components/widget_profile.dart';
import 'package:socialnetwork/models/info_user.dart';
import 'package:socialnetwork/models/user.dart';
import 'package:socialnetwork/screens/editprofilescreen.dart';
import 'package:socialnetwork/screens/loginscreen.dart';
import 'package:socialnetwork/screens/messagescreen.dart';
import 'package:socialnetwork/screens/postscreen.dart';
import 'package:socialnetwork/services/follow_service.dart';
import 'package:socialnetwork/services/logout_service.dart';
import 'package:socialnetwork/services/post_service.dart';
import 'package:socialnetwork/services/user_service.dart';
import 'package:socialnetwork/utils/gettoken.dart';
import 'package:socialnetwork/widgets/mytext.dart';

class UserProfile extends StatefulWidget {
  final int idUser;
  const UserProfile({super.key, required this.idUser});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isShowListUser = true;
  bool isLoadingUnfollowedUser = true;
  InfoUserModel? user;
  List<UserModel>? users;
  int? idUser;

  @override
  void initState() {
    super.initState();
    getIdUserFromToken();
    loadUser();
    listUnfollowedUsers();
  }

  //Lấy id user hiện tại
  void getIdUserFromToken() async {
    idUser = await GetToken().getUserIdFromToken();
  }

  //Lấy thông tin user dựa trên id
  void loadUser() async {
    user = await UserService().infoUser(widget.idUser);
  }

  void listUnfollowedUsers() async {
    users = await FollowService().listUnfollowUser(widget.idUser);
    setState(() {
      isLoadingUnfollowedUser = false;
    });
  }

  void navigatorPostScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostScreen()),
    );
  }

  void logout() async {
    await LogoutService().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(MyTextStyle().toChangeVN((user?.fullname ?? "")),
              style: MyTextStyle.textLarge(context)),
          actions: [
            if (idUser == widget.idUser)
              GestureDetector(
                onTap: navigatorPostScreen,
                child: CustomIcon(
                  icon: 'add_post.png',
                  width: 25,
                  isDefaultColor: true,
                ),
              ),
            SizedBox(width: 25),
            GestureDetector(
              onTap: () async {
                logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: CustomIcon(
                icon: 'option_account.png',
                width: 25,
                isDefaultColor: true,
              ),
            ),
            SizedBox(width: 25),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          RoundImage(image: user?.avatar, size: 100),
                          SizedBox(height: 10),
                          Text('@${user?.username ?? ''}',
                              style: MyTextStyle.textSmall(context)),
                          SizedBox(height: 15),
                          ListProfileCount(user: user),
                          SizedBox(height: 5),
                          Text(
                            user?.bio ?? "",
                            style: MyTextStyle.textSmall(context),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonNormal(
                                  onTapped: () {
                                    if (idUser == widget.idUser) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen()),
                                      );
                                    }
                                  },
                                  text: idUser == widget.idUser
                                      ? 'Edit profile'
                                      : 'Follow',
                                  paddingVertical: 15,
                                  radius: 7,
                                  bgColor: Color(0xffeeeeee),
                                ),
                              ),
                              SizedBox(width: 5),
                              if (idUser != widget.idUser)
                                Expanded(
                                  child: ButtonNormal(
                                    onTapped: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MessageScreen(
                                                idUser: widget.idUser)),
                                      );
                                    },
                                    text: 'Chat',
                                    paddingVertical: 15,
                                    radius: 7,
                                    bgColor: Color(0xffeeeeee),
                                  ),
                                ),
                              SizedBox(width: 5),
                              ButtonTextIcon(
                                onTapped: () {
                                  setState(() {
                                    isShowListUser = !isShowListUser;
                                  });
                                },
                                icon: 'add-user.png',
                                widthIcon: 20,
                                padding: 15,
                                radius: 7,
                                bgColor: Color(0xffeeeeee),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //Danh sách user cần follow
                  SizedBox(height: 15),
                  if (isShowListUser)
                    isLoadingUnfollowedUser
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 200,
                            child: CustomFutureBuilder(
                              isScrollHorizontal: true,
                              future: FollowService()
                                  .listUnfollowUser(widget.idUser),
                              itemBuilder: (list) =>
                                  UserFollowItem(users: list),
                            ),
                          ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicatorColor: Theme.of(context).colorScheme.onSecondary,
                  indicatorWeight: 3.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 60),
                  tabs: [
                    Tab(
                      icon: CustomIcon(
                        icon: 'list_post.png',
                        width: 25,
                        isDefaultColor: true,
                      ),
                    ),
                    Tab(
                      icon: CustomIcon(
                        icon: 'list_video.png',
                        width: 25,
                        isDefaultColor: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              Center(
                child: CustomFutureBuilder(
                  isGridView: true,
                  isWidgetNotList: true,
                  future: PostService().showListPostByUser(widget.idUser),
                  itemBuilder: (list) => GestureDetector(
                    onTap: () {},
                    child: Image.network(
                      list['url'][0]['url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  childNotList: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Chia sẻ những bức ảnh \n với tất cả mọi người',
                        style: MyTextStyle.textLarge_(context),
                      ),
                      ButtonText(
                        onTapped: navigatorPostScreen,
                        text: 'Tạo bài viết đầu tiên',
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Chia sẻ khoảnh khắc \n với tất cả mọi người',
                      style: MyTextStyle.textLarge_(context),
                    ),
                    ButtonText(
                      onTapped: () {},
                      text: 'Tạo thước phim đầu tiên',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.onSecondary,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
