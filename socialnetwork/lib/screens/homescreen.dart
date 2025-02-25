import 'package:flutter/material.dart';
import 'package:socialnetwork/components/custom_future_builder.dart';
import 'package:socialnetwork/components/post_item.dart';
import 'package:socialnetwork/components/shimmer.dart';
import 'package:socialnetwork/screens/searchscreen.dart';
import 'package:socialnetwork/services/post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Network',
          style: TextStyle(fontSize: 22),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            child: Icon(Icons.comment_bank),
          ),
        ],
      ),
      body: CustomFutureBuilder(
        isShimmer: true,
        childShimmer: CustomShimmer().shimmerListPost(),
        future: PostService().showListPost(),
        itemBuilder: (list) => PostItem(post: list),
      ),
    );
  }
}
