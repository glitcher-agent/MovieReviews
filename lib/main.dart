import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MovieZone();
  }
}

class MovieZone extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieZoneState();
  }
}

class Theme with ChangeNotifier {
  static bool isDark = true;
  ThemeMode currentTheme() {
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}

class MovieZoneState extends State<MovieZone> with SingleTickerProviderStateMixin{
  static const adunitid="ca-app-pub-9397860985929265~1377003222";
  final nativeadmob=NativeAdmob();
   static const Color beginColor = Colors.deepPurple;
  static const Color endColor = Colors.deepOrange;
  Duration duration = Duration(milliseconds: 200);
  AnimationController controller;
  Animation<Color> animation;
  Theme currentTheme = Theme();
  void initState() {
    super.initState();
    nativeadmob.initialize(
      appID: "ca-app-pub-9397860985929265~1377003222"
    );

    controller = AnimationController(vsync: this, duration: duration);
    animation = ColorTween(begin: beginColor, end: endColor).animate(controller);
    currentTheme.addListener(() {
      print("changed");
      setState(() {});
    });
  }

  final String url = "";
  TextEditingController movieController = TextEditingController(text: "");
  var res;
  var conv;
  //movie variables
  String title = " ";
  String year = " ";
  String poster = " ";
  String runtime = "";
  String director = " ";
  String imdbRating = " ";
  String boxoffice = " ";
  String country = " ";
  String actors = " ";
  String plot = " ";
  String production=" ";
  String awards =" ";

  Future<String> getJsonData() async {
    res = await http.get(
        Uri.encodeFull(
            "http://omdbapi.com/?apikey=e8a86e41+&t=${movieController.text}"),
        headers: {"Accept": "application/json"});

    setState(() {
      conv = json.decode(res.body);
      title = conv['Title'];
      year = conv['Released'];
      poster = conv['Poster'];
      runtime = conv['Runtime'];
      director = conv['Director'];
      imdbRating = conv['imdbRating'];
      boxoffice = conv['BoxOffice'];
      country = conv['Country'];
      actors = conv['Actors'];
      plot = conv['Plot'];
      production=conv['Production'];
      awards=conv['Awards'];

      print(conv['Title']);
    });
    return "Sucess";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: Scaffold(
        appBar: AppBar(title: Text("Search Movies & webseries")),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            currentTheme.switchTheme();
          },
          label: Text(""),
          icon: Icon(Icons.brightness_medium),
        ),
        body: SingleChildScrollView(
          
          child: Container(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Movie or webseries Name'),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        controller: movieController,
                      ),
                      Padding(padding: EdgeInsets.only(top: 5)),
                      
                      RaisedButton(
                        hoverElevation: 20,
                        color: animation.value,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        child: Text(
                          "Find Movie",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: (){                          
                          if (controller.status == AnimationStatus.completed) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
                 movieController.text != null ? getJsonData() : " ";
              },                               
                        
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 500,
                  child: SingleChildScrollView(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0)),
                      child: Container(
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network("$poster",
                                    height: 300, width: 300),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Title :$title",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "imdbRating :$imdbRating",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Release Year:$year",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Runtime : $runtime",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Director : $director",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Boxoffice : $boxoffice",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Country : $country",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Actors : $actors",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "Plot : $plot",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                               
                                 Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "production : $production",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                 Padding(padding: EdgeInsets.only(top: 10)),
                                Text(
                                  "awards : $awards",
                                  style: TextStyle(
                                    fontSize: 18,fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 10)),
                                NativeAdmobBannerView(
                                  adUnitID: adunitid,
                                  showMedia: true,
                                  style: BannerStyle.dark,
                                  contentPadding: EdgeInsets.fromLTRB(9.0, 8.0, 8.0, 8.0),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}