import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinKit{

  static Widget fadingCircle({Color? color = Colors.blueGrey, double size=40.0}) {
    return SpinKitFadingCircle(color: color, size: size);
  }

  static Widget cubeGrid({Color? color = Colors.blueGrey, double size=40.0}) {
    return SpinKitCubeGrid(color: color, size: size);
  }

  static Widget threeBounce({Color? color = Colors.blueGrey, double size=40.0}) {
    return SpinKitThreeBounce(color: color, size: size);
  }


  static Widget pianoWave({Color? color = Colors.blueGrey, double size=40.0}) {
    return SpinKitPianoWave(color: color, size: size);
  }

  /*
  RotatingPlain,
  DoubleBounce,
  Wave,
  WanderingCubes,
  FadingFour,
  FadingCube,

  Pulse,
  ChasingDots,
  ThreeBounce,
  Circle,
  CubeGrid,
  FadingCircle,

  RotatingCircle,
  FoldingCube,
  PumpingHeart,
  HourGlass,
  PouringHourGlass,
  PouringHourGlassRefined,

  FadingGrid,
  Ring,
  Ripple,
  SpinningCircle,
  SpinningLines,
  SquareCircle,

  DualRing,
  PianoWave,
  DancingSquare,
  ThreeInOut,
  */
}