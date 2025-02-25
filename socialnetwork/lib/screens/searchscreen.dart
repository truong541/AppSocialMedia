import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socialnetwork/components/custom_icon.dart';
import 'package:socialnetwork/models/viewed_user.dart';
import 'package:socialnetwork/screens/profilescreen.dart';
import 'package:socialnetwork/services/viewed_user_service.dart';
import 'package:socialnetwork/widgets/mytext.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //Search
  final TextEditingController controller = TextEditingController();
  Timer? debounce;
  List<dynamic> users = [];
  bool isLoading = false;
  //ViewdUser
  late Future<List<ViewedUser>> listViewedUser;
  late ViewedUserWebSocket viewedUserWebSocket;

  @override
  void initState() {
    super.initState();
    listViewedUser = ViewedUserService().listViewedUser();
    // _connectWebSocket();
  }

  // Future<void> _connectWebSocket() async {
  //   viewedUserWebSocket = await ViewedUserWebSocket.connect();
  //   viewedUserWebSocket.viewedUserStream.listen((data) {
  //     setState(() {
  //       print(data);
  //       updateViewedUserList(data['users']);
  //     });
  //   });
  // }

  void updateViewedUserList(List<dynamic> users) {
    setState(() {
      listViewedUser = Future.delayed(Duration.zero, () {
        return users.map((user) => ViewedUser.fromJson(user)).toList();
      });
    });
  }

  void createViewedUser(int idUser) async {
    await ViewedUserService().createViewedUser(idUser);
  }

  void onSearchChanged(String query) async {
    setState(() {
      isLoading = true;
    });
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        searchUser(query);
      } else {
        setState(() {
          users = [];
          isLoading = false;
        });
      }
    });
  }

  Future<void> searchUser(String query) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:8000/account/search?query=$query'));
    if (response.statusCode == 200) {
      List fetchedUsers = json.decode(response.body);
      for (var user in fetchedUsers) {
        if (user["avatar"] != null && user["avatar"].isNotEmpty) {
          await precacheImage(NetworkImage(user["avatar"]), context);
        }
      }
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              CustomIcon(icon: 'search.png', color: 0xffaaaaaa, width: 20),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onChanged: onSearchChanged,
                  style: MyTextStyle.textMedium(context),
                  decoration: InputDecoration(
                    hintText: 'Search ...',
                    hintStyle: TextStyle(color: Color(0xffdddddd)),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  controller.clear();
                  setState(() {
                    users = [];
                  });
                },
                child: CustomIcon(
                    icon: 'x_close.png', color: 0xffdddddd, width: 15),
              )
            ],
          ),
        ),
      ),
      body: users.isEmpty
          ? FutureBuilder<List<ViewedUser>>(
              future: listViewedUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child:
                          CircularProgressIndicator()); // Hiển thị khi đang tải dữ liệu
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text("No viewed users found."));
                }

                List<ViewedUser> viewedUsers = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: viewedUsers.length,
                  itemBuilder: (context, index) {
                    var user = viewedUsers[index].user;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            user['avatar'] != null && user['avatar'].isNotEmpty
                                ? NetworkImage(
                                    'http://10.0.2.2:8000${user['avatar']}')
                                : AssetImage('assets/icon/img_blank.png')
                                    as ImageProvider,
                      ),
                      title: Text(MyTextStyle()
                          .toChangeVN(user['fullname'] ?? "Unknown")),
                      subtitle: Text('@${user['username'] ?? "Unknown"}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailProfileScreen(idUser: user['idUser'])),
                        );
                      },
                    );
                  },
                );
              },
            )
          : isLoading
              ? buildShimmerEffect()
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            user['avatar'] != null && user['avatar'].isNotEmpty
                                ? NetworkImage(
                                    'http://10.0.2.2:8000${user['avatar']}')
                                : AssetImage('assets/icon/img_blank.png')
                                    as ImageProvider,
                      ),
                      title: Text(MyTextStyle().toChangeVN(user['fullname'])),
                      subtitle: Text('@${user['username']}'),
                      onTap: () {
                        createViewedUser(user['idUser']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailProfileScreen(idUser: user['idUser'])),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Số lượng khung xám giả lập
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 10,
                        width: 150,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
