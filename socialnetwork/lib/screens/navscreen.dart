import 'package:flutter/material.dart';
import 'package:socialnetwork/screens/searchscreen.dart';
import 'package:socialnetwork/screens/chatscreen.dart';
import 'package:socialnetwork/screens/homescreen.dart';
import 'package:socialnetwork/screens/postscreen.dart';
import 'package:socialnetwork/screens/profilescreen.dart';

class NavBottomScreen extends StatefulWidget {
  const NavBottomScreen({super.key});

  @override
  State<NavBottomScreen> createState() => _NavBottomScreenState();
}

class _NavBottomScreenState extends State<NavBottomScreen> {
  int _currentIndex = 0;
  double widthIcon = 20;

  final _pages = [
    Center(child: HomeScreen()),
    Center(child: SearchScreen()),
    Center(child: Container()),
    Center(child: ChatScreen()),
    Center(child: ProfileScreen()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostScreen()),
        );
      } else {
        _currentIndex = index;
      }
    });
  }

  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': 'assets/icon/home.png',
      'label': 'Home',
    },
    {
      'icon': 'assets/icon/search.png',
      'label': 'Search',
    },
    {
      'icon': 'assets/icon/post.png',
      'label': 'Post',
    },
    {
      'icon': 'assets/icon/chat.png',
      'label': 'Chat',
    },
    {
      'icon': 'assets/icon/user.png',
      'label': 'Account',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onSurface, // Màu phủ lên
                BlendMode.srcATop, // Chế độ hòa trộn
              ),
              child: Image.asset(
                item['icon'],
                width: widthIcon,
                height: widthIcon,
              ),
            ),
            activeIcon: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: [Colors.red, Colors.orange], // Tô màu tùy chỉnh
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Image.asset(
                item['icon'],
                width: widthIcon,
                height: widthIcon,
              ),
            ),
            label: item['label'],
          );
        }).toList(),
        currentIndex: _currentIndex,
        fixedColor: Colors.orange,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
