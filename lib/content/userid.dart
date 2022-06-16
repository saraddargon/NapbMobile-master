// ignore_for_file: prefer_final_fields, unnecessary_string_interpolations,prefer_const_constructors, annotate_overrides, library_private_types_in_public_api, prefer_const_constructors_in_immutables, override_on_non_overriding_member, unused_field
import 'package:barcodeapp/content/mainpage.dart';
import 'package:barcodeapp/global.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'homepage.dart';

class UserID extends StatefulWidget {
  UserID({Key? key}) : super(key: key);

  @override
  State<UserID> createState() => SuserIDState();
}

class SuserIDState extends State<UserID> {
  DBData db = DBData();
  @override
  final TextEditingController _checkNo = TextEditingController();
  final TextEditingController _user = TextEditingController();
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Insert User ID.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                )
              ]),
          height: 60,
          child: TextField(
            controller: _checkNo,
            //autofocus: true,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 12),
              enabled: true,
              hintText: "UserID..",
              hintStyle: TextStyle(
                color: Colors.black38,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Icon(
                Icons.receipt,
                color: Color(0xff5ac18e),
              ),
            ),
            onSubmitted: (String value) async {
              setState(() {
                _checkNo.text = value;
                db.users = value;
                GetStorage box = GetStorage();
                box.write("UserID", value);
              });
              // dbs.checkNo = "";
              // await getCheckNo(context, _checkNo.text);
            },
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          // height: 80,
          // ignore: deprecated_member_use
          child: RaisedButton(
            elevation: 5,
            onPressed: () {
              if (_checkNo.text != '') {
                //Codeing
                db.users = _checkNo.text;
                GetStorage box = GetStorage();
                box.write("UserID", _checkNo.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ));
              }
            },
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.blueGrey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                Text(
                  '  Enter',
                  style: TextStyle(
                    color: Color(0xff5ac18e),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
