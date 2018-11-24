import 'package:flutter/material.dart';


void main() {
  runApp(
    new MaterialApp(
      home: new E40HomePage()
    )
  );
}

class E40HomePage extends StatefulWidget{
  @override
  _E40HomePageState createState() => new _E40HomePageState();

}

class _E40HomePageState extends State<E40HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  height: 250.0,
                ),
                new Container(
                  height: 140.0,
                  child: new FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.white,
                    tooltip: 'Increment',
                  ),
                ),
                new SizedBox(
                  height:170.0,
                ),
              ],
            ),
          ),
        )
    );
  }
}