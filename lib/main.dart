import 'package:flutter/material.dart';
import 'package:flyschoolchiken/game.dart';

void main() {
  runApp(MaterialApp(
    home: ChickenSilhouetteScreen(),
  ));
}

class ChickenSilhouetteScreen extends StatefulWidget {
  @override
  _ChickenSilhouetteScreenState createState() =>
      _ChickenSilhouetteScreenState();
}

class _ChickenSilhouetteScreenState extends State<ChickenSilhouetteScreen> {
  @override
  void initState() {
    super.initState();
    // Запускаем таймер на 3 секунды и переключаем экран
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebGameScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Фон экрана
      body: Center(
        child: CustomPaint(
          size: Size(200, 200), // Размер холста для рисования
          painter: ChickenPainter(), // Наш кастомный художник
        ),
      ),
    );
  }
}

class ChickenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Создаем желтую кисть
    final paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // Рисуем примерный силуэт курицы (абстрактный)
    final path = Path();
    path.moveTo(size.width * 0.5, 0); // Верхняя точка головы
    path.cubicTo(size.width * 0.7, size.height * 0.1, size.width * 0.9,
        size.height * 0.3, size.width * 0.5, size.height * 0.4); // Голова
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.5, 0,
        size.height * 0.5); // Шея
    path.quadraticBezierTo(size.width * 0.4, size.height * 1.1, size.width,
        size.height * 0.7); // Туловище и хвост
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.3, size.width * 0.5,
        0); // Замыкаем путь

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

