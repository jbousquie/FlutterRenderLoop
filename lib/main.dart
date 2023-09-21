import 'package:flutter/material.dart';
import 'renderloop.dart';
import 'dart:math';

/* 
Import here at least material.dart in order to get the canvas drawing methods and renderloop.dart
Then create your own class extending GameScene, say, class MysScene.
In this class, declare all your instance variables that describes the game state.
Then implement the method render(Canvas canvas, Size size, int dt) overriding the GameScene method.
This render() method is called each frame and is passed :
- the canvas in which the drawing is done
- the size of this canvas
- the delta time dt between this frame and the previous one as an integer in milliseconds

Initialization :
1 - Create an object from your GameScene extended class.1
2 - Create a game object with this scene :
3 - Run the game

void main() {
  GameScene scene = MyScene();
  Game game = Game(scene);
  game.run();
}


*/

class MyScene extends GameScene {
  MyScene({dynamic key});
  // My game initial State
  double radius = 50;
  double sides = 7;
  double radians = 0; // current shape rotation
  double scale = 1.0; // current radius scaling
  double scaledRadius = 0;
  double width = 0;

  // Called each frame
  @override
  void render(Canvas canvas, Size size, int dt) {
    // update the shape rotation and scaling
    radians += 0.003 * dt;
    scale = cos(radians) + 2.0;
    scaledRadius = radius * scale;
    width = 2 + sin(radians * 0.1) * 15;

    // draw the shape
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    var angle = pi * 2 / sides;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset startPoint = Offset(scaledRadius * cos(0.0), scaledRadius * sin(0.0));
    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);
    for (int i = 1; i <= sides; i++) {
      double x = scaledRadius * cos(angle * i) + center.dx;
      double y = scaledRadius * sin(angle * i) + center.dy;
      path.lineTo(x, y);
    }
    path.close();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(radians);
    canvas.translate(-center.dx, -center.dy);
    canvas.drawPath(path, paint);
    canvas.restore();
  }
}

void main() {
  GameScene scene = MyScene();
  Game game = Game(scene);
  game.run();
}
