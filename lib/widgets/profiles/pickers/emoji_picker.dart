import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class NeuEmojiPicker extends StatefulWidget {
  final void Function(Category, Emoji) onEmojiSelected;

  NeuEmojiPicker({required this.onEmojiSelected, Key? key}) : super(key: key);

  @override
  _NeuEmojiPickerState createState() => _NeuEmojiPickerState();
}

class _NeuEmojiPickerState extends State<NeuEmojiPicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    // TODO: implement initState
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 100),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.ease));

     _animationController.forward();   

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.transparent,
      body: SlideTransition(
        position: _slideAnimation,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.33,
            child: EmojiPicker(
              onBackspacePressed: () {
                _animationController.reverse();
                Navigator.pop(context);
              },
              onEmojiSelected: widget.onEmojiSelected,
            ),
          ),
        ),
      ),
    );
  }
}
/* */