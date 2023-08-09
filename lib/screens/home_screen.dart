import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HommeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    //print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Peliculas en cines'),
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.search_off_outlined),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSerchDelegate())),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            //Targetas principales
            CardSwiper(movies: moviesProvider.onDisplayMovies),

            const SizedBox(height: 10),

            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),

            const SizedBox(height: 10),

            /* MovieSlider(
              movies: moviesProvider.upComingMovies,
              title: 'Up Coming',
            ),

            SizedBox(height: 10),

            MovieSlider(
              movies: moviesProvider.topRatedMovies,
              title: 'Top Rated',
            ),*/
          ],
        ),
      ),
    );
  }
}
