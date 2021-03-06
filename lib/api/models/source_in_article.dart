class SourceInArticle {
  SourceInArticle({
    this.id,
    this.name,
  });

  SourceInArticle.fromJSON(dynamic json)
      : id = json['id'] as String,
        name = json['name'] as String;

  final String id;
  final String name;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
