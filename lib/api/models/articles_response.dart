import 'article.dart';

class ArticlesResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  ArticlesResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  ArticlesResponse.fromJSON(Map json)
      : status = json["status"],
        totalResults = json["totalResults"],
        articles = json["articles"].map(
          (e) => Article.fromJSON(e),
        );
}
