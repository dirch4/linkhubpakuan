import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:linkhubpakuan/firebase_options.dart';
import 'package:linkhubpakuan/pages/add_category.dart';
import 'package:linkhubpakuan/pages/dashboard.dart';
import 'package:linkhubpakuan/pages/home_page.dart';
import 'package:linkhubpakuan/pages/splash_screen.dart';
import 'package:linkhubpakuan/widgets/sidebar.dart';
import 'package:linkhubpakuan/widgets/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}