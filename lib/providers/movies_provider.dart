import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/search_response.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '13bc9218050590585ca8a4e292231b9b';
  final String _baseURL = 'api.themoviedb.org';
  final String _languaje = 'es-ES';
  final String _englisLanguaje = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  List<Movie> upComingMovies = [];
  List<Movie> topRatedMovies = [];
  int _popularPage = 0;
  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );
  Map<int, List<Cast>> moviesCast = {};
  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    //print('Movies provider inicializado');

    getOnDisplayMovies();
    getPopularMovies();
    //  this.getUpComingMovies();
    // this.getTopRatedMovies();
  }

  getTopRatedMovies() async {
    final jsonData = await getJsonData('3/movie/top_rated');

    final topRatedResponse = TopRatedResponse.fromJson(jsonData);

    topRatedMovies = [...topRatedMovies, ...topRatedResponse.results];

    notifyListeners();
  }

  getUpComingMovies() async {
    final jsonData = await getJsonData('3/movie/upcoming');

    final upComingResponse = UpComingResponse.fromJson(jsonData);

    upComingMovies = [...upComingMovies, ...upComingResponse.results];

    notifyListeners();
  }

  getOnDisplayMovies() async {
    final jsonData = await getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    // for (int i = 0; i < 10; i++) print(nowPlayingResponse.results[i].title);

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);
    //popularResponse.results[1].
    // for (int i = 0; i < 10; i++) print(nowPlayingResponse.results[i].title);

    popularMovies = [...popularMovies, ...popularResponse.results];

    //final popularResponse = PopularResponse.fromJson(getURL('popular').body);

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    // print('pidiendo infio al servidor - cast');

    final jsonData = await getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<String> getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseURL, endPoint, {
      'api_key': _apiKey,
      'language': _languaje,
      'page': '$page',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    //print(url);
    return response.body;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseURL, '3/search/movie', {
      'api_key': _apiKey,
      'language': _languaje,
      'query': query,
    });

    final response = await http.get(url);
    //print(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // print('Tenemos valor a buscar: $value');
      final results = await searchMovie(value);
      _suggestionStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
