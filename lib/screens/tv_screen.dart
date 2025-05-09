import 'package:flutter/material.dart';
import 'package:movieappnew/movie_widgets/get_genres.dart';
import 'package:movieappnew/tv_widgets/airing_today_widget.dart';
import 'package:movieappnew/tv_widgets/tv_widget.dart';

class TVsScreen extends StatefulWidget {
  const TVsScreen({super.key});

  @override
  State<TVsScreen> createState() => _TVsScreenState();
}

class _TVsScreenState extends State<TVsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        AiringToday(),
        GetGenres(),
        TVsWidget(text: "UPCOMING", request: "on_the_air"),
        TVsWidget(text: "POPULAR", request: "popular"),
        TVsWidget(text: "TOP RATED", request: "top_rated")
      ],
    );
  }
}
