import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

import '../../constants/languages.dart';
import '../../constants/sortings.dart';
import '../../models/search_filter.dart';
import '../../providers/news_search_provider.dart';
import '../../util/date_utils.dart';
import '../widgets/custom_back_button.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final TextEditingController _searchTermController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<NewsSearchProvider>(
          builder: (
            BuildContext context,
            NewsSearchProvider newsSearchProvider,
            _,
          ) {
            final SearchFilter searchFilter = newsSearchProvider.searchFilter;

            _searchTermController.text = searchFilter.searchTerm;

            return CustomScrollView(
              slivers: <Widget>[
                SDSliverAppBar(
                  leading: const CustomBackButton(),
                  title: const Text('Filters'),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(EvaIcons.checkmarkOutline),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    <Widget>[
                      ListTile(
                        leading: const Icon(EvaIcons.textOutline),
                        title: TextField(
                          controller: _searchTermController,
                          onChanged: (String v) {
                            newsSearchProvider.updateSearchFilter(
                                searchTerm: v);
                          },
                          decoration:
                              const InputDecoration(hintText: 'Search term'),
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader('Date'),
                      ListTile(
                        leading: const Icon(EvaIcons.calendarOutline),
                        title: const Text('From:'),
                        trailing: Text(
                          formatDate(searchFilter.from) ?? '',
                        ),
                        onTap: () async {
                          final DateTime date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            initialDate: searchFilter.from,
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            newsSearchProvider.updateSearchFilter(from: date);
                          }
                        },
                      ),
                      ListTile(
                        leading: const Icon(null),
                        title: const Text('To:'),
                        trailing: Text(
                          formatDate(searchFilter.to) ?? '',
                        ),
                        onTap: () async {
                          final DateTime date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 30)),
                            initialDate: searchFilter.to,
                            lastDate: DateTime.now(),
                          );

                          if (date != null) {
                            newsSearchProvider.updateSearchFilter(to: date);
                          }
                        },
                      ),
                      SDDivider(),
                      SDSectionHeader('Sort by'),
                      ListTile(
                        leading: const Icon(EvaIcons.trendingUpOutline),
                        title: DropdownButton<Sortings>(
                          hint: const Text('Sort by'),
                          value: searchFilter.sortings,
                          isExpanded: true,
                          items: const <DropdownMenuItem<Sortings>>[
                            DropdownMenuItem<Sortings>(
                              value: Sortings.relevancy,
                              child: Text('Relevancy'),
                            ),
                            DropdownMenuItem<Sortings>(
                              value: Sortings.popularity,
                              child: Text('Popularity'),
                            ),
                            DropdownMenuItem<Sortings>(
                              value: Sortings.publishedAt,
                              child: Text('Published At'),
                            ),
                          ],
                          onChanged: (Sortings value) {
                            newsSearchProvider.updateSearchFilter(
                                sortings: value);
                          },
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader('Language'),
                      ListTile(
                        leading: const Icon(EvaIcons.globe2Outline),
                        title: DropdownButton<Languages>(
                          isExpanded: true,
                          value: searchFilter.language,
                          items: List<DropdownMenuItem<Languages>>.generate(
                            Languages.values.length,
                            (int i) => DropdownMenuItem<Languages>(
                              value: Languages.values[i],
                              child: Text(
                                Languages.values[i]
                                    .toString()
                                    .split('.')[1]
                                    .toUpperCase(),
                              ),
                            ),
                          ),
                          onChanged: (Languages val) {
                            return newsSearchProvider.updateSearchFilter(
                              language: val,
                            );
                          },
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader('Articles per page'),
                      ListTile(
                        leading: const Icon(EvaIcons.bookOpenOutline),
                        title: Slider(
                          value: (searchFilter.pageLength - 10) / 90,
                          divisions: 9,
                          label: searchFilter.pageLength.toString(),
                          onChanged: (double value) {
                            return newsSearchProvider.updateSearchFilter(
                              pageLength: (value * 90).round() + 10,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
