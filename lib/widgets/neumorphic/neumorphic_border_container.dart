
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class NeuBorderContainer extends StatelessWidget {
  final double thickness;
  final Color borderColor;
  final double outerDepth;
  final double innerIntensity;
  final double innerDepth;
  final Color innerColor;
  final Widget child;

  const NeuBorderContainer(
      {Key? key,
      required this.child,
      this.thickness = 6.0,
      this.innerDepth = -2,
      this.outerDepth = 10,
      this.borderColor = const Color(0xffDFE8ED),
      this.innerColor =const Color(0xffE5F1FB),
      this.innerIntensity = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 20,
        ),
        child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: outerDepth,
                lightSource: LightSource.topLeft,
                color: borderColor),
            child: Padding(
                padding: EdgeInsets.all(thickness),
                child: Neumorphic(
                    style: NeumorphicStyle(
                      color: innerColor, 
                      shadowDarkColor: Color(0xFFA7BCCF),
                      lightSource: LightSource.topLeft,
                      depth: innerDepth,
                      intensity: innerIntensity,
                      shadowLightColorEmboss: Color(0xffFAFDFF),
                      shape: NeumorphicShape.concave,
                      surfaceIntensity: 0,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0), child: child)))));
  }
}
