import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'dart:convert' as convert;
import 'package:geolocator/geolocator.dart';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:tcpdeliver/models/sign.dart';
import 'package:tcpdeliver/widgets/menu.dart';

class SignPage extends StatefulWidget {
  SignPage({Key key}) : super(key: key);
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  static double screenWidth;
  static double screenHeight;
  var packSlipG;
  var latitude;
  var longitude;
  String image;
  Position _currentPosition;

  @override
  void initState() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    _initCurrentLocation();
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
  }

  _initCurrentLocation() async {
    _currentPosition = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    latitude = _currentPosition.latitude;
    longitude = _currentPosition.longitude;
    print(_currentPosition.altitude);
    print(_currentPosition.latitude);
    print(_currentPosition.longitude);
  }

  final _formKey = GlobalKey<FormState>();
  var _signatureCanvas = Signature(
    //width: 400,
    width: screenWidth,
    height: screenHeight,
    backgroundColor: Colors.white,
    penColor: Colors.black,
    penStrokeWidth: 3.0,
  );

  uploadImage(String image) async {
    print(image);
    //var url = 'https://codingthailand.com/api/upload_image2.php';
    var url =
        "http://intra2.toa-chugoku.com/4E/src/api/insertpicture.php?packslip=" +
            packSlipG +
            "&latitude=$latitude&longitude=$longitude";

    //var url2 = "http://intra2.toa-chugoku.com/4E/src/api/insertpicture.php";
    print(url);
    var res = await http.post(url,
        headers: {'Content-Type': 'apllication/json'},
        body: convert.json.encode({
          'imageData': 'data:image/png;base64,' + image,
          //barcodeInput
        }));
    if (res.statusCode == 200) {
      var feedback = convert.json.decode(res.body);
      var msg = feedback['message'];
      Flushbar(
        title: "$msg",
        message: "Save Complete.",
        duration: Duration(seconds: 3),
        icon: Icon(Icons.cloud_done),
      )..show(context);
      print(feedback['message']);
      
    } else {
      Flushbar(
        title: "${res.statusCode}",
        message: "Please try again",
        duration: Duration(seconds: 3),
        icon: Icon(Icons.accessible_forward),
      )..show(context);
    }
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height * 0.67;
    screenWidth = MediaQuery.of(context).size.width * 1;
    final Sign packingSlip = ModalRoute.of(context).settings.arguments;
    packSlipG = packingSlip.packid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign : ' + packingSlip.packid),
        centerTitle: true,
      ),
      drawer: Menu(),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(00.00),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[_signatureCanvas],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.00),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 1 * 0.315,
                    height: MediaQuery.of(context).size.height * 0.115,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.black26,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            splashColor: Colors.red,
                            onPressed: () {
                              Navigator.pushNamed(context, '/delivery');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Back ",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Icon(Icons.chevron_left)
                              ],
                            ),
                          ),
                          FlatButton(
                            color: Colors.red,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            splashColor: Colors.red,
                            onPressed: () {
                              return _signatureCanvas.clear();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Clear ",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Icon(Icons.cancel)
                              ],
                            ),
                          ),
                          FlatButton(
                            color: Colors.blue,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            splashColor: Colors.blueAccent,
                            onPressed: () async {
                              var bytes = await _signatureCanvas.exportBytes();
                              image = convert.base64.encode(bytes);
                              uploadImage(image);
                              _signatureCanvas.clear();
                              
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Save ",
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Icon(Icons.save_alt)
                              ],
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
