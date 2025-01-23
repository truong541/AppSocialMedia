import 'package:firebase_auth/firebase_auth.dart';

class UserCurrent {
  final User? user = FirebaseAuth.instance.currentUser;

  String get uid => user?.uid ?? 'Tên người dùng';
  String get displayName => user?.displayName ?? 'Tên người dùng';
  String get email => user?.email ?? 'Tên người dùng';
  String get imageUrl => user?.photoURL ?? '';
}
