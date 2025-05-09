import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieappnew/constant/style.dart';
import 'package:movieappnew/model/hive_movie_model.dart';
import 'package:movieappnew/movie_widgets/movie_info.dart';
import 'package:movieappnew/movie_widgets/similar_movie_widget.dart';
import 'package:movieappnew/screens/reviews.dart';
import 'package:movieappnew/screens/trailers_screen.dart';

import '../model/movie/movie_model.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key, required this.movie, this.request});
  final Movie movie;
  final String? request;

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Box<HiveMovieModel> _movieWatchLists;

  @override
  void initState() {
    _movieWatchLists = Hive.box<HiveMovieModel>('movie_lists');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.movie.title!, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                _buildBackDrop(),
                Positioned(
                  top: 150,
                  left: 30,
                  child: Hero(
                      tag: widget.request == null
                          ? "${widget.movie.id}"
                          : "${widget.movie.id}${widget.request!}",
                      child: _buildPoster()),
                )
              ],
            ),
            MovieInfo(id: widget.movie.id!),
            SimilarMovies(id: widget.movie.id!),
            Reviews(id: widget.movie.id!, request: "movie")
          ],
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.redAccent,
                child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => TrailersScreen(
                              shows: "movie", id: widget.movie.id!)));
                    },
                    icon: const Icon(Icons.play_circle_fill_rounded,
                        size: 30, color: Colors.white),
                    label: const Text(
                      "Watch Trailers",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ),
            ),
            Expanded(
              child: Container(
                color: Style.secondColor,
                child: TextButton.icon(
                    onPressed: () {
                      HiveMovieModel newValue = HiveMovieModel(
                          id: widget.movie.id!,
                          rating: widget.movie.rating!,
                          title: widget.movie.title!,
                          backDrop: widget.movie.backDrop!,
                          poster: widget.movie.poster!,
                          overview: widget.movie.overview!);
                      _movieWatchLists.add(newValue);
                      _showAlertDialog();
                    },
                    icon: const Icon(Icons.list_alt_rounded,
                        size: 30, color: Colors.white),
                    label: const Text(
                      "Add To Lists",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildPoster() {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: NetworkImage(
                  "https://image.tmdb.org/t/p/w200/${widget.movie.poster!}"),
              fit: BoxFit.cover)),
    );
  }

  Widget _buildBackDrop() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: NetworkImage(
                  "https://image.tmdb.org/t/p/original/${widget.movie.backDrop!}"),
              fit: BoxFit.cover)),
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Added to List"),
          content:
              Text("${widget.movie.title!} successfully added to watch list"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
}
