import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/Model/categories_new_model.dart';
import 'package:news_app/Model/news_channels_headline_model.dart';



class NewsRepository {
  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String source) async {
    String url = "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=88c88fed94c640fea54f1e2bcb7d2408";

    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(body);
      
    } else {
      throw Exception("Error");
    }
  }


  Future<CategoriesNewsModel> fetchCategorisNewsApi(String category) async {
    String url = "https://newsapi.org/v2/everything?q=$category&apiKey=88c88fed94c640fea54f1e2bcb7d2408";

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
