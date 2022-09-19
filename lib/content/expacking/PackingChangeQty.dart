// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
//import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:barcodeapp/content/mainpage.dart';
import 'package:barcodeapp/global.dart';
import 'package:barcodeapp/model/sqlmanament.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:barcodeapp/model/PackingModel.dart';

// ignore: must_be_immutable
class PackingChangeQty extends StatefulWidget {
  String tobj = "";
  String tobj2 = "";
  // const PackingChangeQty({super.key, required this.tobj});
  PackingChangeQty({super.key, required this.tobj, required this.tobj2});

  @override
  PackingChangeQtyState createState() => PackingChangeQtyState();
}

class PackingChangeQtyState extends State<PackingChangeQty> {
  final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    elevation: 5.0,
    foregroundColor: Colors.white,
    padding: EdgeInsets.all(20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Sqlmanagement sqm = Sqlmanagement();
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
  String PDTag = "";
  String aName = "";
  String tName = "";
  String dName = "";
  String aDate = "";
  bool aUse = false;
  bool aNotUse = false;
  bool aDamage = false;
  bool aLoss = false;
  bool aTransfer = false;
  bool lOK = false;
  bool lNO = false;
  bool lstricker = false;
  String checkby = "";
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87, minimumSize: Size(88, 36), //Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  final snackBar = const SnackBar(
    content: Text(
      'save data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Color(0xffE5FFCC),
  );
  final snackBarBack = const SnackBar(
    content: Text(
      'clear data successfully.',
      style: TextStyle(color: Colors.black),
    ),
    duration: Duration(seconds: 1),
    backgroundColor: Colors.orange,
  );
  String remark = "";
  final formatter = NumberFormat("###,###");
  int iQty = 0;
  int uQty = 0;
  int qtyNew = 0;
  String LotNo = "";
  String sStatus = "";

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Save Data',
      style: optionStyle,
    ),
    Text(
      'Index 1: Scan Barcode',
      style: optionStyle,
    ),
    Text(
      'Index 2: Clear',
      style: optionStyle,
    ),
  ];

  @override
  initState() {
    super.initState();
    barcode = widget.tobj;
    PDTag = widget.tobj2;
    if (barcode != '') {
      //_clearData();
      _fetchJobs(PDTag);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Packing Change Quantity'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red.shade200,
            ),
            onPressed: () {
              if (barcode != '') {
                // _showMyDialogClear(barcode);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Form(
              child: ListView(
            children: <Widget>[
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    sStatus,
                    style: TextStyle(
                      color: statusErr ? Colors.red : Colors.green,
                    ),
                  )
                ],
              ),
              TextFormField(
                controller: TextEditingController(text: barcode),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: Icon(
                    Icons.sticky_note_2,
                    color: Colors.orange,
                    size: 20.0,
                  ),
                  hintText: 'List Export TAG:',
                  labelText: 'List Export TAG:',
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (String value) {
                  barcode = value;
                  // getDataDisplay(value);
                },
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: PDTag),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 20.0,
                  ),
                  labelText: 'PD TAG :',
                ),
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: aName),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 20.0,
                  ),
                  labelText: 'Part No. :',
                ),
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: LotNo),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 20.0,
                  ),
                  labelText: 'Lot No. :',
                ),
              ),
              SizedBox(height: 5.00),
              TextField(
                controller: TextEditingController(text: iQty.toString()),
                maxLines: null,
                readOnly: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: false,
                  icon: Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 20.0,
                  ),
                  labelText: 'Qty OfTAG :',
                ),
              ),
              SizedBox(height: 15.00),
              TextField(
                controller: TextEditingController(text: uQty.toString()),
                maxLines: 1,
                readOnly: false,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: true,
                  fillColor: Colors.yellow.shade200,
                  icon: Icon(
                    Icons.description,
                    color: Colors.pink.shade300,
                    size: 20.0,
                  ),
                  labelText: 'Input Qty :',
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  setState(() {
                    uQty = int.parse(value);
                    //  print('uQty=>' + uQty.toString());
                  });
                },
              ),

              //Step Test
              //  TextField(
              //     controller: TextEditingController(text: dbs.exid()),
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'Export (id)',
              //       isDense: true, // Added this
              //       enabled: false,
              //       contentPadding: EdgeInsets.all(8), // Added this
              //     )),

              //End Test
            ],
          )),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save Data',
            backgroundColor: Colors.orangeAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.clear_all),
            label: 'Clear',
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 16),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[200],
        onTap: _onItemTapped,
      ),
    );
  }

