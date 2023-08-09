import 'package:flutter/material.dart';
import 'package:peliculas_app/widgets/widgets.dart';

import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    //print(movie.title);
    // print(movie.backdropPath);

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(
          movie,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          _PosterAndTitle(
            movie,
          ),
          _Overview(
            movie: movie,
          ),
          const SizedBox(height: 25),
          CastingCards(movie.id),
        ])),
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar(this.movie);
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            width: double.infinity,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 10),
            color: Colors.black12,
            child: Text(movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          ),
          background: FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'),
            image: NetworkImage(movie.backPosterImg),
            fit: BoxFit.cover,
          )),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    String averegeVote = movie.voteAverage.toString();
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpj'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
                width: 110,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title,
                    style: textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                Text(
                  movie.originalTitle,
                  style: textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(width: 5),
                Row(
                  children: [
                    const Icon(Icons.star, size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      movie.voteAverage.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({required this.movie});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
