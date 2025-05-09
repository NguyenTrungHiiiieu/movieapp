import 'package:flutter/material.dart';
import 'package:movieappnew/model/trailers_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../http/http_request.dart';

class TrailersScreen extends StatefulWidget {
  const TrailersScreen({super.key, required this.shows, required this.id});
  final String shows;
  final int id;

  @override
  State<TrailersScreen> createState() => _TrailersScreenState();
}

class _TrailersScreenState extends State<TrailersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TrailersModel>(
          future: HttpRequest.getTrailers(widget.shows, widget.id),
          builder: (context, AsyncSnapshot<TrailersModel> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error!.isNotEmpty) {
                return _buildErrorWidget(snapshot.data!.error);
              }
              return _buildTrailersWidget(snapshot.data!);
            } else if (snapshot.hasError) {
              return _buildErrorWidget(snapshot.error);
            } else {
              return _buildLoadingWidget();
            }
          }),
    );
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

  Widget _buildTrailersWidget(TrailersModel data) {
    List<Video>? videos = data.trailers;

    if (videos == null || videos.isEmpty || videos[0].key == null) {
      return const Center(
        child:
            Text('No trailer available', style: TextStyle(color: Colors.white)),
      );
    }

    return Stack(
      children: [
        Center(
          child: YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: videos[0].key!,
              flags: const YoutubePlayerFlags(
                hideControls: true,
                autoPlay: true,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close_sharp),
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
