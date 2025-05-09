import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movieappnew/model/movie/movie_details_model.dart';
import 'package:movieappnew/model/movie/movie_model.dart';
import 'package:movieappnew/model/reviews_model.dart';
import 'package:movieappnew/model/trailers_model.dart';
import 'package:movieappnew/model/tv/tv_details_model.dart';
import 'package:movieappnew/model/tv/tv_model.dart';

import '../model/genres_model.dart';

class HttpRequest {
  static final String? apiKey = dotenv.env['API_KEY'];
  static const String mainUrl = "https://api.themoviedb.org/3";
  static final Dio dio = Dio();
  static var getGenreUrl = "$mainUrl/genre";
  static var getDiscoverUrl = "$mainUrl/discover";
  static var getMoviesUrl = "$mainUrl/movie";
  static var getTVUrl = "$mainUrl/tv";

  //get genres
  static Future<GenreModel> getGenres(String shows) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      Response response =
          await dio.get("$getGenreUrl/$shows/list", queryParameters: params);
      return GenreModel.fromJson(response.data);
    } catch (err) {
      return GenreModel.withError("$err");
    }
  }

  //get reviews
  static Future<ReviewsModel> getReviews(String shows, int id) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      Response response =
          await dio.get("$mainUrl/$shows/$id/reviews", queryParameters: params);
      return ReviewsModel.fromJson(response.data);
    } catch (err) {
      return ReviewsModel.withError("$err");
    }
  }

  //get trailers
  static Future<TrailersModel> getTrailers(String shows, int id) async {
    var params = {"api_key": apiKey, "language": "en-us"};
    try {
      Response response =
          await dio.get("$mainUrl/$shows/$id/videos", queryParameters: params);
      return TrailersModel.fromJson(response.data);
    } catch (err) {
      return TrailersModel.withError("$err");
    }
  }

  //get similar movies
  static Future<MovieModel> getSimilarMovies(int id) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      Response response =
          await dio.get("$getMoviesUrl/$id/similar", queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (err) {
      return MovieModel.withError("$err");
    }
  }

  //get similar tv shows
  static Future<TVModel> getSimilarTVShows(int id) async {
    var params = {"api_key": apiKey, "language": "en-us", "page": 1};
    try {
      Response response =
          await dio.get("$getTVUrl/$id/similar", queryParameters: params);
      return TVModel.fromJson(response.data);
    } catch (err) {
      return TVModel.withError("$err");
    }
  }

  //get discover movies
  static Future<MovieModel> getDiscoverMovies(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
      "with_genres": id
    };
    try {
      Response response =
          await dio.get("$getDiscoverUrl/movie", queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (err) {
      return MovieModel.withError("$err");
    }
  }

  //get discover tv shows
  static Future<TVModel> getDiscoverTVShows(int id) async {
    var params = {
      "api_key": apiKey,
      "language": "en-us",
      "page": 1,
      "with_genres": id
    };
    try {
      Response response =
          await dio.get("$getDiscoverUrl/tv", queryParameters: params);
      return TVModel.fromJson(response.data);
    } catch (err) {
      return TVModel.withError("$err");
    }
  }

  //get movie details
  static Future<MovieDetailsModel> getMovieDetails(int id) async {
    var params = {"api_key": apiKey, "language": "en-us"};
    try {
      Response response =
          await dio.get("$getMoviesUrl/$id", queryParameters: params);
      return MovieDetailsModel.fromJson(response.data);
    } catch (err) {
      return MovieDetailsModel.withError("$err");
    }
  }

  //get tv show details
  static Future<TVDetailsModel> getTVShowDetails(int id) async {
    var params = {"api_key": apiKey, "language": "en-us"};
    try {
      Response response =
          await dio.get("$getTVUrl/$id", queryParameters: params);
      return TVDetailsModel.fromJson(response.data);
    } catch (err) {
      return TVDetailsModel.withError("$err");
    }
  }

  //get movies now_playing / popular / top_rated / upcoming
  static Future<MovieModel> getMovies(String request) async {
    var params = {"api_key": apiKey, "language": "en-us"};
    try {
      Response response =
          await dio.get("$getMoviesUrl/$request", queryParameters: params);
      return MovieModel.fromJson(response.data);
    } catch (err) {
      return MovieModel.withError("$err");
    }
  }

  //get tv shows airing_today / on_the_air / top_rated / popular
  static Future<TVModel> getTVShows(String request) async {
    var params = {"api_key": apiKey, "language": "en-us"};
    try {
      Response response =
          await dio.get("$getTVUrl/$request", queryParameters: params);
      return TVModel.fromJson(response.data);
    } catch (err) {
      return TVModel.withError("$err");
    }
  }
}
