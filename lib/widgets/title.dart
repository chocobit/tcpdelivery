import 'package:flutter/material.dart';

class BigTitle extends StatelessWidget {
  final String title;
  const BigTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$title', style: TextStyle(fontSize: 50, color: Colors.red));
  }
}
