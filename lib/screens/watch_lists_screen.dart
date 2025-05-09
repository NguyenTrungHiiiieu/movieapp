import 'package:flutter/material.dart';
import 'package:movieappnew/constant/style.dart';
import 'package:movieappnew/movie_widgets/movie_watch_lists.dart';
import 'package:movieappnew/tv_widgets/tv_watch_lists.dart';

class WatchListsScreen extends StatefulWidget {
  const WatchListsScreen({super.key});

  @override
  State<WatchListsScreen> createState() => _WatchListsScreenState();
}

class _WatchListsScreenState extends State<WatchListsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Watch Lists"),
          centerTitle: true,
          bottom: const TabBar(
            indicatorWeight: 2,
            indicatorColor: Style.secondColor,
            tabs: [
              Text("Movies", style: TextStyle(fontSize: 20)),
              Text("TV Shows", style: TextStyle(fontSize: 20))
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            //Movie
            MovieWatchLists(),
            //TV Shows
            TVWatchLists()
          ],
        ),
      ),
    );
  }
}
