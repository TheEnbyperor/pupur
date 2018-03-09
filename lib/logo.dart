import 'package:flutter/material.dart';

class PupurLogo extends StatelessWidget {
  PupurLogo({this.height, this.t});

  final double height;
  final double t;

  static const double kLogoHeight = 300.0;
  static const double kLogoWidth = 330.0;
  static const double kImageHeight = 200.0;
  static const double kTextHeight = 130.0;
  final TextStyle titleStyle = const TextStyle(fontSize: kTextHeight, color: Colors.black, letterSpacing: 3.0, fontFamily: "Rothwell");
  final RectTween _textRectTween = new RectTween(
      begin: new Rect.fromLTWH(0.0, kLogoHeight, kLogoWidth, kTextHeight),
      end: new Rect.fromLTWH(0.0, kImageHeight, kLogoWidth, kTextHeight)
  );
  final Curve _textOpacity = const Interval(0.4, 1.0, curve: Curves.easeInOut);
  final RectTween _imageRectTween = new RectTween(
    begin: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kLogoHeight),
    end: new Rect.fromLTWH(0.0, 0.0, kLogoWidth, kImageHeight),
  );

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.identity()..scale(height / kLogoHeight),
      alignment: Alignment.topCenter,
      child: new SizedBox(
        width: kLogoWidth,
        child: new Stack(
          overflow: Overflow.visible,
          children: [
            new Positioned.fromRect(
              rect: _imageRectTween.lerp(t),
              child: new Image.asset(
                "imgs/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            new Positioned.fromRect(
              rect: _textRectTween.lerp(t),
              child: new Opacity(
                opacity: _textOpacity.transform(t),
                child: new Text('PUPUR',
                    style: titleStyle, textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}