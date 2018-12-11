import 'package:flutter/material.dart';
import 'package:flame/flame.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' ;
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
    int lastUpdate = 0;
    double _detectionThreshold = .5;
    double lastX=0, lastY=0, lastZ=0;
    Flame.audio.loadAll(['nope.mp3', 'yep.mp3']);
    controller = new AnimationController(duration: new Duration(milliseconds: 2000), vsync: this);
    animation = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation.addListener((){
      this.setState((){});
    });
    animation.addStatusListener((AnimationStatus status){
    });
    controller.forward();
    accelerometerEvents.listen((AccelerometerEvent event){
      DateTime curTime = DateTime.now();
      if((lastUpdate) > 5) {
        int diffTime = (curTime.millisecond - lastUpdate);
        print(lastUpdate);
        double x = event.x;
        double y = event.y;
        double z = event.z;
        double speed = ((x+y+z - lastX - lastY - lastZ)/(diffTime/10));
        speed.abs();
        if(speed > 0) {
          print("Movement Detected!!!!!!!");
          print(speed);
        }
        if (speed > _detectionThreshold) {
          sleep();
          wisdom();
          lastUpdate = 0;
        }
        lastX = x;
        lastY = y;
        lastZ = z;

      }
      else{
        lastUpdate += curTime.second;
      }
    });
  }

  Future sleep(){
    return new Future.delayed(new Duration(milliseconds: 4000000000));
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

