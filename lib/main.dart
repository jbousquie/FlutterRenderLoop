import 'dart:typed_data';

import 'package:flutter/material.dart' as material;
import 'package:vector_math/vector_math_64.dart';
import 'dart:math';
import 'renderloop.dart';
import 'shape.dart';

/* 
Import here at least material.dart in order to get the canvas drawing methods and import the the file renderloop.dart
Then create your own class extending GameScene, say, class MysScene.
In this class, declare all your instance variables that describe the game state.
Then implement the method render(Canvas canvas, Size size, int dt) overriding the `render()`GameScene method.
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
  // My game initial State
  double radius = 20;
  double sides = 7;
  double radians = 0; // current shape rotation
  double scale = 1.0; // current radius scaling
  double scaledRadius = 0;
  double width = 0;
  double t = 0;
  material.Paint shapePaint = material.Paint()..color = material.Colors.blueAccent;
  List<Shape> shapes = [];
  List<Vector2> velocities = [];

  Shape globalShape = Shape();
  List<double> pos = [];
  List<int> ind = [];

  MyScene({dynamic key}) {
    int nb = 10000;
    double speedX = 0.8;
    double speedY = 15;
    double width = 2000;

    int sz = 0;
    for (int i = 0; i < nb; i++) {
      Vector2 velocity = Vector2(Random().nextDouble() * speedX, Random().nextDouble() * speedY + 2);
      velocities.add(velocity);
      Shape shape = Shape.polygon(5);
      shape.position.x = Random().nextDouble() * width;
      double scl = radius - (radius * 0.3 * Random().nextDouble());
      shape.scaling.x = scl - Random().nextDouble() * 5;
      shape.scaling.y = scl;
      shape.rotation = Random().nextDouble();
      shapes.add(shape);
      pos.addAll(shape.geometry.positions);
      for (int idx = 0; idx < shape.geometry.indices.length; idx++) {
        ind.add(shape.geometry.indices[idx] + sz);
      }
      sz += (shape.geometry.positions.length * 0.5).toInt();
    }
    globalShape.geometry = Geometry();
    globalShape.geometry.indices = Uint16List.fromList(ind);
    globalShape.geometry.positions = Float32List.fromList(pos);
    globalShape.positions = Float32List.fromList(pos);
  }

  // Called each frame
  @override
  void render(material.Canvas canvas, material.Size size, int dt) {
    renderShape(canvas, size, shapePaint, dt);
  }

  void renderShape(material.Canvas canvas, material.Size size, material.Paint paint, int dt) {
    t += 0.01 * dt;
    int j = 0;
    //pos = [];
    for (int i = 0; i < shapes.length; i++) {
      Shape shape = shapes[i];
      Vector2 vel = velocities[i];
      double sint = sin(t + i);

      shape.position.x += vel.x * sint;
      shape.position.y += vel.y;
      if (shape.position.y > size.height) {
        shape.position.x = size.width * Random().nextDouble();
        shape.position.y = 0;
      }
      double p = i % 2 == 0 ? -1 : 1;
      shape.rotation += dt * 0.01 * p;
      shape.transform();
      for (int t = 0; t < shape.positions.length; t++) {
        globalShape.positions[t + j] = shape.positions[t];
      }
      //pos.addAll(shape.positions);
      j += shape.positions.length;
      //shape.render(canvas, paint);
    }
    //globalShape.positions = Float32List.fromList(pos);
    globalShape.render(canvas, paint);
  }
}

void main() {
  GameScene scene = MyScene();
  Game game = Game(scene);
  game.run();
}
