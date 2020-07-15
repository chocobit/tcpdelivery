import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flushbar/flushbar.dart';
import 'dart:convert' as convert;

import 'package:tcpdeliver/models/sign.dart';



class DeliveryPage extends StatefulWidget {
  DeliveryPage({Key key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final _formKey = GlobalKey<FormState>();

  String barcodeInput;
  String barcode;
  final barcodeController = TextEditingController();

  checkBarcode(String barcode) async {
    String url =
        "http://intra2.toa-chugoku.com/4E/src/api/checkPackno.php?packno='" +
            barcode +
            "' ";
    print('checkloadno :' + url);
    final res = await http.get(url);
    print(res.statusCode);
    if (res.body != null) {
      var msg = 'Found Tracking';
      if (res.statusCode == 200) {
        Flushbar(
          title: "$msg",
          message: "Go to Sign Page.",
          duration: Duration(seconds: 2),
          icon: Icon(Icons.create),
        )..show(context);
        barcodeController.clear();
        Future.delayed(Duration(seconds: 1), () {
           Navigator.pushNamed(context, '/sign',
               arguments: Sign(barcode));
          // Navigator.pushNamed(context, '/sign');
        });
      } else {
        // var feedback = convert.json.decode(res.body);
        var status = res.statusCode;
        var msg = 'ไม่พบข้อมูลในระบบ';
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
    });
    barcodeController.text = barcode;
  }

  @override
  void initState() {
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(top: 50.00, bottom: 20.00, left: 20.00),
                    // padding: EdgeInsets.all(20.00),
                    child: Text(
                      'Packingslip Number',
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            checkBarcode('$barcodeInput');
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
