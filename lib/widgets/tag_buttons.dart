import 'package:flutter/material.dart';

class Tag {
  int id;
  String text;
  bool isPressed;
  Tag({required this.id, required this.text, required this.isPressed});
}

class TagButtons extends StatefulWidget {
  TagButtons({Key? key}) : super(key: key);
  static List checked = [];
  @override
  _TagButtonsState createState() => _TagButtonsState();
}

class _TagButtonsState extends State<TagButtons> {
  var tag_list = [
    new Tag(id: 1, text: "Adil", isPressed: false),
    new Tag(id: 1, text: "Ali", isPressed: false),
    new Tag(id: 1, text: "Khadija", isPressed: false),
    new Tag(id: 1, text: "Nada", isPressed: false),
    new Tag(id: 1, text: "Kimo", isPressed: false),
    new Tag(id: 1, text: "youssef", isPressed: false),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> elevatedButtonList = [];

    void tagClick(but) {
      setState(() {
        but.isPressed = !but.isPressed;
      });
      TagButtons.checked =
          tag_list.where((element) => element.isPressed == true).toList();
    }

    tag_list.forEach((tag_list_item) {
      elevatedButtonList.add(Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: ElevatedButton(
          onPressed: () => {
            tagClick(tag_list_item),
          },
          child: Text(tag_list_item.text),
          style: ElevatedButton.styleFrom(
            primary: tag_list_item.isPressed
                ? const Color(0xFF96507F)
                : const Color(0xFFABB8CE),
            onPrimary: tag_list_item.isPressed ? Colors.white : Colors.black,
            onSurface: tag_list_item.isPressed ? Colors.grey : Colors.black,
          ),
        ),
      ));
    });

    return Wrap(
      spacing: 10,
      alignment: WrapAlignment.center,
      children: elevatedButtonList,
    );
  }
}
