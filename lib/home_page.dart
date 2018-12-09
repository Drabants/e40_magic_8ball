import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:math' show Random;
import 'asset_loader.dart';


int randomSelector(){
  Random _random = new Random();
  return _random.nextInt(1000)%2;
}

class E40HomePage extends StatefulWidget{
  @override
  _E40HomePageState createState() => new _E40HomePageState();

}

class _E40HomePageState extends State<E40HomePage> with SingleTickerProviderStateMixin{
  var answerImagePlaceholder;
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

  Future sound(int answer) {
    controller.animateTo(3.5, duration: new Duration(milliseconds: 2500), curve: Curves.elasticInOut);
    return Flame.audio.play(assets.yepOrNopeAudioArray[answer]);
  }

  void clearView(){
    setState(() {
      answerImagePlaceholder = null;
    });
  }

  Future wisdom() async{
    int _answer = randomSelector();
    clearView();
    sound(_answer);
    int even=0, odd =0;
    for(int i=0; i < 10; i++){
      randomSelector()%2==0?even++:odd++;
    }
    print((even/10)*100);
    print((odd/10)*100);
    await new Future.delayed(new Duration(seconds:0, milliseconds: 400));
    setState(() {
      answerImagePlaceholder = assets.yepOrNopeFlareAnimationArray[_answer];
    });
  }

  Widget build(BuildContext context) {
    Image _e40Image = new Image(image:  new AssetImage('assets/img/e40.png'), width: 140.0, height: 140.0,);
    return new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                  height: 250.0,
                  child:answerImagePlaceholder,
                ),
                new Container(
                  height: 140.0,
                  width: animation.value*140.0,
                  child:
                  new FloatingActionButton(
                    onPressed: wisdom,
                    backgroundColor: Colors.white,
                    child: _e40Image,
                    clipBehavior: Clip.antiAlias,
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

