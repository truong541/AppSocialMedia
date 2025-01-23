import 'package:flutter/material.dart';
import 'package:socialnetwork/components/button.dart';
import 'package:socialnetwork/screens/editprofilescreen.dart';
import 'package:socialnetwork/widgets/widget_container.dart';
import 'package:socialnetwork/widgets/widget_textstyle.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, dynamic>> listInfo = [
    {
      'number': '0',
      'label': 'Post',
    },
    {
      'number': '12450000',
      'label': 'Follower',
    },
    {
      'number': '360000',
      'label': 'Following',
    },
  ];

  final List<Map<String, dynamic>> listUser = [
    {
      'image':
          'https://www.mpweekly.com/entertainment/wp-content/uploads/2019/07/35374668-2a49-433c-b286-638c8f912c2c.jpg',
      'name': 'Kang Gary',
    },
    {
      'image':
          'https://images2.thanhnien.vn/zoom/622_389/528068263637045248/2023/5/11/song-ji-hyo-16838462457711527751421-0-0-504-806-crop-1683846457343337889336.jpg',
      'name': 'Song Ji Hyo',
    },
    {
      'image':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTj19MgsSuhwI3q9yyC-gb1_JCS9IpJSCBI1A&s',
      'name': 'Kim Jong Kook',
    },
  ];

  final List<String> imageUrls = [
    'https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/article/2021/12/1267779e-6072-4223-818a-6f4e57282efa.jpg',
    'https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg',
    'https://gudivivu.com/wp-content/uploads/2023/04/du-lich-new-york.jpg',
    'https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/article/2021/12/1267779e-6072-4223-818a-6f4e57282efa.jpg',
    'https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg',
    'https://gudivivu.com/wp-content/uploads/2023/04/du-lich-new-york.jpg',
    'https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/article/2021/12/1267779e-6072-4223-818a-6f4e57282efa.jpg',
    'https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg',
    'https://gudivivu.com/wp-content/uploads/2023/04/du-lich-new-york.jpg',
    'https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/article/2021/12/1267779e-6072-4223-818a-6f4e57282efa.jpg',
    'https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg',
    'https://gudivivu.com/wp-content/uploads/2023/04/du-lich-new-york.jpg',
    'https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/article/2021/12/1267779e-6072-4223-818a-6f4e57282efa.jpg',
    'https://cdn.britannica.com/61/93061-050-99147DCE/Statue-of-Liberty-Island-New-York-Bay.jpg',
    'https://gudivivu.com/wp-content/uploads/2023/04/du-lich-new-york.jpg',
  ];

  String formatNumber(String input) {
    // Chuyển chuỗi thành số
    int number = int.tryParse(input) ?? 0;

    if (number >= 1000000000) {
      // Hàng tỷ (B)
      double billions = number / 1000000000;
      return "${billions.toStringAsFixed(billions.truncateToDouble() == billions ? 0 : 1)} B";
    } else if (number >= 1000000) {
      // Hàng triệu (M)
      double millions = number / 1000000;
      return "${millions.toStringAsFixed(millions.truncateToDouble() == millions ? 0 : 1)} M";
    } else {
      // Giữ nguyên
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                );
              },
              imageIcon: 'option_account.png',
              widthIcon: 25,
              colorIcon: Colors.black,
            ),
            SizedBox(width: 25),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // SliverAppBar ở đây không dùng đến
            ];
          },
          body: CustomScrollView(
            slivers: [
              SliverList(
                // Sử dụng SliverList để hiển thị Column
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      'https://oppw4-20-en.bn-ent.net/images/character/smoker/img_01.jpg', // Đổi đường dẫn ảnh ở đây
                                      width: 80, // Chiều rộng hình ảnh
                                      height: 80, // Chiều cao hình ảnh
                                      fit: BoxFit
                                          .cover, // Cách ảnh fit trong khung
                                    ),
                                  ),
                                  Text('Smoker', style: MyTextstyle.textMedium),
                                ],
                              ),
                              Row(
                                children: listInfo.map((item) {
                                  return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            formatNumber(item['number']),
                                            style: MyTextstyle.textLarge_,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            item['label'],
                                            style: MyTextstyle.textSmall,
                                          ),
                                        ],
                                      ));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        //Các Button
                        Row(
                          children: [],
                        ),
                        //Theo dõi các User khác
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Theo dõi thêm',
                                    style: MyTextstyle.textSmall,
                                  ),
                                  ButtonText(
                                    onTapped: () {},
                                    text: 'Xem tất cả',
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: listUser.map((item) {
                                    return InkWell(
                                      onTap: () {
                                        print("");
                                      },
                                      child: Container(
                                        width: 150,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          color: Color(0xffeeeeee),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                item['image'],
                                                width: 100,
                                                height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              item['name'],
                                              style: MyTextstyle.textSmall_,
                                            ),
                                            SizedBox(height: 5),
                                            InkWell(
                                              onTap: () {
                                                setState(() {});
                                              },
                                              child: Container(
                                                width: MyContainer.defaultWidth(
                                                    context),
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(6),
                                                decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Follow',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Item Tab
                        Material(
                          child: TabBar(
                            indicatorColor: Colors.black,
                            indicatorWeight:
                                5.0, // Điều chỉnh độ dày của thanh gạch
                            indicatorSize: TabBarIndicatorSize
                                .tab, // Điều chỉnh chiều rộng của thanh gạch (theo tab)
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 50),
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
                  ],
                ),
              ),
              //Nội dung các item
              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    Center(
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Mỗi hàng có 3 cột
                          crossAxisSpacing: 1.0, // Khoảng cách giữa các cột
                          mainAxisSpacing: 1.0, // Khoảng cách giữa các hàng
                        ),
                        itemCount: imageUrls.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
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
    );
  }
}
