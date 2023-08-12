class Movie {
  final String originalTitle;
  final String releaseDate;
  final double voteAverage;
  final String overview;
  final String posterPath;

  Movie({
    required this.originalTitle,
    required this.releaseDate,
    required this.voteAverage,
    required this.overview,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      originalTitle: json['original_title'],
      releaseDate: json['release_date'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }
}