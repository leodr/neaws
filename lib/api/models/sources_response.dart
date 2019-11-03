import 'source.dart';

class SourcesResponse {
  final String status;
  final List<Source> sources;

  SourcesResponse({
    this.status,
    this.sources,
  });

  SourcesResponse.fromJSON(Map json)
      : status = json["status"],
        sources = json["sources"].map(
          (e) => Source.fromJSON(e),
        );
}
