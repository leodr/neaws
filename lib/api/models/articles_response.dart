import 'article.dart';

class ArticlesResponse {
  ArticlesResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  ArticlesResponse.fromJSON(dynamic json)
      : status = json['status'] as String,
        totalResults = json['totalResults'] as int,
        articles = (json['articles'] as List)
            .map<Article>((e) => Article.fromJSON(e))
            .toList();

  final String status;
  final int totalResults;
  final List<Article> articles;
}
