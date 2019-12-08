class SourceInArticle {
  SourceInArticle({
    this.id,
    this.name,
  });

  SourceInArticle.fromJSON(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  final String id;
  final String name;

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
