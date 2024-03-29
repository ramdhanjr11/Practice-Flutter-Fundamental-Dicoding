import 'package:flutter/widgets.dart';
import 'package:news_app/data/api/api_service.dart';
import 'package:news_app/data/model/article.dart';

enum ResultState { Loading, NoData, HasData, Error }

class NewsProvider extends ChangeNotifier {
  final ApiService apiService;

  NewsProvider({required this.apiService}) {
    _fetchAllArticle();
  }

  late ArticlesResult _articlesResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  ArticlesResult get result => _articlesResult;
  ResultState get state => _state;

  Future<dynamic> _fetchAllArticle() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final article = await apiService.topHeadlines();
      if (article.articles.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _articlesResult = article;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
