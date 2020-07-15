import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flushbar/flushbar.dart';
import 'dart:convert' as convert;

import 'package:tcpdeliver/models/license.dart';
import 'package:tcpdeliver/models/loadhead.dart';
import 'package:tcpdeliver/models/product.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final _formKey = GlobalKey<FormState>();

  String barcodeInput;
  String barcode;
  String licenseplate;
  final barcodeController = TextEditingController();

  List<Course> course = [];
  var isLoading = true;

  checkBarcode(String barcode, String license) async {
    String url =
        "http://intra2.toa-chugoku.com/4E/src/api/checkLoadno.php?loadno='" +
            barcode +
            "'&license='" +
            license +
            "'";
    print('checkloadno :' + url);
    final res = await http.get(url);
    final Loadhead loadhead = Loadhead.fromJson(convert.jsonDecode(res.body));
    print(loadhead.lob);
    if (res.statusCode == 200) {
      print('code 200');
      var msg = 'Found Tracking';
      if (loadhead.loadstatus != null) {
        Flushbar(
          title: "$msg",
          message: "Save complete.",
          duration: Duration(seconds: 2),
          icon: Icon(Icons.create),
        )..show(context);
        String urlsave =
            "http://intra2.toa-chugoku.com/4E/src/api/saveLoadno.php?loadno='" +
                barcode +
                "'&license='" +
                license +
                "'";
        print(urlsave);
        final saveRes = await http.get(urlsave);

        barcodeController.clear();
        // Future.delayed(Duration(seconds: 2), () {
        //   Navigator.pushNamed(context, '/sign',
        //       arguments: Sign(loadhead.loadno));
        // });
      } else {
        var feedback = convert.json.decode(res.body);
        var status = feedback['status'];
        var msg = feedback['message'];
        Flushbar(
          title: "$status",
          message: "$msg",
          duration: Duration(seconds: 3),
          icon: Icon(Icons.clear),
        )..show(context);
      }
    } else {
      Flushbar(
        title: "Failed",
        message: "Can't connect to server.",
        duration: Duration(seconds: 3),
        icon: Icon(Icons.clear),
      )..show(context);
    }
  }

  Future scan() async {
    String cameraScanResult = await scanner.scan();
    setState(() {
      barcode = cameraScanResult;
      print('$barcode');
    });
    barcodeController.text = barcode;
    checkBarcode(barcode,licenseplate);
  }

  @override
  void initState() {
    super.initState();
    scan();
    SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //getData();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
    barcodeController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final License lin = ModalRoute.of(context).settings.arguments;
    //print('เลขะเบียนรถ ${lin.license}');
    licenseplate = lin.license;
    return Scaffold(
      appBar: AppBar(
        title: Text('Loading'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          top: 50.00, bottom: 20.00, left: 20.00),
                      // padding: EdgeInsets.all(20.00),
                      child: Text(
                        'Loading Number',
                        style: TextStyle(
                            fontSize: 30.00, fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: barcodeController,
                        textAlign: TextAlign.center,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(
                          fontSize: 25.00,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.00))),
                          labelText: 'Scan BarCode',
                          hintText: 'Type Barcode',
                        ),
                        onSaved: (value) => barcodeInput = value.toUpperCase(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please insert value.';
                          }
                          //print('barcode: '+barcodeInput);
                          return null;
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.all(20.00),
                    child: Row(
                      children: <Widget>[
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          padding:
                              EdgeInsets.fromLTRB(30.00, 10.00, 30.00, 10.00),
                          onPressed: () {
                            scan();
                          },
                          child: Row(
                            children: <Widget>[
                              Text('Scan '),
                              Icon(Icons.camera_alt)
                            ],
                          ),
                        ),
                        Spacer(),
                        RaisedButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          padding:
                              EdgeInsets.fromLTRB(30.00, 10.00, 30.00, 10.00),
                          onPressed: () {
                            print('save');
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              checkBarcode('$barcodeInput', '${lin.license}');
                              //print('submit $barcodeInput');
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Text('Confirm '),
                              Icon(Icons.save_alt)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.00),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/detail');
                            //print('Push Detail');
                          },
                          padding: EdgeInsets.all(5.00),
                          child: Text('Check Loading number.',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.orangeAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'TOA-CHUGOKU PAINTS CO., LTD.',
              style: TextStyle(color: Colors.black),
            ),
            Padding(padding: EdgeInsets.all(5.00))
          ],
        ),
      ),
    );
  }
}
