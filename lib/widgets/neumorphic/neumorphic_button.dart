import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuButton extends StatefulWidget {
  final VoidCallback addOnPressed;
  final Widget? child;
  final bool isVisible;

  const NeuButton(
      {Key? key,
      required this.addOnPressed,
      this.child,
      required this.isVisible})
      : super(key: key);

  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  double _opacity = 0;
  Tween<double> _startAnimation = Tween<double>(begin: 0, end: 5);
  Tween<double> _reverseAnimation = Tween<double>(begin: 5, end: 0);

  @override
  void initState() {
    super.initState();
  }

  void _setVisible() {
    
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  void _setInvisible() {
    _opacity = 0;
    
  }

  @override
  Widget build(BuildContext context) {
    widget.isVisible ? _setVisible() : _setInvisible();

    return TweenAnimationBuilder<double>(
        tween: widget.isVisible ? _startAnimation : _reverseAnimation,
        duration: Duration(milliseconds: 150),
        builder: (_, depth, __) {
          return NeumorphicButton(
              onPressed: widget.isVisible ? widget.addOnPressed : () {},
              style: NeumorphicStyle(
                color: Color(0xffE5F1FB),
                shadowDarkColor: Color(0xffA7BCCF),
                shadowDarkColorEmboss: Color(0xffA7BCCF),
                shadowLightColor: Color(0xffFAFDFF),
                depth: depth,
                surfaceIntensity: 0.3,
                intensity: 0.8,
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
              ),
              child: Center(
                  child: AnimatedOpacity(
                      duration: Duration(milliseconds: 150),
                      opacity: _opacity,
                      child: widget.child)));
        });
  }
}
