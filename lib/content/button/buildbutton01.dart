import 'package:barcodeapp/content/expacking/packing.dart';
import 'package:barcodeapp/content/homepage.dart';
import 'package:barcodeapp/global.dart';
import 'package:flutter/material.dart';

class Buildbutton01 extends StatefulWidget {
  const Buildbutton01({Key? key}) : super(key: key);

  @override
  State<Buildbutton01> createState() => _Buildbutton01State();
}

class _Buildbutton01State extends State<Buildbutton01> {
  DBData db = DBData();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      // height: 80,
      // ignore: deprecated_member_use
      child: RaisedButton(
        elevation: 5,
        onPressed: () {
          db.selectchioce = 1;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Packing(),
              ));
        },
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: const Color.fromARGB(255, 7, 55, 78),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              '  1.Packing',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
