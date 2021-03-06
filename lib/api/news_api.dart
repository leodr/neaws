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
  NewsApi({this.apiKey}) {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        headers: <String, dynamic>{
          'X-Api-Key': apiKey,
        },
      ),
    );
  }

  final String apiKey;

  Dio dio;

  Future<ArticlesResponse> getHeadlines({
    Countries country,
    Categories category,
    List<String> sources,
    String q,
    int pageSize,
    int page,
  }) async {
    final String countryCode =
        country != null ? country.toString().split('.')[1].toLowerCase() : null;
    final String categoryCode = category != null
        ? category.toString().split('.')[1].toLowerCase()
        : null;
    final String sourceList = sources?.join(',');

    final Map<String, String> queryParameters = <String, String>{
      'country': countryCode,
      'category': categoryCode,
      'sources': sourceList,
      'q': q,
      'pageSize': pageSize?.toString(),
      'page': page?.toString(),
    }..removeWhere((String key, String value) => value == null);

    final Response<dynamic> response = await dio.get<dynamic>(HEADLINES_ROUTE,
        queryParameters: queryParameters);

    return ArticlesResponse.fromJSON(response.data);
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
    final String sourceList = sources?.join(',');
    final String domainList = domains?.join(',');
    final String excludeDomainList = excludeDomains?.join(',');
    final String fromString = from?.toIso8601String();
    final String toString = to?.toIso8601String();
    final String languageString = language != null
        ? language.toString().split('.')[1].toLowerCase()
        : null;
    final String sortByString =
        sortBy != null ? sortBy.toString().split('.')[1].toLowerCase() : null;

    final Map<String, String> queryParameters = <String, String>{
      'q': q,
      'qInTitle': qInTitle,
      'sources': sourceList,
      'domains': domainList,
      'excludeDomains': excludeDomainList,
      'from': fromString,
      'to': toString,
      'language': languageString,
      'sortBy': sortByString,
      'pageSize': pageSize?.toString(),
      'page': page?.toString(),
    }..removeWhere((String key, String value) => value == null);

    final Response<dynamic> response = await dio.get<dynamic>(
      EVERYTHING_ROUTE,
      queryParameters: queryParameters,
    );

    return ArticlesResponse.fromJSON(response.data);
  }

  Future<SourcesResponse> getSources({
    Categories category,
    Languages language,
    Countries country,
  }) async {
    final String categoryString = category != null
        ? category.toString().split('.')[1].toLowerCase()
        : null;
    final String languageString = language != null
        ? language.toString().split('.')[1].toLowerCase()
        : null;
    final String countryString =
        country != null ? country.toString().split('.')[1].toLowerCase() : null;

    final Map<String, String> queryParameters = <String, String>{
      'category': categoryString,
      'language': languageString,
      'country': countryString,
    }..removeWhere((String key, String value) => value == null);

    final Response<dynamic> response = await dio.get<dynamic>(
      EVERYTHING_ROUTE,
      queryParameters: queryParameters,
    );
    final Map<String, dynamic> json = jsonDecode(response.data);

    return SourcesResponse.fromJSON(json);
  }
}
