import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'asset_loader.dart';

class E40HomePage extends StatefulWidget{
  @override
  _E40HomePageState createState() => new _E40HomePageState();

}

class _E40HomePageState extends State<E40HomePage> with SingleTickerProviderStateMixin{
  E40Assets assets = new E40Assets();
  AnimationController controller;
  Animation<double> animation;

  @override

  void initState(){
    super.initState();
    Flame.audio.loadAll(['nope.mp3', 'yep.mp3']);
    controller = new AnimationController(duration: new Duration(milliseconds: 2000), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation.addListener((){
      this.setState((){});
    });
    animation.addStatusListener((AnimationStatus status){
    });
    controller.forward();
  }


  Widget build(BuildContext context) {
    Image _E40Image = new Image(image:  new AssetImage('assets/img/e40.png'), width: 140.0, height: 140.0,);
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
                  width: animation.value*140.0,
                  child: new FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.white,
                    child: _E40Image,
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