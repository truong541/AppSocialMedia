import 'package:flutter/material.dart';
import 'package:socialnetwork/components/user_profile.dart';
import 'package:socialnetwork/utils/gettoken.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<int> idUser;

  @override
  void initState() {
    super.initState();
    idUser = getIdUserFromToken();
  }

  Future<int> getIdUserFromToken() async {
    final res = await GetToken().getUserCurrent();
    return res!['idUser'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: idUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Hoặc màn hình chờ
        } else if (snapshot.hasError) {
          return Text("Lỗi: ${snapshot.error}");
        } else {
          return UserProfile(idUser: snapshot.data!);
        }
      },
    );
  }
}

class DetailProfileScreen extends StatefulWidget {
  final int idUser;
  const DetailProfileScreen({super.key, required this.idUser});

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return UserProfile(idUser: widget.idUser);
  }
}
