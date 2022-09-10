// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'package:barcodeapp/content/mainpage.dart';
import 'package:barcodeapp/global.dart';
import 'package:barcodeapp/model/sqlmanament.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Job {
  final String assetCode;
  final String assetName;
  final String thaiName;
  final String purchaseDate;
  final String assetLocation;
  final int inputQty;
  final String aUse;
  final String aNotUse;
  final String aDamage;
  final String aTransfer;
  final String aLoss;
  final String lOK;
  final String lNO;
  final String lNotStick;
  final String remark;
  final String dept;
  final String checkby;
  final int qtyNew;

  Job(
      {required this.assetCode,
      required this.assetName,
      required this.thaiName,
      required this.purchaseDate,
      required this.assetLocation,
      required this.inputQty,
      required this.aUse,
      required this.aNotUse,
      required this.aDamage,
      required this.aTransfer,
      required this.aLoss,
      required this.lOK,
      required this.lNO,
      required this.lNotStick,
      required this.remark,
      required this.dept,
      required this.checkby,
      required this.qtyNew});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      assetCode: json['AssetCode'],
      assetName: json['AssetName'],
      thaiName: json['ThaiName'],
      purchaseDate: json['PurchaseDate'],
      assetLocation: json['AssetLocation'],
      inputQty: json['InputQty'],
      aUse: json['AUse'],
      aNotUse: json['ANotUse'],
      aDamage: json['ADamage'],
      aTransfer: json['ATransfer'],
      aLoss: json['ALoss'],
      lOK: json['LOK'],
      lNO: json['LNO'],
      lNotStick: json['LNotStick'],
      remark: json['Remark'],
      dept: json['Dept'],
      checkby: json['CheckBy'],
      qtyNew: json['QtyNew'],
    );
  }
}

class JobPost {
  final String pcheckNo;
  final String passetCode;
  final int pinputQty;
  final String paUse;
  final String paNotUse;
  final String paDamage;
  final String paTransfer;
  final String paLoss;
  final String plOK;
  final String plNO;
  final String plNotStick;
  final String premark;

  JobPost(
      {required this.pcheckNo,
      required this.passetCode,
      required this.pinputQty,
      required this.paUse,
      required this.paNotUse,
      required this.paDamage,
      required this.paTransfer,
      required this.paLoss,
      required this.plOK,
      required this.plNO,
      required this.plNotStick,
      required this.premark});
  factory JobPost.fromJson(Map<String, dynamic> json) {
    return JobPost(
      pcheckNo: json['CheckNo'],
      passetCode: json['AssetCode'],
      pinputQty: json['InputQty'],
      paUse: json['AUse'],
      paNotUse: json['ANotUse'],
      paDamage: json['ADamage'],
      paTransfer: json['ATransfer'],
      paLoss: json['ALoss'],
      plOK: json['LOK'],
      plNO: json['LNO'],
      plNotStick: json['LNotStick'],
      premark: json['Remark'],
    );
  }
}

// ignore: must_be_immutable
class Packing extends StatefulWidget {
  String tobj = "";
  //Packing({Key? key, required this.tobj}) : super(key: key);
  Packing({Key? key}) : super(key: key);

  @override
  SPackingState createState() => SPackingState();
}

