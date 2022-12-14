// ignore_for_file: prefer_final_fields, unnecessary_string_interpolations, prefer_const_constructors, annotate_overrides, library_private_types_in_public_api, prefer_const_constructors_in_immutables
import 'package:barcodeapp/content/userid.dart';
import 'package:barcodeapp/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'buildload.dart';

class FxApp02 extends StatefulWidget {
  // const FxApp02({Key? key, required this.title}) : super(key: key);
  FxApp02({Key? key}) : super(key: key);
  @override
  _FxApp02State createState() => _FxApp02State();
}

class _FxApp02State extends State<FxApp02> {
  DBData dbs = DBData();
  //Sqlmanagement sqm = Sqlmanagement();
  @override
  initState() {
    super.initState();
    getCheckNoV();
    // feachData();
  }

  Future<void> getCheckNoV() async {
    try {
      /*
      List<SdbQ> sq = await sqm.getTemp1();
      int qq = await sqm.listCountTemp2();
      Future.delayed(Duration(milliseconds: 3000), () async {
        // Do something
      });
      sq.forEach((element) {
        setState(() {
          dbs.users = element.userName;
          dbs.checkNo = element.checkNo;
          dbs.listcount = qq;
        });
      });
      if (sq.length == 0) {
        SdbQ ssq = new SdbQ(userName: "", checkNo: "");
        if (await sqm.insertTemp1(ssq) > 0) {
          //print('Insert OK');
        }
      }
      */
    } catch (error) {
      //  print(error);
      //throw Exception(error);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: const [
                      Color(0xff5ac18e),
                      Color(0x995ac18e),
                      Color(0x795ac18e),
                      Color(0x665ac18e),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        '${dbs.versoin}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      BuildButtonLoad(),
                      SizedBox(height: 5),
                      // LastCheckData(),
                      SizedBox(height: 5),
                      Text(
                        dbs.listcount == 0 ? '' : 'Items : ' '${dbs.listcount}',
                        style: TextStyle(
                            color: Colors.pink.shade500,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 20),
                      //  ButtonLoadData(),
                      UserID(),
                      //////SizedBox(height: 20),
                      //  ButtonCheck(),
                      ////// SizedBox(height: 20),
                      // ButtonSetup(),
                      SizedBox(
                        height: 30,
                        child: Text(
                          'Status : Ready.',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
