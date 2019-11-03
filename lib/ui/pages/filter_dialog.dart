import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:neaws/constants/languages.dart';
import 'package:neaws/constants/sortings.dart';
import 'package:neaws/util/date_utils.dart';
import 'package:provider/provider.dart';
import 'package:simple_design/simple_design.dart';

import '../../providers/news_search_provider.dart';

class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TextEditingController _searchTermController = TextEditingController();

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
            final searchFilter = newsSearchProvider.searchFilter;

            _searchTermController.text = searchFilter.searchTerm;

            return CustomScrollView(
              slivers: <Widget>[
                SDSliverAppBar(
                  title: Text("Filters"),
                  actions: <Widget>[
                    IconButton(
                      icon: Icon(EvaIcons.checkmarkOutline),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ListTile(
                        leading: Icon(EvaIcons.textOutline),
                        title: TextField(
                          controller: _searchTermController,
                          onChanged: (v) {
                            newsSearchProvider.updateSearchFilter(
                                searchTerm: v);
                          },
                          decoration: InputDecoration(hintText: "Search term"),
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader("Date"),
                      ListTile(
                        leading: Icon(EvaIcons.calendarOutline),
                        title: Text("From:"),
                        trailing: Text(
                          formatDate(searchFilter.from),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 30)),
                            initialDate: searchFilter.from,
                            lastDate: DateTime.now(),
                          );

                          if (date != null)
                            newsSearchProvider.updateSearchFilter(from: date);
                        },
                      ),
                      ListTile(
                        leading: Icon(null),
                        title: Text("To:"),
                        trailing: Text(
                          formatDate(searchFilter.to),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 30)),
                            initialDate: searchFilter.to,
                            lastDate: DateTime.now(),
                          );

                          if (date != null)
                            newsSearchProvider.updateSearchFilter(to: date);
                        },
                      ),
                      SDDivider(),
                      SDSectionHeader("Sort by"),
                      ListTile(
                        leading: Icon(EvaIcons.arrowCircleDownOutline),
                        title: DropdownButton(
                          hint: Text("Sort by"),
                          value: searchFilter.sortings,
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              child: Text("Relevancy"),
                              value: Sortings.relevancy,
                            ),
                            DropdownMenuItem(
                              child: Text("Popularity"),
                              value: Sortings.popularity,
                            ),
                            DropdownMenuItem(
                              child: Text("Published At"),
                              value: Sortings.publishedAt,
                            ),
                          ],
                          onChanged: (value) {
                            newsSearchProvider.updateSearchFilter(
                                sortings: value);
                          },
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader("Language"),
                      ListTile(
                        leading: Icon(EvaIcons.globe2Outline),
                        title: DropdownButton(
                          isExpanded: true,
                          value: searchFilter.language,
                          items: List.generate(
                            Languages.values.length,
                            (i) => DropdownMenuItem(
                              child: Text(
                                Languages.values[i]
                                    .toString()
                                    .split(".")[1]
                                    .toUpperCase(),
                              ),
                              value: Languages.values[i],
                            ),
                          ),
                          onChanged: (val) {
                            return newsSearchProvider.updateSearchFilter(
                              language: val,
                            );
                          },
                        ),
                      ),
                      SDDivider(),
                      SDSectionHeader("Articles per page"),
                      ListTile(
                        leading: Icon(EvaIcons.bookOpenOutline),
                        title: Slider(
                          value: (searchFilter.pageLength - 10) / 90,
                          divisions: 9,
                          label: searchFilter.pageLength.toString(),
                          onChanged: (value) {
                            return newsSearchProvider.updateSearchFilter(
                              pageLength: (value * 90).round() + 10,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
