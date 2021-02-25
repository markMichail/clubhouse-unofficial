import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquircleUser extends StatelessWidget {
  final String name;
  final bool isSpeaking;
  final String photoUrl;
  final double size;

  SquircleUser(
      {this.name,
      this.isSpeaking,
      @required this.photoUrl,
      @required this.size});
  @override
  Widget build(BuildContext context) {
    if (this.name == null && this.isSpeaking == null)
      return _squircleUserImageOnly();
    else if (this.isSpeaking == null || this.isSpeaking == false)
      return _squircleUser();
    else
      return _squircleUserSpeaking();
  }

  Widget _squircleUserImageOnly() {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: size,
        height: size,
        child: Material(
          color: Colors.grey,
          shape: _SquircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            photoUrl,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person);
            },
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _squircleUser() {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          child: Material(
            shape: _SquircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              photoUrl,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(name.split(" ")[0]),
      ],
    );
  }

  Widget _squircleUserSpeaking() {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          child: Material(
            color: Colors.transparent,
            shape: _SquircleBorder(
              side: BorderSide(
                color: Colors.blueGrey[800],
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Material(
                shape: _SquircleBorder(),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  photoUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(name.split(" ")[0]),
      ],
    );
  }
}

class _SquircleBorder extends ShapeBorder {
  final BorderSide side;
  final double superRadius;

  const _SquircleBorder({this.side: BorderSide.none, this.superRadius: 5.0})
      : assert(side != null),
        assert(superRadius != null);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  ShapeBorder scale(double t) {
    return new _SquircleBorder(
      side: side.scale(t),
      superRadius: superRadius * t,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    // print("c");
    return _squirclePath(rect.deflate(side.width), superRadius);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return _squirclePath(rect, superRadius);
  }

  static Path _squirclePath(Rect rect, double superRadius) {
    final c = rect.center;
    final dx = c.dx * (1.0 / superRadius);
    final dy = c.dy * (1.0 / superRadius);
    return new Path()
      ..moveTo(c.dx, 0.0)
      ..relativeCubicTo(c.dx - dx, 0.0, c.dx, dy, c.dx, c.dy)
      ..relativeCubicTo(0.0, c.dy - dy, -dx, c.dy, -c.dx, c.dy)
      ..relativeCubicTo(-(c.dx - dx), 0.0, -c.dx, -dy, -c.dx, -c.dy)
      ..relativeCubicTo(0.0, -(c.dy - dy), dx, -c.dy, c.dx, -c.dy)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        var path = getOuterPath(rect.deflate(side.width / 2.0),
            textDirection: textDirection);
        canvas.drawPath(path, side.toPaint());
    }
  }
}
