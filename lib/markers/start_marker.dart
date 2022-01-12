import 'package:flutter/material.dart';

class StartMarkerPainter extends CustomPainter {
  final String destination;
  final int minutes;

  StartMarkerPainter({
    required this.minutes,
    required this.destination,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final blackPaint = Paint()..color = Colors.black;
    final whitePaint = Paint()..color = Colors.white;

    const double circleBlackRadius = 20;
    const double circleWithRadius = 7;

    //Circulo Negro
    canvas.drawCircle(
        Offset(circleBlackRadius, size.height - circleBlackRadius),
        circleBlackRadius,
        blackPaint);

    //Circulo Negro
    canvas.drawCircle(
      Offset(circleBlackRadius, size.height - circleBlackRadius),
      circleWithRadius,
      whitePaint,
    );

    //Caja Blanca

    final path = Path();
    path.moveTo(40, 20);
    path.lineTo(size.width - 10, 20);
    path.lineTo(size.width - 10, 100);
    path.lineTo(40, 100);

    canvas.drawShadow(path, Colors.black, 10, false);

    canvas.drawPath(path, whitePaint);

    const blackBox = Rect.fromLTWH(40, 20, 70, 80);

    canvas.drawRect(blackBox, blackPaint);

    //Textos
    final textSpan = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
      text: '$minutes',
    );

    final minutosPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);

    minutosPainter.paint(canvas, const Offset(40, 35));
    //Minutos

    //Textos Min
    const minutesSpan = TextSpan(
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w200),
      text: "Min",
    );

    final minPainter = TextPainter(
      text: minutesSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: 70, minWidth: 70);

    minPainter.paint(canvas, const Offset(40, 68));

    //Descripcion

    final locationText = TextSpan(
      style: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w200),
      text: destination,
    );

    final locationPainter = TextPainter(
      text: locationText,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      maxLines: 2,
      ellipsis: "...",
    )..layout(
        maxWidth: size.width - 135,
        minWidth: size.width - 135,
      );

    final double offsetY = (destination.length > 20) ? 35 : 48;

    locationPainter.paint(canvas, Offset(120, offsetY));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => false;
}
