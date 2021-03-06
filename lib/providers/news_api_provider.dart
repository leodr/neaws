import 'package:flutter/foundation.dart';
import 'package:neaws/api/news_api.dart';

class NewsApiProvider with ChangeNotifier {
  NewsApiProvider({this.apiKey}) {
    _newsApi = NewsApi(apiKey: apiKey);
  }

  final String apiKey;

  NewsApi _newsApi;

  NewsApi get newsApi => _newsApi;

  set newsApi(NewsApi n) {
    _newsApi = n;
    notifyListeners();
  }

  void updateApiKey(String apiKey) {
    newsApi = NewsApi(apiKey: apiKey);
  }
}
