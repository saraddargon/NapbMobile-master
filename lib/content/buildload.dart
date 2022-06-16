// ignore_for_file: prefer_const_constructors_in_immutables, camel_case_types

import 'package:flutter/material.dart';

class BuildButtonLoad extends StatelessWidget {
  BuildButtonLoad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          'Infomation Data support Andriod 10.0..',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
