import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MovieModel.dart';

class HomePage extends StatelessWidget {
  Future<List<Movie>> fetchMovies() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&api_key=baa0cfef49e2a982e25aaf900ab30b91");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191826),
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Favorite Movie',
          style: TextStyle(fontSize: 25.0, color: Color(0xff56f433)),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff191826),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Movie>>(
          future: fetchMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                padding: EdgeInsets.all(8),
                itemBuilder: (BuildContext context, int index) {
                  var movie = snapshot.data?[index];
                  var ratingValue = movie!.voteAverage / 2;
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: 100,
                              alignment: Alignment.center,
                              child: Card(
                                child: Image.network(
                                  "https://image.tmdb.org/t/p/w200" +
                                      snapshot.data![index].posterPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data![index].originalTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Tahun Rilis : ' + snapshot.data![index].releaseDate,
                                    style: TextStyle(
                                      color: Color(0xff868597),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        ratingValue.toStringAsFixed(1),
                                        style: TextStyle(
                                          color: Color(0xff868597),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    height: 60,
                                    child: Text(
                                      snapshot.data![index].overview,
                                      style: TextStyle(
                                        color: Color(0xff868597),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ],
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
