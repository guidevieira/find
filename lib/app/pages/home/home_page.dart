import 'dart:convert';

import 'package:Find/app/components/Card/card.dart';
import 'package:Find/app/components/toggle/toggle.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHttp();
    init();
  }

  List<String> recent = [];
  bool loadding = false;

  init() async {
    try {
      final SharedPreferences prefs = await _prefs;

      recent = prefs.getStringList("lasts");
      if (recent == null) {
        recent = [];
      }
      ;
    } catch (e) {
      recent = [];
    }
  }

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void getHttp() async {
    setState(() {
      loadding = true;
    });
    try {
      final ts = DateTime.now().millisecondsSinceEpoch;
      var private = "58bb867e7a5b6f9b13d7cf500a56daa95d5ea40d";
      var public = "22154146f40051b28fb6da07f766eb61";
      var bytes = utf8.encode("$ts$private$public"); // data being hashed

      var digest = md5.convert(bytes);
      print("Digest as hex string: $digest");

      Response response = await Dio().get(
          "http://gateway.marvel.com/v1/public/characters?$order&ts=$ts&apikey=$public&hash=$digest");

      print(response.data['data']);

      charts = response.data['data']['results'];
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      loadding = false;
    });
  }

  getHttpName(name) async {
    try {
      final ts = DateTime.now().millisecondsSinceEpoch;
      var private = "58bb867e7a5b6f9b13d7cf500a56daa95d5ea40d";
      var public = "22154146f40051b28fb6da07f766eb61";
      var bytes = utf8.encode("$ts$private$public"); // data being hashed

      var digest = md5.convert(bytes);
      print("Digest as hex string: $digest");

      Response response = await Dio().get(
          "http://gateway.marvel.com/v1/public/characters?name=$name&ts=$ts&apikey=$public&hash=$digest");

      return response.data['data']['results'];
    } catch (e) {
      print(e);
    }
  }

  String order = "&orderBy=name";

  void _showSheetWithoutList(image, name, description) async {
    final SharedPreferences prefs = await _prefs;
    recent.add(name);
    prefs.setStringList('lasts', recent);
    print(prefs.getStringList('lasts'));

    showStickyFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.9,
      maxHeight: .9,
      headerHeight: 400,
      context: context,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      headerBuilder: (context, offset) {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(offset == 0.8 ? 0 : 40),
                topRight: Radius.circular(offset == 0.8 ? 0 : 40),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(15.0, 20.0),
                      blurRadius: 20.0,
                    )
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: NetworkImage("$image"),
                    fit: BoxFit.fill,
                  )),
            ));
      },
      builder: (context, offset) {
        return SliverChildListDelegate(
          _getChildren(offset, name, description, isShowPosition: false),
        );
      },
      anchors: [.2, 0.5, .8],
    );
  }

  List<Widget> _getChildren(double bottomSheetOffset, name, description,
          {bool isShowPosition}) =>
      <Widget>[
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                      Icon(Icons.download_rounded),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                description != null
                    ? Text(
                        description,
                        style: GoogleFonts.montserrat(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      )
                    : Container(),
              ],
            ),
          ),
        )
      ];

  List<dynamic> charts = [];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Center(child: Image.asset("images/logo_black.png")),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 25,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/search");
                }),
          )
        ],
      ),
      body: !loadding
          ? Column(
              children: [
                ToggleBar(
                    labels: ["A-Z", "Z-A", "Lasted"],
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    initValue: index,
                    backgroundBorder:
                        Border.all(color: Colors.black, width: 1.0),
                    selectedTabColor: Color(0xffF70D0E),
                    labelTextStyle: GoogleFonts.montserrat(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    onSelectionUpdated: (index_select) async {
                      if (index_select == 0) {
                        order = "&orderBy=name";

                        setState(() {
                          index = 0;
                        });
                        getHttp();
                      }
                      if (index_select == 1) {
                        order = "&orderBy=-name";

                        setState(() {
                          index = 1;
                        });
                        getHttp();
                      }
                      if (index_select == 2) {
                        try {
                          setState(() {
                            loadding = true;
                            index = 2;
                          });
                          charts = [];
                          final SharedPreferences prefs = await _prefs;
                          if (prefs.getStringList("lasts") != null) {
                            recent = prefs.getStringList("lasts");
                          }
                          recent.forEach((element) async {
                            var char = await getHttpName(element);
                            charts.add(char[0]);
                            setState(() {
                              loadding = false;
                            });
                          });
                          setState(() {
                            loadding = false;
                          });
                        } catch (e) {
                          print(e);
                          charts = [];
                          setState(() {
                            loadding = false;
                          });
                        }
                      }
                    }),
                SizedBox(
                  height: 15,
                ),
                index == 2 && charts.length != 0
                    ? GestureDetector(
                        onTap: () async {
                          charts = [];
                          final SharedPreferences prefs = await _prefs;
                          prefs.remove("lasts");
                          recent = [];
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffF70D0E),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              )),
                          width: 100,
                          height: 35,
                          child: Center(
                              child: Text(
                            "Limpar",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: 15,
                ),
                charts.length != 0
                    ? Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: charts.map((item) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .28,
                                  width: MediaQuery.of(context).size.width * .9,
                                  child: GestureDetector(
                                    onTap: () {
                                      _showSheetWithoutList(
                                          "${item['thumbnail']['path']}.${item['thumbnail']['extension']}",
                                          item['name'],
                                          item['description']);
                                    },
                                    child: CardChar(
                                      item: item,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                    : Center(
                        child: Text("EMPTY"),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
