import 'article.dart';

class ArticlesResponse {
  ArticlesResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  ArticlesResponse.fromJSON(Map<String, dynamic> json)
      : status = json['status'],
        totalResults = json['totalResults'],
        articles = json['articles']
            .map<Article>(
              (dynamic e) => Article.fromJSON(e),
            )
            .toList();

  final String status;
  final int totalResults;
  final List<Article> articles;
}
