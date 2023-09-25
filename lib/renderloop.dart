// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vector_math/vector_math.dart';

class GameWidget extends StatefulWidget {
  final GameScene scene;
  const GameWidget(this.scene, {super.key});

  @override
  State createState() => GameState();
}

class GameState extends State<GameWidget> with SingleTickerProviderStateMixin {
  int _dt = 0;
  Duration _elapsed = Duration.zero;
  late final Ticker _ticker;

  // Game Loop
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {});
      _dt = (elapsed - _elapsed).inMilliseconds;
      _elapsed = elapsed;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Game Loop', home: buildCanvasContainer());
  }

  Widget buildCanvasContainer() {
    return Scaffold(
        body: SafeArea(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(child: buildCanvasPainter(context)),
      ]),
    ));
  }

  Widget buildCanvasPainter(BuildContext context) {
    return CustomPaint(
      //willChange: true,
      painter: ScenePainter(widget.scene, _dt),
      child: Container(),
    );
  }
}

class ScenePainter extends CustomPainter {
  final int _dt;
  final GameScene _scene;
  ScenePainter(this._scene, this._dt);

  @override
  void paint(Canvas canvas, Size size) {
    _scene.render(canvas, size, _dt);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Game extends GameWidget {
  const Game(GameScene scene, {super.key}) : super(scene);
  void run() {
    runApp(this);
  }
}

class GameScene {
  const GameScene();

  void render(Canvas canvas, Size size, int dt) {
    //
  }
}

class Geometry {
  Geometry();
  late Float32List positions; // 2D coordinates
  late Uint16List indices;
  late Float32List? uvs;
  late Int32List? colors;

  // Named Constructors
  Geometry.triangle() {
    double h = sqrt(3) / 6;
    positions = Float32List.fromList([-0.5, h, 0.5, h, 0, -sqrt(3) / 3]);
    indices = Uint16List.fromList([0, 1, 2]);
  }

  Geometry.quad() {
    positions =
        Float32List.fromList([-0.5, 0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5]);
    indices = Uint16List.fromList([1, 0, 3, 2, 3, 1]);
  }

  Geometry.polygon(int sides) {
    double radius = 0.5;
    double step = pi * 2 / sides;
    List<double> pos = [0.0, 0.0];
    List<int> ind = [];
    int i = 0;
    for (i = 0; i < sides; i++) {
      double x = radius * cos(i * step);
      double y = radius * sin(i * step);
      pos.add(x);
      pos.add(y);
    }
    for (i = 0; i < sides; i++) {
      ind.add(0);
      ind.add(i);
      ind.add(i + 1);
    }
    ind.addAll([0, sides, 1]);
    positions = Float32List.fromList(pos);
    indices = Uint16List.fromList(ind);
  }
}

class Shape {
  Shape();
  Vector3 position = Vector3.zero(); // z for drawing priority
  double rotation = 0;
  Vector2 scaling = Vector2(1, 1);
  Int32List color = Int32List.fromList([255, 0, 255, 0]);

  late Geometry geometry;
  late Float32List _positions; // computed positions
  late Vertices _vertexData;

  static const vertexMode = VertexMode.triangles;
  //static const blendMode = BlendMode.srcOver;
  static const blendMode = BlendMode.dst;

  Paint paint = Paint();

  void render(Canvas canvas, Paint paint) {
    transform();
    _vertexData =
        Vertices.raw(vertexMode, _positions, indices: geometry.indices);
    canvas.drawVertices(_vertexData, blendMode, paint);
  }

  // Transformations
  Shape transform() {
    double x = position.x;
    double y = position.y;
    double sx = scaling.x;
    double sy = scaling.y;
    double cosA = cos(rotation);
    double sinA = sin(rotation);
    Float32List geoPos = geometry.positions;
    int length = _positions.length;
    for (int i = 0; i < length; i += 2) {
      double geoPosX = geoPos[i];
      double geoPosY = geoPos[i + 1];
      _positions[i] = (geoPosX * cosA + geoPosY * sinA) * sx + x;
      _positions[i + 1] = (geoPosY * cosA - geoPosX * sinA) * sy + y;
    }
    return this;
  }

  // Named Constructors
  Shape.triangle() {
    geometry = Geometry.triangle();
    _positions = Float32List.fromList(geometry.positions);
  }
  Shape.quad() {
    geometry = Geometry.quad();
    _positions = Float32List.fromList(geometry.positions);
  }
  Shape.polygon(int sides) {
    geometry = Geometry.polygon(sides);
    _positions = Float32List.fromList(geometry.positions);
  }
}
