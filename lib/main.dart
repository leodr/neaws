import "dart:async";
import "dart:convert";

import "package:community_material_icon/community_material_icon.dart";
import "package:flutter/material.dart";
import "package:flutter_news_app/api_key.dart";
import "package:flutter_news_app/custom_items/list_item.dart";
import "package:flutter_news_app/custom_items/sources_item.dart";
import "package:flutter_news_app/custom_items/theme_controller.dart";
import "package:flutter_news_app/pages/search_page.dart";
import "package:flutter_news_app/pages/settings_page.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:simple_design/simple_design.dart";

void main() => runApp(MainApp());

final ThemeData lightTheme = SimpleDesign.lightTheme;

final ThemeData darkTheme = SimpleDesign.darkTheme;

final _themeGlobalKey = GlobalKey(debugLabel: "app_theme");

class MainApp extends StatefulWidget {
  MainApp() : super(key: _themeGlobalKey);

  @override
  MainAppState createState() {
    return MainAppState();
  }
}

class MainAppState extends State<MainApp> {
  ThemeData _theme = lightTheme;

  set theme(newTheme) {
    if (newTheme != _theme) {
      setState(() => _theme = newTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      appThemeKey: _themeGlobalKey,
      child: MaterialApp(
        color: _theme.backgroundColor,
        debugShowCheckedModeBanner: false,
        title: "Neaws",
        theme: _theme,
        home: MainPage(),
        routes: {"/settings": (context) => SettingsPage()},
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List listItems = [],
      businessNews = [],
      entertainmentNews = [],
      generalNews = [],
      healthNews = [],
      scienceNews = [],
      sportsNews = [],
      technologyNews = [],
      sourcesList = [],
      savedItems = [];

  int index = 0;

  TabController controller;

  ScrollController mainPageScroller = ScrollController();
  ScrollController secondPageScroller = ScrollController();
  ScrollController thirdPageScroller = ScrollController();
  ScrollController fourthPageScroller = ScrollController();

  @override
  void initState() {
    _setTheme();

    updateMainPageList();
    updateBusinessPageList();
    updateEntertainmentPageList();
    updateGeneralPageList();
    updateHealthPageList();
    updateSciencePageList();
    updateSportsPageList();
    updateTechnologyPageList();

    updateSavedList();
    updateSourcesList();

    super.initState();

    controller = TabController(length: 7, vsync: this);
  }

  void _setTheme() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    bool darkMode = _prefs.getBool("darkMode") ?? false;
    ThemeController.of(context).appTheme =
        darkMode ? AppThemeOption.dark : AppThemeOption.light;
  }

  Widget _buildSettingsButton() => IconButton(
        icon: Icon(CommunityMaterialIcons.settings_outline),
        onPressed: () {
          Navigator.of(context).pushNamed("/settings");
        },
      );

  Widget _buildSearchButton() => IconButton(
        icon: Icon(Icons.search),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SearchPage())),
      );

  Widget _buildFirstPage() => RefreshIndicator(
        backgroundColor: Theme.of(context).backgroundColor,
        key: Key("firstPage"),
        displacement: kToolbarHeight,
        onRefresh: () async {
          return await fetchAPIData(
              buildHeadlineRequest(countryCode: Countries.gb, apiKey: API_KEY));
        },
        child: CustomScrollView(
          controller: mainPageScroller,
          slivers: <Widget>[
            SDSliverAppBar(
              leading: _buildSearchButton(),
              title: RichText(
                  text: TextSpan(
                      text: "Neaws ",
                      style: Theme.of(context).textTheme.title,
                      children: [
                    TextSpan(
                        text: "Headlines",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.normal))
                  ])),
              actions: <Widget>[_buildSettingsButton()],
            ),
            listItems.length < 1
                ? SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, i) => ListItem(
                              listItems[i],
                              onSaved: updateSavedList,
                            ),
                        childCount: listItems.length))
          ],
        ),
      );

  Widget _buildSecondPage() => NestedScrollView(
      key: Key("secondPage"),
      controller: secondPageScroller,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SDSliverAppBar(
              leading: _buildSearchButton(),
              title: RichText(
                  text: TextSpan(
                      text: "Neaws ",
                      style: Theme.of(context).textTheme.title,
                      children: [
                    TextSpan(
                        text: "Topics",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.normal))
                  ])),
              pinned: false,
              floating: true,
              snap: true,
              actions: <Widget>[_buildSettingsButton()],
              bottom: TabBar(controller: controller, isScrollable: true, tabs: [
                Tab(
                  text: "Business",
                  icon: Icon(CommunityMaterialIcons.finance),
                ),
                Tab(
                  text: "Entertainment",
                  icon: Icon(CommunityMaterialIcons.television_classic),
                ),
                Tab(
                    text: "General",
                    icon: Icon(CommunityMaterialIcons.account_group)),
                Tab(
                  text: "Health",
                  icon: Icon(CommunityMaterialIcons.hospital),
                ),
                Tab(
                  text: "Science",
                  icon: Icon(CommunityMaterialIcons.test_tube),
                ),
                Tab(
                    text: "Sports",
                    icon: Icon(CommunityMaterialIcons.basketball)),
                Tab(
                    text: "Technology",
                    icon: Icon(CommunityMaterialIcons.cellphone_link)),
              ]),
            )
          ],
      body: TabBarView(controller: controller, children: [
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateBusinessPageList();
          },
          child: businessNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        businessNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: businessNews.length),
        ),
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateEntertainmentPageList();
          },
          child: entertainmentNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        entertainmentNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: entertainmentNews.length),
        ),
        RefreshIndicator(
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateGeneralPageList();
          },
          child: generalNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        generalNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: generalNews.length),
        ),
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateHealthPageList();
          },
          child: healthNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        healthNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: healthNews.length),
        ),
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateSciencePageList();
          },
          child: scienceNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        scienceNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: scienceNews.length),
        ),
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateSportsPageList();
          },
          child: sportsNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        sportsNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: sportsNews.length),
        ),
        RefreshIndicator(
          backgroundColor: Theme.of(context).backgroundColor,
          displacement: kToolbarHeight,
          onRefresh: () async {
            return await updateTechnologyPageList();
          },
          child: technologyNews.length < 1
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, i) => ListItem(
                        technologyNews[i],
                        onSaved: updateSavedList,
                      ),
                  itemCount: technologyNews.length),
        ),
      ]));

  Widget _buildThirdPage() => RefreshIndicator(
      key: Key("thirdPage"),
      onRefresh: updateSavedList,
      child: CustomScrollView(
        slivers: <Widget>[
          SDSliverAppBar(
              leading: _buildSearchButton(),
              title: RichText(
                  text: TextSpan(
                      text: "Neaws ",
                      style: Theme.of(context).textTheme.title,
                      children: [
                    TextSpan(
                        text: "Saved",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontWeight: FontWeight.normal))
                  ])),
              actions: [_buildSettingsButton()]),
          savedItems.length < 1
              ? SliverFillRemaining(
                  child: Center(
                      child: Text("You have not saved any articles yet.")),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, i) => Dismissible(
                            background: Container(
                              color: Theme.of(context).errorColor,
                            ),
                            key: Key(i.toString()),
                            child: ListItem(savedItems[i]),
                            onDismissed: (direction) async {
                              SharedPreferences.getInstance().then((_prefs) {
                                _prefs.setStringList("saved",
                                    _prefs.getStringList("saved")..removeAt(i));
                                updateSavedList();
                              });
                            },
                          ),
                      childCount: savedItems.length))
        ],
      ));

  Widget _buildFourthPage() => RefreshIndicator(
      onRefresh: updateSourcesList,
      child: CustomScrollView(
        key: Key("fourthPage"),
        controller: fourthPageScroller,
        slivers: [
          SDSliverAppBar(
            leading: _buildSearchButton(),
            title: RichText(
                text: TextSpan(
                    text: "Neaws ",
                    style: Theme.of(context).textTheme.title,
                    children: [
                  TextSpan(
                      text: "Sources",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontWeight: FontWeight.normal))
                ])),
            actions: <Widget>[_buildSettingsButton()],
          ),
          SliverList(
            delegate: SliverChildListDelegate(sourcesList),
          )
        ],
      ));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200), child: _getBody(index)),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (position) {
              if (position != index) {
                setState(() {
                  index = position;
                });
              } else {
                switch (index) {
                  case 0:
                    mainPageScroller.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    break;
                  case 1:
                    secondPageScroller.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    break;
                  case 2:
                    thirdPageScroller.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    break;
                  case 3:
                    fourthPageScroller.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    break;
                }
              }
            },
            currentIndex: index,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  CommunityMaterialIcons.newspaper,
                ),
                title: Text("Headlines"),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    CommunityMaterialIcons.folder_outline,
                  ),
                  activeIcon: Icon(CommunityMaterialIcons.folder),
                  title: Text("Topics")),
              BottomNavigationBarItem(
                  icon: Icon(
                    CommunityMaterialIcons.star_outline,
                  ),
                  activeIcon: Icon(CommunityMaterialIcons.star),
                  title: Text("Saved")),
              BottomNavigationBarItem(
                  icon: Icon(
                    CommunityMaterialIcons.code_tags,
                  ),
                  title: Text("Sources"))
            ]),
      ),
    );
  }

  Future<Null> updateMainPageList() async {
    await fetchAPIData(
            buildHeadlineRequest(countryCode: Countries.gb, apiKey: API_KEY))
        .then((list) {
      setState(() {
        listItems = list;
      });
    });
    return null;
  }

  Future<Null> updateBusinessPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.business,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        businessNews = list;
      });
    });
    return null;
  }

  Future<Null> updateEntertainmentPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.entertainment,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        entertainmentNews = list;
      });
    });
    return null;
  }

  Future<Null> updateGeneralPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.general,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        generalNews = list;
      });
    });
    return null;
  }

  Future<Null> updateHealthPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.health,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        healthNews = list;
      });
    });
    return null;
  }

  Future<Null> updateSciencePageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.science,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        scienceNews = list;
      });
    });
    return null;
  }

  Future<Null> updateSportsPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.sports,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        sportsNews = list;
      });
    });
    return null;
  }

  Future<Null> updateTechnologyPageList() async {
    await fetchAPIData(buildHeadlineRequest(
            countryCode: Countries.gb,
            category: Categories.technology,
            apiKey: API_KEY))
        .then((list) {
      setState(() {
        technologyNews = list;
      });
    });
    return null;
  }

  Future<Null> updateSavedList() async {
    SharedPreferences.getInstance().then((_prefs) {
      List savedList = _prefs.getStringList("saved") ?? [];

      setState(() {
        savedItems = [];
        savedList.forEach((e) {
          savedItems.add(json.decode(e));
        });
      });
    });
    return null;
  }

  Future<Null> updateSourcesList() async {
    await fetchSourceData(buildSourcesRequest(
            country: Countries.gb, language: Languages.en, apiKey: API_KEY))
        .then((list) {
      setState(() {
        sourcesList = list;
      });
    });
    return null;
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return _buildFirstPage();
      case 1:
        return _buildSecondPage();
      case 2:
        return _buildThirdPage();
      case 3:
        return _buildFourthPage();
    }
    return Text("Error.");
  }
}

