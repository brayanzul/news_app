import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app/src/models/category_model.dart';
import 'package:news_app/src/models/news_models.dart';
import 'package:http/http.dart' as http;

// ignore: constant_identifier_names
const String _URL_NEWS = 'https://newsapi.org/v2';
// ignore: constant_identifier_names
const String _APIKEY   = '1abc9d39619b4d0ea4cc9877d5525e4c';

class NewsService with ChangeNotifier {

  List<Article> headlines = [];
  String _selectedCategory = 'business';

  List<CategoryModel> categories = [
    CategoryModel( FontAwesomeIcons.building, 'business'  ),
    CategoryModel( FontAwesomeIcons.tv, 'entertainment'  ),
    CategoryModel( FontAwesomeIcons.addressCard, 'general'  ),
    CategoryModel( FontAwesomeIcons.headSideVirus, 'health'  ),
    CategoryModel( FontAwesomeIcons.vials, 'science'  ),
    CategoryModel( FontAwesomeIcons.volleyballBall, 'sports'  ),
    CategoryModel( FontAwesomeIcons.memory, 'technology'  ),
  ];

  Map<String, List<Article>>? categoryArticles = {};

 // business entertainment general health science sports technology

  NewsService() {
    getTopHeadlines();

    for (var item in categories) {
      categoryArticles![item.name] = [];
    }

  }

  String get selectedCategory => _selectedCategory;
  set selectedCategory( String valor ) {
    _selectedCategory = valor;

    getArticlesByCategory( valor );
    notifyListeners();
  }

  List<Article>? get getArticulosCategoriaSeleccionada => categoryArticles![selectedCategory];

  getTopHeadlines() async {
    
    final url = Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca');
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    headlines.addAll( newsResponse.articles );
    notifyListeners();
  }

  getArticlesByCategory( String categoryModel ) async {

    if( categoryArticles!.isNotEmpty ) {
      return categoryArticles![categoryModel];
    }

    final url = Uri.parse('$_URL_NEWS/top-headlines?apiKey=$_APIKEY&country=ca&category=$categoryModel');
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    categoryArticles![categoryModel]?.addAll( newsResponse.articles );

    notifyListeners();

  }

}
