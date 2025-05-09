import 'package:flutter/material.dart';
import 'package:movieappnew/constant/style.dart';
import 'package:movieappnew/http/http_request.dart';
import 'package:movieappnew/model/tv/tv_model.dart';
import 'package:page_indicator/page_indicator.dart';

class AiringToday extends StatefulWidget {
  const AiringToday({super.key});

  @override
  State<AiringToday> createState() => _AiringTodayState();
}

class _AiringTodayState extends State<AiringToday> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TVModel>(
        future: HttpRequest.getTVShows("airing_today"),
        builder: (context, AsyncSnapshot<TVModel> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.error != null &&
                snapshot.data!.error!.isNotEmpty) {
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildAiringTodayWidget(snapshot.data!);
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

  Widget _buildAiringTodayWidget(TVModel data) {
    List<TVShows>? tvShows = data.tvShows;
    if (tvShows!.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 220,
        child: const Center(
            child: Text("No TV Shows Found",
                style: TextStyle(fontSize: 20, color: Style.textColor))),
      );
    } else {
      return SizedBox(
        height: 220,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          indicatorSpace: 8,
          padding: const EdgeInsets.all(5),
          indicatorColor: Style.textColor,
          indicatorSelectorColor: Style.secondColor,
          length: tvShows.take(5).length, //take only 5 movies in list
          shape: IndicatorShape.circle(size: 10.0),
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tvShows.take(5).length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  "https://image.tmdb.org/t/p/original${tvShows[index].backDrop!}"),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Style.primaryColor.withOpacity(1),
                                Style.primaryColor.withOpacity(0),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: const [0.0, 0.9])),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tvShows[index].name!,
                              style: const TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
        ),
      );
    }
  }
}
