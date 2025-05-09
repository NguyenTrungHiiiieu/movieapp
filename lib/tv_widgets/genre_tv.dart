import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movieappnew/model/tv/tv_model.dart';
import 'package:movieappnew/screens/tv_details_screen.dart';
import 'package:toastification/toastification.dart';
import '../constant/style.dart';
import '../http/http_request.dart';

class GenreTVs extends StatefulWidget {
  const GenreTVs({super.key, required this.genreId});
  final int genreId;

  @override
  State<GenreTVs> createState() => _GenreTVsState();
}

class _GenreTVsState extends State<GenreTVs> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVModel>(
        future: HttpRequest.getDiscoverTVShows(widget.genreId),
        builder: (context, AsyncSnapshot<TVModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildTVsByGenreWidget(snapshot.data!);
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error);
          } else {
            return _buildLoadingWidget();
          }
        });
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 25.0,
            height: 25.0,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 4.0,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildErrorWidget(dynamic error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Something is wrong: $error",
              style: const TextStyle(fontSize: 20, color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildTVsByGenreWidget(TVModel data) {
    List<TVShows>? tvShows = data.tvShows;
    if (tvShows!.isEmpty) {
      return const SizedBox(
          child: Text("No TVs Found",
              style: TextStyle(fontSize: 20, color: Style.textColor)));
    } else {
      return Container(
        height: 270,
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tvShows.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: GestureDetector(
                onTap: () {
                  if (tvShows[index].poster == null ||
                      tvShows[index].backDrop == null ||
                      tvShows[index].rating == null ||
                      tvShows[index].overview == null ||
                      tvShows[index].name == null) {
                    toastification.show(
                      context: context,
                      title: const Text('This TV Show Has No Data!'),
                      autoCloseDuration: const Duration(seconds: 5),
                    );
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            TVsDetailsScreen(tvShows: tvShows[index])));
                  }
                },
                child: Column(
                  children: [
                    tvShows[index].poster == null
                        ? Container(
                            width: 120,
                            height: 180,
                            decoration: const BoxDecoration(
                                color: Style.secondColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2)),
                                shape: BoxShape.rectangle),
                            child: const Center(
                              child: Icon(Icons.videocam_off_outlined,
                                  color: Colors.white, size: 50),
                            ),
                          )
                        : Hero(
                            tag: "${tvShows[index].id}",
                            child: Container(
                              width: 120,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: Style.secondColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(2)),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://image.tmdb.org/t/p/w200/${tvShows[index].poster!}"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 100,
                      child: Text(
                        tvShows[index].name!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            height: 1.4,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10),
                      ),
                    ),
                    const SizedBox(height: 5),
                    //display rating
                    Row(
                      children: [
                        Text(tvShows[index].rating.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(width: 5),
                        RatingBar.builder(
                            itemSize: 8,
                            initialRating: tvShows[index].rating! / 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2),
                            itemBuilder: (context, _) {
                              return const Icon(Icons.star,
                                  color: Style.secondColor);
                            },
                            onRatingUpdate: (rating) {})
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