class SPackingState extends State<Packing> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Sqlmanagement sqm = Sqlmanagement();
  DBData dbs = DBData();
  bool statusErr = false;
  String barcode = "";
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
    primary: Colors.black87,
    minimumSize: Size(88, 36), //Size(88, 36),
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
    barcode = widget.tobj;
    if (barcode != '') {
      //_clearData();
      _fetchJobs(barcode);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Export Packing '),
        backgroundColor: Colors.blueGrey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.remove_circle,
              color: Colors.red.shade200,
            ),
            onPressed: () {
              if (barcode != '') {
                _showMyDialogClear(barcode);
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
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: true,
                  icon: Icon(
                    Icons.sticky_note_2,
                    color: Colors.orange,
                    size: 30.0,
                  ),
                  hintText: 'Scan QR List?',
                  labelText: 'Scan QR Code :',
                ),
                keyboardType: TextInputType.text,
                onFieldSubmitted: (String value) {
                  barcode = value;
                  getDataDisplay(value);
                },
              ),
              SizedBox(height: 20.00),
              TextField(
                controller: TextEditingController(text: aName),
                maxLines: null,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  //fillColor: Colors.green.shade50,
                  border: UnderlineInputBorder(),
                  filled: true,
                  enabled: true,
                  icon: Icon(
                    Icons.description,
                    color: Color(0xff5ac18e),
                    size: 30.0,
                  ),
                  labelText: 'Group (small) :',
                ),
              ),
              SizedBox(height: 20.00),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
                onPressed: () {
                  print("sompong1");
                },
                child: Text(
                  'Next Step',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              //Step Test

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
    if (dbs.checkNo != "" && dbs.checkNo != "Error") {
      if (value == 'SCANQR') {
        value = await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", true, ScanMode.QR);
      }
      Future.delayed(Duration(milliseconds: 1000), () {
        // Do something
      });

      // if (_value == 'SCANQR') {
      //   _value = '';
      // }
      // print(_value);

      if (value != '-1') {
        setState(() {
          barcode = value;
          sStatus = "Checked Completed.";
          statusErr = false;
        });
        barcode = value;
        await _clearData();
        Future.delayed(Duration(milliseconds: 500), () {
          // Do something
        });

        //  await _fetchJobs(_value);

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
        sStatus = "Error Check No Empty!!";
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
    _scaffoldKey.currentState?.showSnackBar(snackBar);
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
    if (dbs.checkNo != '' && _value != '') {
      dbs.checkwifi();
      // dbs.wifis = 'No';
      if (dbs.wifis == "Yes") {
        final jobsListAPIUrl =
            dbs.url + 'api/CheckNoAd/' + dbs.checkNo + ',' + _value;
        final response = await http.get(Uri.parse(jobsListAPIUrl));

        if (response.statusCode == 200) {
          List jsonResponse = json.decode(response.body);
          List<Job> jsb =
              jsonResponse.map((job) => new Job.fromJson(job)).toList();
          jsb.forEach((element) {
            barcode = element.assetCode;
            aName = element.assetName;
            dName = element.dept;
            tName = element.thaiName;
            aName = aName + '\n' + tName;
            aDate = element.purchaseDate;
            iQty = element.inputQty;
            qtyNew = element.qtyNew;
            aUse = false;
            aNotUse = false;
            aDamage = false;
            aLoss = false;
            aTransfer = false;
            lOK = false;
            lNO = false;
            lstricker = false;
            remark = element.remark;
            aUse = element.aUse == 'P' ? true : false;
            aNotUse = element.aNotUse == 'P' ? true : false;
            aDamage = element.aDamage == 'P' ? true : false;
            aTransfer = element.aTransfer == 'P' ? true : false;
            aLoss = element.aLoss == 'P' ? true : false;
            lOK = element.lOK == 'P' ? true : false;
            lNO = element.lNO == 'P' ? true : false;
            lstricker = element.lNotStick == 'P' ? true : false;

            if (element.checkby == '') {
              setState(() {
                aUse = true;
                lOK = true;
              });
            } else {
              setState(() {
                statusErr = false;
                sStatus = "Checked already!";
              });
            }
          });
          if (jsb.isEmpty) {
            _showMyDialogErr(_value);
          }
        } else {
          //throw Exception('Failed to load Data from API');
          setState(() {
            statusErr = true;
            sStatus = "Error Check No or Asset Code Empty!!";
          });
        }
      } else {
        //offline//
        List<SfxAsset> sq = await sqm.getTemp2Item(dbs.checkNo, _value);
        // print('test wifi => ' + sq.length.toString());
        if (sq.length > 0) {
          sq.forEach((element) {
            barcode = element.assetCode;
            aName = element.assetName;
            dName = element.dept;
            tName = element.thaiName;
            aName = aName + '\n' + tName;
            aDate = element.checkDate;
            iQty = element.inputQty;
            qtyNew = element.qtyNew;
            aUse = false;
            aNotUse = false;
            aDamage = false;
            aLoss = false;
            aTransfer = false;
            lOK = false;
            lNO = false;
            lstricker = false;
            remark = element.remark;
            aUse = element.aUse == 'P' ? true : false;
            aNotUse = element.aNotUse == 'P' ? true : false;
            aDamage = element.aDamage == 'P' ? true : false;
            aTransfer = element.aTransfer == 'P' ? true : false;
            aLoss = element.aLoss == 'P' ? true : false;
            lOK = element.lOK == 'P' ? true : false;
            lNO = element.lNO == 'P' ? true : false;
            lstricker = element.lNotStick == 'P' ? true : false;

            if (element.checkPoint == '') {
              setState(() {
                aUse = true;
                lOK = true;
              });
            } else {
              setState(() {
                statusErr = false;
                sStatus = "Checked already!";
              });
            }
          });
          if (sq.isEmpty) {
            _showMyDialogErr(_value);
          }
        } else {
          //throw Exception('Failed to load Data from API');
          setState(() {
            statusErr = true;
            sStatus = "Error Check No or Asset Code Empty!!";
          });
        }
      }
    }
  }

  //////////Job Post///
  Future<void> createJobPost() async {
    if (dbs.checkNo != '' && barcode != '') {
      String ckNo = dbs.checkNo;
      dbs.checkwifi();
      // dbs.wifis = 'No';
      if (dbs.wifis == "Yes") {
        var body = jsonEncode({
          'CheckNo': '$ckNo',
          'AssetCode': '$barcode',
          'InputQty': '$iQty',
          'AUse': '${aUse == true ? 'P' : ''}',
          'ANotUse': '${aNotUse == true ? 'P' : ''}',
          'ADamage': '${aDamage == true ? 'P' : ''}',
          'ATransfer': '${aTransfer == true ? 'P' : ''}',
          'ALoss': '${aLoss == true ? 'P' : ''}',
          'LOK': '${lOK == true ? 'P' : ''}',
          'LNO': '${lNO == true ? 'P' : ''}',
          'LNotStick': '${lstricker == true ? 'P' : ''}',
          'Remark': '$remark',
          'CheckBy': '${dbs.users}'
        });

        final response = await http.post(
          Uri.parse(dbs.url + 'api/checkup'),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
          //print(body);
          showInSnackBar("");
          // return JobPost.fromJson(jsonDecode(response.body));
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          //throw Exception('Failed to create album.');
          setState(() {
            statusErr = true;
            sStatus = "Error Can't Post Checked.!!";
          });
        }
      } else {
        //offline Update//
        var sqlc = "update Temp2 set ";
        sqlc += " Ause='${aUse == true ? 'P' : ''}'";
        sqlc += ",ANotUse='${aNotUse == true ? 'P' : ''}'";
        sqlc += ",ADamage='${aDamage == true ? 'P' : ''}'";
        sqlc += ",ALoss='${aLoss == true ? 'P' : ''}'";
        sqlc += ",ATransfer='${aTransfer == true ? 'P' : ''}'";
        sqlc += ",LOK='${lOK == true ? 'P' : ''}'";
        sqlc += ",LNO='${lNO == true ? 'P' : ''}'";
        sqlc += ",LNotStick='${lstricker == true ? 'P' : ''}'";
        sqlc += ",Remark='$remark'";
        sqlc += ",CheckBy='" + dbs.users + "'";
        sqlc += ",CheckPoint='Check'";
        sqlc += ",InputQty=" + iQty.toString();
        sqlc += " where CheckNo='" + dbs.checkNo + "'";
        sqlc += " and AssetCode='" + barcode + "'";

        //print(sqlc);
        if (await sqm.updateTemp2(sqlc) > 0) {
          showInSnackBar("");
        } else {
          setState(() {
            statusErr = true;
            sStatus = "Error Can't Post Checked.!!";
          });
        }
      }
    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Can't Post Checked.!!";
      });
    }
  }

  Future<void> createJobPostBack() async {
    if (dbs.checkNo != '' && barcode != '') {
      String ckNo = dbs.checkNo;
      dbs.checkwifi();
      // dbs.wifis = 'No';
      if (dbs.wifis == "Yes") {
        var body = jsonEncode({
          'CheckNo': '$ckNo',
          'AssetCode': '$barcode',
          'InputQty': '$iQty',
          'AUse': '${aUse == true ? 'P' : ''}',
          'ANotUse': '${aNotUse == true ? 'P' : ''}',
          'ADamage': '${aDamage == true ? 'P' : ''}',
          'ATransfer': '${aTransfer == true ? 'P' : ''}',
          'ALoss': '${aLoss == true ? 'P' : ''}',
          'LOK': '${lOK == true ? 'P' : ''}',
          'LNO': '${lNO == true ? 'P' : ''}',
          'LNotStick': '${lstricker == true ? 'P' : ''}',
          'Remark': '$remark',
          'CheckBy': '$dbs.users'
        });

        final response = await http.post(
          Uri.parse(dbs.url + 'api/checkback'),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        if (response.statusCode == 200) {
          // If the server did return a 201 CREATED response,
          // then parse the JSON.
          //showInSnackBar("");
          // ignore: deprecated_member_use
          _scaffoldKey.currentState?.showSnackBar(snackBarBack);
          // return JobPost.fromJson(jsonDecode(response.body));
        } else {
          // If the server did not return a 201 CREATED response,
          // then throw an exception.
          //throw Exception('Failed to create album.');
          setState(() {
            statusErr = true;
            sStatus = "Error Can't Post Checked.!!";
          });
        }
      } else {
        //offline Update//
        var sqlc = "update Temp2 set ";
        sqlc += " Ause=''";
        sqlc += ",ANotUse=''";
        sqlc += ",ADamage=''";
        sqlc += ",ALoss=''";
        sqlc += ",ATransfer=''";
        sqlc += ",LOK=''";
        sqlc += ",LNO=''";
        sqlc += ",LNotStick=''";
        sqlc += ",Remark=''";
        sqlc += ",CheckBy=''";
        sqlc += ",CheckPoint=''";
        sqlc += ",InputQty=1";
        sqlc += " where CheckNo='" + dbs.checkNo + "'";
        sqlc += " and AssetCode='" + barcode + "'";

        //print(sqlc);
        if (await sqm.updateTemp2(sqlc) > 0) {
          showInSnackBar("");
        } else {
          setState(() {
            statusErr = true;
            sStatus = "Error Can't Post Checked.!!";
          });
        }
      }
    } else {
      setState(() {
        statusErr = true;
        sStatus = "Error Can't Post Checked.!!";
      });
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

                await createJobPostBack();
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
                      builder: (context) => MainPage(),
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
