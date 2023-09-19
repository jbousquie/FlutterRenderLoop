import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Custom Painter',
        theme: ThemeData(primarySwatch: Colors.green),
        home: const MyPainter());
  }
}

class MyPainter extends StatefulWidget {
  const MyPainter({super.key});
  @override
  State createState() => _MyPainterState();
}

class _MyPainterState extends State<MyPainter>
    with SingleTickerProviderStateMixin {
  var _sides = 5.0;
  double _t = 0;
  late AnimationController controller;
  //late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 100))
          ..addListener(() {
            setState(() {});
            _t += 0.1; // my logic
          });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: CustomPaint(
            painter: ShapePainter(_sides, 100, _t),
            child: Container(),
          )),
          // const Padding(
          //     padding: EdgeInsets.only(left: 24.0), child: Text('Sides')),
          // Slider(
          //   value: _sides,
          //   min: 3.0,
          //   max: 10.0,
          //   label: 'toto',
          //   onChanged: (value) {
          //     setState(() {
          //       _sides = value;
          //     });
          //   },
          // )
        ],
      ),
    ));
  }
}

class ShapePainter extends CustomPainter {
  final double sides;
  final double radius;
  final double radians;
  ShapePainter(this.sides, this.radius, this.radians);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();

    var angle = pi * 2 / sides;

    Offset center = Offset(size.width / 2, size.height / 2);
    Offset startPoint = Offset(radius * cos(0.0), radius * sin(0.0));
    path.moveTo(startPoint.dx + center.dx, startPoint.dy + center.dy);
    for (int i = 1; i <= sides; i++) {
      double x = radius * cos(angle * i) + center.dx;
      double y = radius * sin(angle * i) + center.dy;
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
