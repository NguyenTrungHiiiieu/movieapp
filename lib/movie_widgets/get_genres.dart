import 'package:flutter/material.dart';
import 'package:movieappnew/http/http_request.dart';
import 'package:movieappnew/model/genres_model.dart';
import 'package:movieappnew/movie_widgets/genres_list.dart';

import '../constant/style.dart';

class GetGenres extends StatefulWidget {
  const GetGenres({super.key});

  @override
  State<GetGenres> createState() => _GetGenresState();
}

class _GetGenresState extends State<GetGenres> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GenreModel>(
        future: HttpRequest.getGenres("movie"),
        builder: (context, AsyncSnapshot<GenreModel> snapshot){
          if(snapshot.hasData){
            if(snapshot.data!.error != null && snapshot.data!.error!.isNotEmpty){
              return _buildErrorWidget(snapshot.data!.error);
            }
            return _buildGetGenresWidget(snapshot.data!);
          } else if(snapshot.hasError){
            return _buildErrorWidget(snapshot.error);
          } else{
            return _buildLoadingWidget();
          }
        }
    );
  }

  Widget _buildLoadingWidget(){
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

  Widget _buildErrorWidget(dynamic error){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Something is wrong: $error", style: const TextStyle(fontSize: 20, color: Colors.white))
        ],
      ),
    );
  }

  Widget _buildGetGenresWidget(GenreModel data){
    List<Genre>?  genres = data.genres;
    if(genres!.isEmpty){
      return const SizedBox(
        child: Text("No Genres", style: TextStyle(fontSize: 20, color: Style.textColor))
      );
    } else{
      return GenresList(genres: genres);
    }
  }
}
