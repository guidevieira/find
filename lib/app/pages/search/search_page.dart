import 'dart:convert';

import 'package:Find/app/components/Card/card.dart';
import 'package:Find/app/components/CustomTextField/customTextField.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List charts = [];
  void getHttp(name) async {
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
          "http://gateway.marvel.com/v1/public/characters?nameStartsWith=$name&ts=$ts&apikey=$public&hash=$digest");

      print(response.data['data']);

      charts = response.data['data']['results'];
      setState(() {});
    } catch (e) {
      charts = [];
      print(e);
    }
    setState(() {
      loadding = false;
    });
  }

  void _showSheetWithoutList(image, name, description) {
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

  bool loadding = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "BACK",
            style: GoogleFonts.montserrat(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomTextField(
                hint: 'Search name',
                prefix: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                obscure: false,
                onChanged: (value) {
                  getHttp(value);
                },
                enabled: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Text(
                    "Searched",
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            !loadding
                ? charts.length != 0
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
                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
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
                    : Text("EMPTY")
                : Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
          ],
        ));
  }
}
