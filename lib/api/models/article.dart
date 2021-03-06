import 'source_in_article.dart';

class Article {
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

  Article.fromJSON(dynamic json)
      : source = SourceInArticle.fromJSON(json['source']),
        author = json['author'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        url = json['url'] as String,
        urlToImage = json['urlToImage'] as String,
        publishedAt = DateTime.parse(json['publishedAt'] as String),
        content = json['content'] as String;

  final SourceInArticle source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'source': source.toJSON(),
        'author': author,
        'title': title,
        'description': description,
        'url': url,
        'urlToImage': urlToImage,
        'publishedAt': publishedAt.toIso8601String(),
        'content': content,
      };
}
