import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';


class E40Assets{
  var yepOrNopeAudioArray = ['nope.mp3', 'yep.mp3'];
  static Image nope = new Image(image: new ExactAssetImage('assets/img/nope1.png'));
  static Image yep = new Image(image: new ExactAssetImage('assets/img/yup1.png'));
  List<Image> yepOrNopeImageArray = [nope, yep];
  List<FlareActor> yepOrNopeFlareAnimationArray = [new FlareActor("assets/flare/nope.flr", animation: "Growth",), new FlareActor("assets/flare/yep.flr" , animation: "Growth",)];
}