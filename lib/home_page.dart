import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' ;
import 'asset_loader.dart';


int randomSelector(){
  Random _random = new Random();
  return _random.nextInt(10000)%2;
}


class E40HomePage extends StatefulWidget{
  @override
  _E40HomePageState createState() => new _E40HomePageState();

}

class _E40HomePageState extends State<E40HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver{
  var answerImagePlaceholder;
  bool active = true;
  E40Assets assets = new E40Assets();
  AnimationController controller;
  Animation<double> animation;
  Stopwatch shakeTimer = new Stopwatch()..start();
  double _detectionThreshold = 1;
  double lastX, lastY, lastZ;

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
    WidgetsBinding.instance.addObserver(this);
    detectShake();
  }

  @override
  void dispose(){
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.paused:
        active = false;
        break;
      case AppLifecycleState.resumed:
        active = true;
        break;
      case AppLifecycleState.inactive:
        active = false;
        break;
      case AppLifecycleState.suspending:
        break;
    }
  }

  void detectShake(){
    accelerometerEvents.listen((AccelerometerEvent event){
      //check if 3 seconds have passed and the app is currently active
      //this prevents excessive answering by E40
      if((shakeTimer.elapsed.inSeconds) > 3 && active) {
        double x = event.x;
        double y = event.y;
        double z = event.z;
        double speed = ((x+y+z - lastX - lastY - lastZ)/(10));
        speed.abs();
        if (speed > _detectionThreshold) {
          wisdom();
          shakeTimer.reset();
        }
        lastX = x;
        lastY = y;
        lastZ = z;
      }else if(active){
        lastX = event.x;
        lastY = event.y;
        lastZ = event.z;
      }
    });
  }

  void clearView(){
    setState(() {
      answerImagePlaceholder = null;
    });
  }

  Future sound(int answer) {
    controller.animateTo(3.5, duration: new Duration(milliseconds: 2500), curve: Curves.elasticInOut);
    return Flame.audio.play(assets.yepOrNopeAudioArray[answer]);
  }

  Future wisdom() async{
    int _answer = randomSelector();
    clearView();
    sound(_answer);
    await new Future.delayed(new Duration(seconds:0, milliseconds: 400));
    setState(() {
      answerImagePlaceholder = assets.yepOrNopeFlareAnimationArray[_answer];
    });
  }

  Widget build(BuildContext context) {
    Image _e40Image = new Image(image:  new AssetImage('assets/img/e40.png'), width: 140.0, height: 140.0,);
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(color: Colors.black),
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height: queryData.size.height/2.5,
                  child:answerImagePlaceholder,
                ),
                new Container(
                  height: queryData.size.height/2,
                  width: animation.value*140.0,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, queryData.size.height/4),
                  child: Container(
                  child:new FloatingActionButton(
                    onPressed: wisdom,
                    backgroundColor: Colors.white,
                    child: _e40Image,
                    clipBehavior: Clip.antiAlias,
                  ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

