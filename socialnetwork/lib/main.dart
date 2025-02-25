import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialnetwork/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:socialnetwork/theme/theme_provider.dart';
import 'package:socialnetwork/theme/app_colors.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(const MyApp());
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppColors.lightTheme,
        darkTheme: AppColors.darkTheme,
        themeMode: themeProvider.themeMode,
        navigatorObservers: [routeObserver],
        home: SplashScreen());
  }
}

// class AuthCheck extends StatelessWidget {
//   const AuthCheck({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasData) {
//           // Người dùng đã đăng nhập
//           return NavBottomScreen();
//         } else {
//           // Người dùng chưa đăng nhập
//           return LoginScreen();
//         }
//       },
//     );
//   }
// }
