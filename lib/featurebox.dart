import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

class featurebox extends StatelessWidget {
  const featurebox(this.color, this.headertext, this.destext, {super.key});
  final Color color;
  final String headertext, destext;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 15),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                headertext,
                style: GoogleFonts.playfairDisplay(
                    color: pallete.blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                destext,
                style: GoogleFonts.playfairDisplay(
                    color: pallete.blackColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
