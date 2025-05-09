import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'constant/style.dart';
import 'model/hive_movie_model.dart';
import 'model/hive_tv_model.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart'; // thêm file này

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieModelAdapter());
  Hive.registerAdapter(HiveTVModelAdapter());
  await Hive.openBox<HiveMovieModel>('movie_lists');
  await Hive.openBox<HiveTVModel>('tv_lists');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        scaffoldBackgroundColor: Style.primaryColor,
        appBarTheme: const AppBarTheme(backgroundColor: Style.primaryColor),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
