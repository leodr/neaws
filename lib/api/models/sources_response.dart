import 'source.dart';

class SourcesResponse {
  SourcesResponse({
    this.status,
    this.sources,
  });

  SourcesResponse.fromJSON(Map<String, dynamic> json)
      : status = json['status'],
        sources = json['sources'].map(
          (dynamic e) => Source.fromJSON(e),
        );

  final String status;
  final List<Source> sources;
}
