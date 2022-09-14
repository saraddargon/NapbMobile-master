// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_string_interpolations
import 'dart:async';
import 'dart:convert';
import 'package:barcodeapp/content/expacking/PackingList.dart';
import 'package:barcodeapp/content/expacking/packing.dart';
import 'package:barcodeapp/global.dart';
import 'package:barcodeapp/model/sqlmanament.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// # Model # //
import 'package:barcodeapp/model/PackingModel.dart';

// ignore: must_be_immutable
class PackingScanPD extends StatefulWidget {
  String tobj = "";
  //Packing({Key? key, required this.tobj}) : super(key: key);
  PackingScanPD({Key? key}) : super(key: key);

  @override
  PackingScanPDtate createState() => PackingScanPDtate();
}

class PackingScanPDtate extends State<PackingScanPD> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Sqlmanagement sqm = Sqlmanagement();
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
  String ScanTAG = "";
  String checkby = "";
  //String Exid2 = "";
  bool isChecked = false;
  bool isChecked2 = false;

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: Size(88, 36), //Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return Colors.blue;
  }

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
  String PartNo = "";
  final formatter = NumberFormat("###,###");
  int iQty = 0;
  int uQty = 0;
  int qtyNew = 0;
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
    if (dbs.exid() != '') {
      _fetchJobs(dbs.exid().toString());
      setState(() {
        sStatus = "";
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Export Packing Scan'),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red.shade200,
            ),
            onPressed: () {
              if (barcode != '') {
                //_showMyDialogClear(barcode);
              }
            },
          )
        ],
      ),
      body: Center(
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
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
                SizedBox(height: 10.00),
                Row(
                  children: <Widget>[
                    Text('Export ID : '),
                    Text(
                      dbs.exid(),
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                    Text('         Quantity :  '),
                    Text(
                      iQty.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.00),
                Row(
                  children: <Widget>[
                    Text('Part No : '),
                    Text(
                      PartNo,
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Print TAG : '),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        // print("sompong1");
                      },
                      child: Text(
                        'Print',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text('     ตะแกรง: '),
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ],
                ),
                // Row(
                //   children: <Widget>[
                //     Text(
                //       'PD TAG (Qty) : ',
                //       style: TextStyle(color: Colors.blue),
                //     ),
                //     Expanded(
                //       child: TextField(
                //         controller: TextEditingController(text: ScanTAG),
                //         keyboardType: TextInputType.text,
                //       ),
                //     ),
                //   ],
                // ),
                Text('Scan TAG (PD) : '),
                SizedBox(height: 5.0),
                TextField(
                  controller: TextEditingController(text: ScanTAG),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'Production TAG Scan...',
                    isDense: true, // Added this
                    enabled: false,
                    filled: true,
                    fillColor: Colors.yellow.shade200,
                    contentPadding: EdgeInsets.all(8), // Added this
                  ),
                  onSubmitted: (String value) {
                    ScanTAG = value;
                    getDataDisplay(value);
                  },
                ),
                SizedBox(height: 10.0),
                Text('PD Qty : '),
                SizedBox(height: 5.0),
                TextField(
                  controller: TextEditingController(text: uQty.toString()),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'Production TAG Scan...',
                    isDense: true, // Added this
                    enabled: false,
                    filled: true,
                    fillColor: Colors.amber.shade50,
                    contentPadding: EdgeInsets.all(8), // Added this
                  ),
                ),
                SizedBox(height: 5.0),
                //List View//
                MyPackingList(),
                //List Data//
              ],
            )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.save),
            label: 'Save Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_2,
              size: 30,
            ),
            label: 'Scan Barcode',
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
    if (barcode != "") {
      if (value == 'SCANQR') {
        value = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", false, ScanMode.DEFAULT);
      }
      // print("barcode Scan :" + value);
      Future.delayed(Duration(milliseconds: 500), () {
        // Do something
      });
      ScanTAG = value;
      // await _clearData();
      if (value != '-1') {
        setState(() {
          ScanTAG = value;
          //  sStatus = "Add Data Completed.";
          //  statusErr = false;
        });

        Future.delayed(Duration(milliseconds: 100), () {
          // Do something
        });

        await _CheckPTAG(barcode, ScanTAG);
        // await _fetchJobs(dbs.exid());
        ///////end//////////
      } else {
        setState(() {
          statusErr = true;
          sStatus = "PD TAG Invalid!";
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

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      statusErr = false;
      getDataDisplay("SCANQR");
    } else if (index == 2) {
      _clearData();
    } else if (index == 0) {
      //  createJobPost();
      _showMyDialogBackHome("");
    }
  }

  void showInSnackBar(String value) {
    // ignore: deprecated_member_use
    // _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  void setValueAsstCode1(String value) {
    if (value != '') {
      setState(() {
        // barcode = value;
      });
    }
  }

  Future<String> _clearData() async {
    setState(() {
      // barcode = "";
      statusErr = false;
      sStatus = "";
      checkby = "";
      //  iQty = 0;
      //  uQty = 0;
      qtyNew = 0;

      remark = "";
    });
    return "";
  }

  Future<void> _fetchJobs(String _value) async {
    if (_value != '') {
      //dbs.checkwifi();
      //////PD,PO17228088,46,46,1891T,1of5,41241038010N1,17102017
      if (true) {
        final jobsListAPIUrl = dbs.url + 'Export/ListTAG/' + _value;
        final response = await http.get(Uri.parse(jobsListAPIUrl));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          List<ExportListID> jsb =
              jsonResponse.map((job) => ExportListID.fromJson(job)).toList();
          jsb.forEach((element) {
            setState(() {
              statusErr = false;
              sStatus = "";
              PartNo = element.pPartNo;
              barcode = element.pListNo.toString() +
                  ',' +
                  element.pExportNo +
                  ',' +
                  element.pOrderNo +
                  ',' +
                  element.pPartNo +
                  ',' +
                  element.pCustItem +
                  ',' +
                  element.pQty.toString() +
                  ',' +
                  element.pid.toString();
              // ScanTAG = barcode;

              iQty = element.pQty;
            });
          });
          if (jsb.isEmpty) {
            // _showMyDialogErr(_value);
          }
        } else {
          //throw Exception('Failed to load Data from API');
          setState(() {
            statusErr = true;
            sStatus = "Error Production TAG!!";
          });
        }
      }
    }
  }

  Future<void> _CheckPTAG(String pTag, String cTag) async {
    if (pTag != '') {
      String pid = dbs.exid();
      String sUser = dbs.users;
      var body = jsonEncode({
        'pTAG': '$pTag',
        'cTAG': '$cTag',
        'pStatus': 'Check',
        'pid': '$pid',
        'sUser': '$sUser'
      });
      final response = await http.post(
        Uri.parse(dbs.url + 'Export/PostCheckEx01'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      sStatus = "";
      if (response.statusCode == 200) {
        setState(() {
          statusErr = false;
          sStatus = "Add Successfuly.";
        });
        var snackBar = SnackBar(
          content: Text('Successfuly'),
          backgroundColor: Colors.green.shade200,
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final res = jsonDecode(response.body);
        final _mess = JException.fromJson(res);
        // getErr = response.body.split(':');
        _showMyDialogErr(_mess.mMess);
        setState(() {
          statusErr = true;
          sStatus = sStatus = _mess.mMess;
        });
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
            'Error : ' + dbs.exid(),
            style: TextStyle(color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  accCode1,
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
                  ScanTAG = "";
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

                // await createJobPostBack();
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

  Future<void> _showMyDialogBackHome(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Back to Export Page?',
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  'ต้องการกลับไปหน้า Export หรือไม่?',
                  style: TextStyle(color: Colors.pink),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                // Navigator.of(context).pop();
                // await upDateRowSqInsert();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Packing(),
                    ));
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
