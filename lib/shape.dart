import 'dart:typed_data';
import 'dart:math';
import 'package:vector_math/vector_math.dart';
import 'dart:ui';

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
    positions = Float32List.fromList([-0.5, 0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5]);
    indices = Uint16List.fromList([1, 0, 3, 2, 3, 1]);
  }

  Geometry.polygon(int sides) {
    if (sides < 3) {
      sides = 3;
    }
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
    for (i = 1; i < sides; i++) {
      ind.add(0);
      ind.add(i);
      ind.add(i + 1);
    }
    ind.addAll([0, sides, 1]);
    positions = Float32List.fromList(pos);
    indices = Uint16List.fromList(ind);
  }

  Geometry.ribbon(List<List<double>> pathArray) {
    int pLength = pathArray.length;
    int length = pathArray[0].length;
    List<double> pos = [];
    for (int j = 0; j < pLength; j++) {
      pos.addAll(pathArray[j]);
    }
    List<int> ind = [];
    for (int j = 0; j < pLength - 1; j++) {
      for (int i = 0; i < length - 1; i++) {
        ind.addAll([i, i + 1, i + length]);
        ind.addAll([i + length, i + length + 1, i + 1]);
      }
    }
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

  Float32List get positions {
    return _positions;
  }

  set positions(Float32List value) {
    _positions = value;
  }

  void render(Canvas canvas, Paint paint) {
    //transform();
    _vertexData = Vertices.raw(vertexMode, _positions, indices: geometry.indices);
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
      _positions[i] = geoPosX * cosA * sx + geoPosY * sinA * sy + x;
      _positions[i + 1] = geoPosY * cosA * sy - geoPosX * sinA * sx + y;
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

  Shape.ribbon(List<List<double>> pathArray) {
    geometry = Geometry.ribbon(pathArray);
    _positions = Float32List.fromList(geometry.positions);
  }
}