Future fetchAPIData(String url) async {
  var response = await http.get(url);
  var data = json.decode(response.body);

  return data["articles"];
}

Future<List<Widget>> fetchSourceData(String url) async {
  var response = await http.get(url);
  var data = json.decode(response.body);

  List<Widget> widgetList = [];
  for (int i = 0; i < data["sources"].length; i++) {
    widgetList.add(SourcesItem(
      source: data["sources"][i],
      apiKey: API_KEY,
    ));
  }
  return widgetList;
}

String buildHeadlineRequest(
    {Countries countryCode,
    Categories category,
    String searchTerm,
    int pageSize,
    int page,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/top-headlines?";

  if (countryCode != null)
    url += ("country=" +
        countryCode.toString().replaceAll("Countries.", "") +
        "&");
  if (category != null)
    url +=
        ("category=" + category.toString().replaceAll("Categories.", "") + "&");
  if (searchTerm != null) url += ("q=" + searchTerm + "&");
  if (pageSize != null) url += ("pageSize=" + pageSize.toString() + "&");
  if (page != null) url += ("page=" + page.toString() + "&");

  return url += ("apiKey=" + apiKey);
}

String buildEverythingRequest(
    {String searchTerm,
    String sourcesIDs,
    String domains,
    DateTime from,
    DateTime to,
    Languages language,
    Sortings sortBy,
    int pageSize,
    int page,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/everything?";

  if (searchTerm != null) url += ("q=" + searchTerm + "&");
  if (sourcesIDs != null) url += ("sources=" + sourcesIDs + "&");
  if (domains != null) url += ("domains=" + domains + "&");
  if (from != null) url += ("from=" + from.toIso8601String() + "&");
  if (to != null) url += ("to=" + to.toIso8601String() + "&");
  if (language != null)
    url +=
        ("language=" + language.toString().replaceAll("Languages.", "") + "&");
  if (sortBy != null)
    url += ("sortBy=" + sortBy.toString().replaceAll("Sortings.", "") + "&");
  if (pageSize != null) url += ("pageSize=" + pageSize.toString() + "&");
  if (page != null) url += ("page=" + page.toString() + "&");

  return url += ("apiKey=" + apiKey);
}

String buildSourcesRequest(
    {Categories category,
    Languages language,
    Countries country,
    @required String apiKey}) {
  String url = "https://newsapi.org/v2/sources?";

  if (category != null)
    url +=
        ("category=" + category.toString().replaceAll("Categories.", "") + "&");
  if (language != null)
    url +=
        ("language=" + language.toString().replaceAll("Languages.", "") + "&");
  if (country != null)
    url += ("country=" + country.toString().replaceAll("Countries.", "") + "&");

  return url += ("apiKey=" + apiKey);
}

enum Sortings { relevancy, popularity, publishedAt }

enum Categories {
  business,
  entertainment,
  general,
  health,
  science,
  sports,
  technology
}

enum Countries {
  ae,
  ar,
  at,
  au,
  be,
  bg,
  br,
  ca,
  ch,
  cn,
  co,
  cu,
  cz,
  de,
  eg,
  fr,
  gb,
  gr,
  hk,
  hu,
  id,
  ie,
  il,
  it,
  jp,
  kr,
  lt,
  lv,
  ma,
  mx,
  my,
  ng,
  nl,
  no,
  nz,
  ph,
  pl,
  pt,
  ro,
  rs,
  ru,
  sa,
  se,
  sg,
  si,
  sk,
  th,
  tr,
  tw,
  ua,
  us,
  ve,
  za
}

enum Languages { ar, de, en, es, fr, he, it, nl, no, pt, ru, se, ud, zh }
