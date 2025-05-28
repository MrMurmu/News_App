import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/Model/categories_new_model.dart';
import 'package:news_app/Model/news_channels_headline_model.dart';

// newsapi.org/v2/everything?q=$category&apiKey=b25ee33f4dd74c7bbde0683353bdde3c';


class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String source) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=b25ee33f4dd74c7bbde0683353bdde3c";

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
      
    } else {
      throw Exception("Error");
    }
  }


  Future<CategoriesNewsModel> fetchCategorisNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=$category&apiKey=b25ee33f4dd74c7bbde0683353bdde3c";

    final response = await http.get(Uri.parse(url));
    print(response.body);
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
      
    } else {
      throw Exception("Error");
    }
  }
}
