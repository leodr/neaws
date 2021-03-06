import 'source.dart';

class SourcesResponse {
  SourcesResponse({
    this.status,
    this.sources,
  });

  SourcesResponse.fromJSON(dynamic json)
      : status = json['status'] as String,
        sources = (json['sources'] as List)
            .map<Source>((e) => Source.fromJSON(e))
            .toList();

  final String status;
  final List<Source> sources;
}
