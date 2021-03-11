import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardChar extends StatelessWidget {
  final item;
  const CardChar({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        elevation: 10,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(
                        "${item['thumbnail']['path']}.${item['thumbnail']['extension']}"),
                    fit: BoxFit.fill,
                  )),
              width: MediaQuery.of(context).size.width * .35,
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .42,
                        child: Text(
                          "${item['name']}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        " ",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                            fontSize: 17,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  item['description'] != null && item['description'] != ""
                      ? Text(
                          "${item['description']}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .04,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "More Infos",
                        style: GoogleFonts.montserrat(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      )
                    ],
                  ),
                ],
              ),
            )),
          ],
        ));
  }
}
