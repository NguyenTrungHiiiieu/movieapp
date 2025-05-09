import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ Thêm dòng này
import 'package:movieappnew/constant/style.dart';
import 'package:movieappnew/screens/movie_screen.dart';
import 'package:movieappnew/screens/tv_screen.dart';
import 'package:movieappnew/screens/watch_lists_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    void onTapIcon(int index) {
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      );
    }

    return Scaffold(
      appBar: _currentIndex != 2
          ? AppBar(
              title: _buildTitle(_currentIndex),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Đăng xuất",
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            )
          : null,
      body: PageView(
        controller: controller,
        children: const <Widget>[
          MovieScreen(),
          TVsScreen(),
          WatchListsScreen(),
        ],
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Style.primaryColor,
        selectedItemColor: Style.secondColor,
        unselectedItemColor: Style.textColor,
        currentIndex: _currentIndex,
        onTap: onTapIcon,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.movie_creation_outlined), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "TVs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: "Watch Lists"),
        ],
      ),
    );
  }

  _buildTitle(int index) {
    switch (index) {
      case 0:
        return const Text('Movie Shows');
      case 1:
        return const Text('TV Shows');
      case 2:
        return null;
      default:
        return null;
    }
  }
}