/////////////////////////////////Function//////////////////////////////////
  Future<void> getDataDisplay(String value) async {
    if (dbs.checkNo != "" && dbs.checkNo != "Error") {
      if (value == 'SCANQR') {
        value = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", false, ScanMode.DEFAULT);
      }
      // print("barcode Scan :" + value);
      Future.delayed(Duration(milliseconds: 1000), () {
        // Do something
      });

      await _clearData();
      if (value != '-1') {
        setState(() {
          barcode = value;
          sStatus = "Checked Completed.";
          statusErr = false;
        });
        barcode = value;

        Future.delayed(Duration(milliseconds: 500), () {
          // Do something
        });

        await _fetchJobs(value);

        ///////end//////////
      } else {
        setState(() {
          statusErr = true;
          sStatus = "Barcode Invalid!";
        });
      }
      //after read.

    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error List No Empty!!";
      });
    }
  }

  void _onItemTapped(int index) async {
    _selectedIndex = index;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      statusErr = false;
      // getDataDisplay("SCANQR");
      //Save Data//
      _showMyDialogSave("");
    } else if (index == 2) {
      //  _clearData();
      // Navigator.pop(context);
    } else if (index == 0) {
      //  createJobPost();
      // _showMyDialogBackHome("");
      Navigator.pop(context, true);
    }
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    //_scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  void setValueAsstCode1(String value) {
    if (value != '') {
      setState(() {
        barcode = value;
      });
    }
  }

  Future<String> _clearData() async {
    setState(() {
      barcode = "";
      statusErr = false;
      sStatus = "";
      aName = "";
      dName = "";
      tName = "";
      aDate = "";
      checkby = "";
      iQty = 0;
      qtyNew = 0;
      aUse = false;
      aNotUse = false;
      aDamage = false;
      aLoss = false;
      aTransfer = false;
      lOK = false;
      lNO = false;
      lstricker = false;
      remark = "";
    });
    return "";
  }

  Future<void> _fetchJobs(String _value) async {
    if (_value != "") {
      var PdATA = _value.split(',');
      if (PdATA.length == 8) {
        setState(() {
          aName = PdATA[6];
          LotNo = PdATA[4];
          iQty = int.parse(PdATA[2]);
          uQty = int.parse(PdATA[2]);
        });
      } else {}
    }
  }

  Future<void> _SaveData(String _value) async {
    if (uQty != 0) {
      String pid = dbs.exid();
      String sUser = dbs.users;
      String uQ = uQty.toString();
      var body = jsonEncode({
        'pTAG': '$barcode',
        'cTAG': '$PDTag',
        'pStatus': '$uQ',
        'pid': '$pid',
        'sUser': '$sUser'
      });
      if (true) {
        final jobsListAPIUrl = dbs.url + 'Export/PostCheckEx02';
        // print(body);
        final response = await http.post(
          Uri.parse(jobsListAPIUrl),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          var snackBar = SnackBar(
            content: Text('Update Successfuly'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          );
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pop();
        } else {
          final res = jsonDecode(response.body);
          final _mess = JException.fromJson(res);
          if (!mounted) return;
          Navigator.of(context).pop();
          //throw Exception('Failed to load Data from API');
          setState(() {
            statusErr = true;
            sStatus = _mess.mMess.toString();
          });
        }
      }
    }
  }

  //////////////////////////End Fuction/////////////////////
  Future<void> _showMyDialogErr(String accCode1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'AssetCode Can not Found!!' + accCode1,
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  'ไม่มีเลข Fixed Asset Code นี้ใน Check List.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  barcode = accCode1;
                });
              },
            ),
            /*
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              
            ),
            */
          ],
        );
      },
    );
  }

  //Clear//
  Future<void> _showMyDialogClear(String accCode1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'UnChecked \n' + accCode1,
            style: TextStyle(color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  'ยกเลิกการ Checked.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                // ignore: deprecated_member_use
                Navigator.of(context).pop();

                //  await createJobPostBack();
                await _fetchJobs(accCode1);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogSave(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Do you want Save Value?',
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Update Qty =' + uQty.toString(),
                  style: TextStyle(color: Colors.blue),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                await _SaveData("");
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
