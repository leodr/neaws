import 'source_in_article.dart';

class Article {
  final SourceInArticle source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Article.fromJSON(Map json)
      : source = SourceInArticle.fromJSON(json["source"]),
        author = json["author"],
        title = json["title"],
        description = json["description"],
        url = json["url"],
        urlToImage = json["urlToImage"],
        publishedAt = DateTime.parse(json["publishedAt"]),
        content = json["content"];
}
