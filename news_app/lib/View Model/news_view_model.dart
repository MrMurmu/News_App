import 'package:news_app/Model/categories_new_model.dart';
import 'package:news_app/Model/news_channels_headline_model.dart';
import 'package:news_app/Repository/news_repository.dart';



class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String source) async {
    return await _rep.fetchNewsChannelsHeadlinesApi(source);
  }

  Future<CategoriesNewsModel> fetchCategorisNewsApi(String category) async {
    return await _rep.fetchCategorisNewsApi(category);
  }
}
