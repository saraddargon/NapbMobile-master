// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, unnecessary_string_interpolations
import 'dart:async';
import 'dart:convert';
import 'package:barcodeapp/content/expacking/PackingChangeQty.dart';
import 'package:barcodeapp/global.dart';
import 'package:barcodeapp/model/sqlmanament.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// # Model # //
import 'package:barcodeapp/model/PackingModel.dart';

// ignore: must_be_immutable
class PackingShipping2 extends StatefulWidget {
  String tobj = "";
  //Packing({Key? key, required this.tobj}) : super(key: key);
  PackingShipping2({Key? key, required this.tobj}) : super(key: key);

  @override
  PackingShipping2State createState() => PackingShipping2State();
}

class PackingShipping2State extends State<PackingShipping2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Sqlmanagement sqm = Sqlmanagement();
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
  String ScanTAG = "";
  String checkby = "";
  bool isChecked = false;
  bool isChecked2 = false;
  bool fixQty = false;
  ////////////////////////////

  List<ExShipingView> exviewS0 = <ExShipingView>[];

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black87, minimumSize: Size(88, 36), //Size(88, 36),
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
  String Invoice = "";

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
    Invoice = widget.tobj;
    barcode = Invoice;
    if (Invoice != '') {
      _ExportPDA01(Invoice);
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
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: Column(
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
              SizedBox(height: 5.00),
              Row(
                children: <Widget>[
                  Text('Export No. : '),
                  Text(
                    Invoice,
                    style: TextStyle(color: Colors.blue.shade900),
                  ),
                  SizedBox(height: 5.00),
                  Text('         Quantity :  '),
                  Text(
                    iQty.toString() + " of " + uQty.toString(),
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.00),
              Row(children: const <Widget>[
                Text('Scan QR : '),
              ]),
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
              SizedBox(height: 5.0),
              //List View//
              _jobsListView(exviewS0),
              //List Data//
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Back',
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
            icon: Icon(Icons.refresh),
            label: 'Refresh',
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
  SizedBox _jobsListView(List<ExShipingView> data) {
    return SizedBox(
      height: 460,
      child: DataTable2(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.black),
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          headingRowHeight: 24,
          dataTextStyle: TextStyle(color: Colors.black87),
          columns: const [
            DataColumn2(
              label: Text(
                'Pallet',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'List No.',
                style: TextStyle(color: Colors.white),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'Part No.',
                style: TextStyle(color: Colors.white),
              ),
              // size: ColumnSize.L,
            ),
            DataColumn2(
              label: Text(
                'Qty',
                style: TextStyle(color: Colors.white),
              ),
              size: ColumnSize.S,
              numeric: true,
            ),
            DataColumn2(
              label: Text(
                'ofTAG',
                style: TextStyle(color: Colors.white),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'AC',
                style: TextStyle(color: Colors.white),
              ),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              numeric: true,
            ),
          ],
          rows: List<DataRow>.generate(
            data.length,
            (index) => DataRow(cells: [
              DataCell(Text(data[index].pPallet.toString())),
              DataCell(Text(data[index].pListNo.toString())),
              DataCell(Text(data[index].pPartNo.toString())),
              DataCell(Text(data[index].pQty.toString())),
              DataCell(Text(data[index].pOfTAG.toString())),
              DataCell(Text(data[index].pAC.toString())),
              DataCell(ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // foreground
                ),
                onPressed: () {
                  // print(data[index].pid.toString());
                  _showMyDialogDelete(data[index].pid.toString());
                },
                child: Icon(Icons.delete_forever),
              ))
            ]),
          )),
    );
  }

  List<ExListView> getExListView() {
    return [
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
      ExListView(pQty: 10, pid: 23456, pPartNo: '441222122212', pPDTAG: ''),
    ];
  }

  Future<void> getDataDisplay(String value) async {
    if (Invoice != "") {
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
        if (fixQty) {
          if (!mounted) return;
          await _SaveData(ScanTAG);
          // print('sss');
        } else {
          // await _CheckPTAG(barcode, ScanTAG);
          await _SaveData(ScanTAG);
          await _ExportPDA01(Invoice);
        }
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
      ScanTAG = "";
      getDataDisplay("SCANQR");
    } else if (index == 2) {
      // _clearData();
      _ExportPDA01(barcode);
    } else if (index == 0) {
      //  createJobPost();
      Navigator.of(context).pop();
      // _showMyDialogSave("");
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
      ScanTAG = "";
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
              Invoice = element.pInvoice;
              barcode = element.pListNo.toInt().toString() +
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
              iQty = element.pQty;
            });
          });
          _ExportPDA01(barcode);
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

  Future<void> _ExportPDA01(String _Invoice) async {
    if (_Invoice != '') {
      exviewS0.clear();
      var body = jsonEncode({
        'pTAG': '',
        'cTAG': '',
        'pStatus': '$_Invoice',
        'pid': '',
        'sUser': ''
      });
      if (true) {
        final jobsListAPIUrl = dbs.url + 'Export/ListShip';
        // print(body);
        final response = await http.post(
          Uri.parse(jobsListAPIUrl),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          // print(response.body);
          uQty = 0;
          iQty = 0;
          exviewS0 =
              jsonResponse.map((job) => ExShipingView.fromJson(job)).toList();
          exviewS0.forEach((element) {
            setState(() {
              uQty = element.pAC;
              iQty += 1;
            });
          });
        } else {
          //throw Exception('Failed to load Data from API');
          setState(() {
            statusErr = true;
            sStatus = "Error Load TAG!!";
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
          sStatus = "Successfuly.";
        });
        var snackBar = SnackBar(
          content: Text('Successfuly'),
          backgroundColor: Colors.green,
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

  Future<void> _DeleteRec(String _id) async {
    if (_id != '') {
      // String pid = dbs.exid();
      String sUser = dbs.users;
      var body = jsonEncode({
        'pTAG': '',
        'cTAG': '',
        'pStatus': '$Invoice',
        'pid': '$_id',
        'sUser': '$sUser'
      });
      final response = await http.post(
        Uri.parse(dbs.url + 'Export/ListShipDelete'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      sStatus = "";
      if (response.statusCode == 200) {
        setState(() {
          statusErr = false;
          sStatus = "Delete Successfuly.";
          _ExportPDA01(Invoice);
        });
        var snackBar = SnackBar(
          content: Text('Delete Successfuly'),
          backgroundColor: Colors.red,
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

  Future<void> _PrintAuto(String _id) async {
    if (_id != '') {
      String pid = dbs.exid();
      String sUser = dbs.users;
      var body = jsonEncode({
        'pTAG': '',
        'cTAG': '',
        'pStatus': 'Check',
        'pid': '$_id',
        'sUser': '$sUser'
      });
      final response = await http.post(
        Uri.parse(dbs.url + 'Export/PrintEx'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      sStatus = "";
      if (response.statusCode == 200) {
        setState(() {
          statusErr = false;
          sStatus = "Send Successfuly.";
          _ExportPDA01(barcode);
        });
        var snackBar = SnackBar(
          content: Text(
            'Send to Print Successfuly',
            style: TextStyle(color: Colors.amber.shade900),
          ),
          backgroundColor: Colors.lightBlue.shade100,
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

  Future<void> _SaveData(String _id) async {
    if (_id != '') {
      String sUser = dbs.users;
      var body = jsonEncode({
        'pTAG': '$_id',
        'cTAG': '',
        'pStatus': '$Invoice',
        'pid': '',
        'sUser': '$sUser'
      });
      final response = await http.post(
        Uri.parse(dbs.url + 'Export/ListShipConfirm'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      sStatus = "";
      if (response.statusCode == 200) {
        setState(() {
          statusErr = false;
          sStatus = "Save Data Successfuly.";
          //_ExportPDA01(barcode);
        });
        var snackBar = SnackBar(
          content: Text(
            'Save Data Successfuly',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.green,
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

  //Clear// Show Dialog Box//
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
                  '??????????????????????????? Checked.',
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

  Future<void> _showMyDialogSave(String _ckNo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Data :' + Invoice,
              style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  '??????????????????????????????????????? Packing ????????? ??????????????????????',
                  style: TextStyle(color: Colors.green),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _SaveData(dbs.exid().toString());
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

  Future<void> _showMyDialogDelete(String _id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Record : ' + _id,
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  '??????????????????????????????????????????????????????????????????????????????????????? ????????????????????? ?',
                  style: TextStyle(color: Colors.red),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _DeleteRec(_id);
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

  Future<void> _showMyDialogPrint() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Print Document : ' + Invoice,
              style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text(
                  '???????????????????????????????????????????????????????????????????????????????????????????????? ????????????????????? ?',
                  style: TextStyle(color: Colors.blue),
                ),

                ///Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _PrintAuto(dbs.exid());
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
