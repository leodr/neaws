import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/api_key.dart';
import 'package:flutter_news_app/custom_items/list_item.dart';
import 'package:flutter_news_app/main.dart';
import 'package:flutter_news_app/util.dart';
import 'package:simple_design/simple_design.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List searchList = [];
  Map currentFilter;

  bool loading = false;

  Future<Null> updateSearchPageList(String q,
      {Languages language,
      Sortings sortBy,
      DateTime from,
      DateTime to,
      int pageSize}) async {
    setState(() {
      loading = true;
    });
    await fetchAPIData(buildEverythingRequest(
            searchTerm: q,
            language: language ?? Languages.en,
            sortBy: sortBy ?? Sortings.relevancy,
            from: from,
            to: to,
            pageSize: pageSize,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        searchList = list ?? [];
        loading = false;
      });
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              title: TextField(
                onSubmitted: (q) => updateSearchPageList(q),
                decoration: InputDecoration(
                    hintText: "Search",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.0)),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 2.0,
              forceElevated: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.tune),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => FilterDialog(currentFilter),
                            fullscreenDialog: true))
                        .then((searchMap) {
                      if (searchMap != null) {
                        currentFilter = searchMap;
                        updateSearchPageList(searchMap["q"],
                            from: searchMap["from"],
                            language: searchMap["language"],
                            pageSize: searchMap["pageSize"],
                            sortBy: searchMap["sortBy"],
                            to: searchMap["to"]);
                      }
                    });
                  },
                )
              ],
            ),
            searchList.length < 1
                ? SliverFillRemaining(
                    child: Center(
                        child: loading
                            ? CircularProgressIndicator()
                            : Text(
                                "Tap the textfield to search.",
                                style: Theme.of(context).textTheme.caption,
                              )),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, i) => ListItem(searchList[i]),
                        childCount: searchList.length),
                  )
          ],
        ),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final Map filter;

  FilterDialog(Map filter) : this.filter = filter ?? {};

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TextEditingController _searchController = TextEditingController();
  DateTime from;
  DateTime to;
  Sortings dropdownValue;
  double sliderValue;
  Languages lang;

  @override
  void initState() {
    _searchController.text = widget.filter["q"] ?? "";
    from = widget.filter["from"] ??
        DateTime.now().subtract(Duration(days: 29, hours: 23));
    to = widget.filter["to"] ?? DateTime.now();
    dropdownValue = widget.filter["sorting"] ?? Sortings.relevancy;
    sliderValue = ((widget.filter["pageSize"] ?? 20) - 10) / 90;
    lang = widget.filter["language"] ?? Languages.en;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SDSliverAppBar(
              title: Text("Filters"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop({
                      "q": _searchController.text,
                      "from": from,
                      "to": to,
                      "pageSize":
                          int.parse((sliderValue * 90 + 10).toStringAsFixed(0)),
                      "language": lang,
                      "sorting": dropdownValue
                    });
                  },
                )
              ],
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              ListTile(
                leading: Icon(Icons.text_fields),
                title: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: "Search term"),
                ),
              ),
              SDDivider(),
              SDSectionHeader("Date"),
              ListTile(
                leading: Icon(CommunityMaterialIcons.calendar_export),
                title: Text("From:"),
                trailing: Text(getWeekDayString(from.weekday) +
                    ", " +
                    from.day.toString() +
                    ". " +
                    getMonthString(from.month) +
                    " " +
                    from.year.toString()),
                onTap: () async {
                  showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 30)),
                          initialDate: from,
                          lastDate: DateTime.now())
                      .then((date) {
                    if (date != null) setState(() => from = date);
                  });
                },
              ),
              ListTile(
                leading: Icon(CommunityMaterialIcons.calendar_import),
                title: Text("To:"),
                trailing: Text(getWeekDayString(to.weekday) +
                    ", " +
                    to.day.toString() +
                    ". " +
                    getMonthString(to.month) +
                    " " +
                    to.year.toString()),
                onTap: () async {
                  showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now().subtract(Duration(days: 30)),
                          initialDate: to,
                          lastDate: DateTime.now())
                      .then((date) {
                    if (date != null) setState(() => to = date);
                  });
                },
              ),
              SDDivider(),
              SDSectionHeader("Sort by"),
              ListTile(
                leading: Icon(CommunityMaterialIcons.sort),
                title: DropdownButton(
                    hint: Text("Sort by"),
                    value: dropdownValue,
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
                      )
                    ],
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    }),
              ),
              SDDivider(),
              SDSectionHeader("Language"),
              ListTile(
                leading: Icon(Icons.language),
                title: DropdownButton(
                    isExpanded: true,
                    value: lang,
                    items: List.generate(
                        Languages.values.length,
                        (i) => DropdownMenuItem(
                              child: Text(Languages.values[i]
                                  .toString()
                                  .split(".")[1]
                                  .toUpperCase()),
                              value: Languages.values[i],
                            )),
                    onChanged: (val) => setState(() => lang = val)),
              ),
              SDDivider(),
              SDSectionHeader("Articles per page"),
              ListTile(
                leading: Icon(CommunityMaterialIcons.library_books),
                title: Slider(
                    value: sliderValue,
                    divisions: 9,
                    label: (sliderValue * 90 + 10).toStringAsFixed(0),
                    onChanged: (value) => setState(() => sliderValue = value)),
              )
            ]))
          ],
        ),
      ),
    );
  }
}
