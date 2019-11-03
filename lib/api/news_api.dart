import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:dio/dio.dart';
import 'package:neaws/api/models/articles_response.dart';
import 'package:neaws/api/models/sources_response.dart';
import 'package:neaws/api/urls.dart';
import 'package:neaws/constants/categories.dart';
import 'package:neaws/constants/countries.dart';
import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';

class NewsApi {
  final String apiKey;

  Dio dio;

  NewsApi({this.apiKey}) {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        headers: {
          "X-Api-Key": apiKey,
        },
      ),
    );
  }

  Future<ArticlesResponse> getHeadlines({
    Countries country,
    Categories category,
    List<String> sources,
    String q,
    int pageSize,
    int page,
  }) async {
    final countryCode = country.toString().split(".")[1].toLowerCase();
    final categoryCode = category.toString().split(".")[1].toLowerCase();
    final sourceList = sources.join(",");

    final response = await dio.get(
      HEADLINES_ROUTE,
      queryParameters: {
        "country": countryCode,
        "category": categoryCode,
        "sources": sourceList,
        "q": q,
        "pageSize": pageSize,
        "page": page,
      },
    );
    final json = jsonDecode(response.data);

    return ArticlesResponse.fromJSON(json);
  }

  Future<ArticlesResponse> getEverything({
    String q,
    String qInTitle,
    List<String> sources,
    List<String> domains,
    List<String> excludeDomains,
    DateTime from,
    DateTime to,
    Languages language,
    Sortings sortBy,
    int pageSize,
    int page,
  }) async {
    final sourceList = sources.join(",");
    final domainList = domains.join(",");
    final excludeDomainList = excludeDomains.join(",");
    final fromString = from.toIso8601String();
    final toString = to.toIso8601String();
    final languageString = language.toString().split(".")[1].toLowerCase();
    final sortByString = sortBy.toString().split(".")[1].toLowerCase();

    final response = await dio.get(
      EVERYTHING_ROUTE,
      queryParameters: {
        "q": q,
        "qInTitle": qInTitle,
        "sources": sourceList,
        "domains": domainList,
        "excludeDomains": excludeDomainList,
        "from": fromString,
        "to": toString,
        "language": languageString,
        "sortBy": sortByString,
        "pageSize": pageSize,
        "page": page,
      },
    );
    final json = jsonDecode(response.data);

    return ArticlesResponse.fromJSON(json);
  }

  Future<SourcesResponse> getSources({
    Categories category,
    Languages language,
    Countries country,
  }) async {
    final categoryString = category.toString().split(".")[1].toLowerCase();
    final languageString = language.toString().split(".")[1].toLowerCase();
    final countryString = country.toString().split(".")[1].toLowerCase();

    final response = await dio.get(
      EVERYTHING_ROUTE,
      queryParameters: {
        "category": categoryString,
        "language": languageString,
        "country": countryString,
      },
    );
    final json = jsonDecode(response.data);

    return SourcesResponse.fromJSON(json);
  }
}
