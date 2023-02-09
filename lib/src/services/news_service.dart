import 'package:flutter/material.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY   = '1abc9d39619b4d0ea4cc9877d5525e4c';

class NewsService with ChangeNotifier {

  List<Article> headlines = [];

  NewsService() {


    this.getTopHeadlines();
  }

  getTopHeadlines() async {
    
    final url = '$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca';
    final resp = await http.get(url as Uri);

    final newsResponse = newsResponseFromJson( resp.body );

    this.headlines.addAll( newsResponse.articles );
    notifyListeners();
  }

}
