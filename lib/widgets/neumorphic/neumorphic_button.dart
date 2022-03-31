
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final bool isVisible;
  final double? intensity;

  const NeuButton(
      {Key? key,
      required this.onPressed,
      this.child,
      required this.isVisible,
      this.intensity})
      : super(key: key);

  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  //double _opacity = 0;
  Tween<double> _startAnimation = Tween<double>(begin: 0, end: 5);
  Tween<double> _reverseAnimation = Tween<double>(begin: 5, end: 0);

  @override
  void initState() {
    super.initState();
  }

  /* void _setVisible() {
    
      setState(() {
        _opacity = 1;
      });
    
  }

  void _setInvisible() {
    _opacity = 0;
  }
 */
 

  @override
  Widget build(BuildContext context) {
    /* WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.isVisible ? _setVisible() : _setInvisible();
    }); */
    
    final theme = NeumorphicTheme.currentTheme(context);

    return TweenAnimationBuilder<double>(
        tween: widget.isVisible ? _startAnimation : _reverseAnimation,
        duration: Duration(milliseconds: 100),
        builder: (_, depth, __) {
          //print('depth: $depth');
          return NeumorphicButton(
              onPressed: widget.isVisible ? widget.onPressed : () {},
              style: NeumorphicStyle(
                color: theme.baseColor,
                depth: depth,
                surfaceIntensity: 0.3,
                intensity: widget.intensity ?? 0.9,
                shape: NeumorphicShape.convex,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
              ),
              child: Center(
                  child: AnimatedOpacity(
                      duration: Duration(milliseconds: 100),
                      opacity: widget.isVisible ? 1 : 0,
                      child: widget.child)));
        });
  }
}
