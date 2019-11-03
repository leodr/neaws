class SourceInArticle {
  final String id;
  final String name;

  SourceInArticle({
    this.id,
    this.name,
  });

  SourceInArticle.fromJSON(Map json)
      : this.id = json["id"],
        this.name = json["name"];
}
