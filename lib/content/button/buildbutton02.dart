import 'package:barcodeapp/content/homepage.dart';
import 'package:barcodeapp/global.dart';
import 'package:flutter/material.dart';

class Buildbutton02 extends StatefulWidget {
  const Buildbutton02({Key? key}) : super(key: key);

  @override
  State<Buildbutton02> createState() => _Buildbutton02State();
}

class _Buildbutton02State extends State<Buildbutton02> {
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
          db.selectchioce = 2;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FxApp02(),
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
              '  2.Shipping',
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
