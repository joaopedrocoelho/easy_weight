import 'package:easy_weight/models/profile_model.dart';
import 'package:easy_weight/widgets/add_record_form/neu_close_button.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
  Colors.white
];


class NeuColorPicker extends StatefulWidget {
  final void Function(Color) onColorChanged;
  final Color selectedColor;
  
  NeuColorPicker(
      {required this.onColorChanged,
      required this.selectedColor,  Key? key})
      : super(key: key);

  @override
  _NeuColorPickerState createState() => _NeuColorPickerState();
}

class _NeuColorPickerState extends State<NeuColorPicker>
    with SingleTickerProviderStateMixin {
      int _portraitCrossAxisCount = 4;
  int _landscapeCrossAxisCount = 5;
    double _borderRadius = 30;
  double _blurRadius = 5;
  double _iconSize = 14;
  late Color _selectedColor;
  late AnimationController _controller;
  late Animation<double> _animation;
  late NeumorphicThemeData theme;
 

   Widget pickerLayoutBuilder(
      BuildContext context, List<Color> colors, PickerItem child) {
        Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait
            ? _portraitCrossAxisCount
            : _landscapeCrossAxisCount,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

 Widget pickerItemBuilder(
      Color color, bool isCurrentColor, void Function() changeColor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: isCurrentColor ? -2 : 5,
          boxShape: NeumorphicBoxShape.circle(),
          shape: isCurrentColor ? NeumorphicShape.concave : NeumorphicShape.convex,
          intensity: 0.8
          
        ),
        child: Container(
          
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            border: isCurrentColor ? Border.all(color: theme.defaultTextColor, width: 4) : null,
            color: color.withOpacity(0.4),
            
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: changeColor,
              borderRadius: BorderRadius.circular(_borderRadius),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isCurrentColor ? 1 : 0,
                child: Icon(
                  Icons.done,
                  size: _iconSize,
                  color: theme.defaultTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  


  @override
  void initState() {
    theme = NeumorphicTheme.currentTheme(context);
    _selectedColor = widget.selectedColor;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = NeumorphicTheme.currentTheme(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ScaleTransition(
        scale: _animation,
        child: Align(
          child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.4),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 460,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16.0, left: 12),
                              child: Text("Pick a color",
                                  style: theme.textTheme.headline3),
                            ),
                            NeuCloseButton(onPressed: () {
                              _controller.reverse();
                              Navigator.pop(context);
                            })
                          ],
                        ),
                     
                        BlockPicker(
                            pickerColor: _selectedColor,
                            availableColors: colors,
                            layoutBuilder: pickerLayoutBuilder,
                            itemBuilder: pickerItemBuilder,
                            onColorChanged: widget.onColorChanged,
                        )
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

    }