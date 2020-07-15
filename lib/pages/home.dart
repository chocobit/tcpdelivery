import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flushbar/flushbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tcpdeliver/models/chklogin.dart';
import 'package:tcpdeliver/models/license.dart';
import 'package:tcpdeliver/widgets/logo.dart';
import 'package:tcpdeliver/widgets/menu.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final licenseController = TextEditingController();
  String licenseInput;
  SharedPreferences prefs;
  bool isAuth = false;
  Map profile;

  Scaffold buildLoginScreen() {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/TCPlogo.png',
                    fit: BoxFit.contain, height: 150.0),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 50.00, bottom: 00.00, left: 20.00),
                          // padding: EdgeInsets.all(20.00),
                          child: Text(
                            'เลขทะเบียนรถ',
                            style: TextStyle(
                                fontSize: 30.00, fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.00),
                          child: TextFormField(
                            controller: licenseController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.00))),
                              labelText: 'เลขทะเบียนรถ',
                              hintText: 'โปรดใส่เลขทะเบียนรถ',
                            ),
                            onSaved: (value) => licenseInput = value,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่เลขทะเบียนรถ';
                              }
                              return null;
                            },
                          )),
                      Padding(
                          padding: EdgeInsets.all(10.00),                       
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.white)),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  print('submit $licenseInput');
                                  login(licenseInput);
                                }
                              },
                              child: Text('เข้าสู่ระบบ',style: TextStyle(
                                fontSize : 20.00
                              ),),
                            ),
                          )),
                    ],
                  ),
                ),
              ])),
    );
  }

  Scaffold buildMainMenu() {
    return Scaffold(
      appBar: AppBar(
        title: Logo(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.lock_open),
            onPressed: () {
              setState(() {
                logout();
              });
            },
          )
        ],
      ),
      drawer: Menu(),
      body: Container(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/loading',
                    arguments: License('${profile['hpglicenseplate']}'));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.system_update_alt,
                      color: Theme.of(context).primaryColor,
                      size: 80.0,
                    ),
                    Text(
                      '1. Loading',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )
                  ],
                )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/delivery');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.white,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                      size: 80.0,
                    ),
                    Text(
                      '2. Delivery',
                      style: TextStyle(fontSize: 24, color: Colors.black),
                    )
                  ],
                )),
              ),
            ),
            GestureDetector(
                onTap: () {
                  print('License Plate');
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.airport_shuttle,
                          color: Theme.of(context).primaryColor, size: 80.0),
                      Text('License Plate',
                          style: TextStyle(fontSize: 15, color: Colors.black)),
                      Text('${profile['hpglicenseplate']}',
                          style: TextStyle(fontSize: 15, color: Colors.black))
                    ],
                  )),
                  color: Colors.white,
                )),
            GestureDetector(
                onTap: () {
                  setState(() {
                    logout();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.cloud_off,
                          color: Theme.of(context).primaryColor, size: 80.0),
                      Text('Logout',
                          style: TextStyle(fontSize: 24, color: Colors.black))
                    ],
                  )),
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  login(String license) async {
    prefs = await SharedPreferences.getInstance();
    if (license != null) {
      //print(_licenseKey.currentState.value);
      var url =
          "http://intra2.toa-chugoku.com/4E/src/api/chklogin.php?license=" +
              license +
              "";
      print('$url');
      final res = await http.get(url);
      if (res.statusCode == 200) {
        await getProfile(license);
        Navigator.pushReplacementNamed(context, '/');
      } else {
        print(res.statusCode);
        var feedback = convert.json.decode(res.body);
        var status = feedback['status'];
        var msg = feedback['message'];
        Flushbar(
          title: "Error : $status",
          message: "$msg",
          duration: Duration(seconds: 3),
          icon: Icon(Icons.clear),
        )..show(context);
        setState(() {
          isAuth = false;
        });
      }
    }
  }

  Future<void> getProfile(String license) async {
    var url =
        "http://intra2.toa-chugoku.com/4E/src/api/chklogin.php?license=" +
            license +
            "";
    final res = await http.get(url);
    // var chklogin = convert.json.decode(res.body);
    //  await prefs.setString(
    //     'chklogin', convert.json.encode(chklogin['data']));
    // print(chklogin['data']);
    final ChkLogin chklogin = ChkLogin.fromJson(convert.jsonDecode(res.body));
    if (chklogin.active == 'Y' && chklogin.hpglicenseplate != null) {
      var profile = convert.json.decode(res.body);
      await prefs.setString('profile', convert.json.encode(profile));
      isAuth = true;
    } else {
      var feedback = convert.jsonDecode(res.body);
      var status = feedback['status'];
      var msg = feedback['message'];
      Flushbar(
          title: "$status",
          message: "$msg",
          duration: Duration(seconds: 3),
          icon: Icon(Icons.cancel))
        ..show(context);
    }
  }

  checklogin() async {
    prefs = await SharedPreferences.getInstance();
    var profileString = prefs.getString('profile');
    if (profileString != null) {
      profileString = prefs.getString('profile');
      profile = convert.json.decode(profileString);

      //print('getprofile $profileString');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
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
    licenseController.dispose();
  }



  @override
  void initState() {
    super.initState();
    checklogin();
     SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //AutoOrientation.portraitAutoMode();
  }

  logout() async {
    await prefs.remove('profile');
    setState(() {
      isAuth = false;
    });
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return isAuth == true ? buildMainMenu() : buildLoginScreen();
    //return buildLoginScreen();
  }
}
