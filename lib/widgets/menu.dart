import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        /* DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              'Main Menu',
              style: TextStyle(fontSize: 24, color: Colors.white70),
            )),*/
        ListTile(       
          title: Text('Menu',
              style: TextStyle(fontSize: 25, color: Colors.white70 ,),
              textAlign: TextAlign.center ,
              ), 
              contentPadding: const EdgeInsets.all(8),
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Text('Main Menu',
              style: TextStyle(fontSize: 20, color: Colors.white70)),       
        ),
        ListTile(
            leading: Icon(
              Icons.send,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            title: Text(
              'Loading',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ))
      ],
    ));
  }
}
