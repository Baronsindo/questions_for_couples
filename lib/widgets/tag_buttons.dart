import 'package:flutter/material.dart';
import 'package:questions_for_couples/models/Tag.dart';

class TagButtons extends StatefulWidget {
  TagButtons({Key? key}) : super(key: key);
  static List checked = [];
  static String checkedSql = "";
  @override
  _TagButtonsState createState() => _TagButtonsState();
}

class _TagButtonsState extends State<TagButtons> {
  var tag_list = [
    new Tag(id: 1, value: "favorite", text: "favorite", isPressed: false),
    new Tag(id: 1, value: "sex", text: "sex", isPressed: false),
    new Tag(id: 1, value: "relationships", text: "relations", isPressed: false),
    new Tag(id: 1, value: "marriage", text: "marriage", isPressed: false),
    new Tag(id: 1, value: "future", text: "future", isPressed: false),
    new Tag(id: 1, value: "self", text: "self", isPressed: false),
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> elevatedButtonList = [];

    void tagClick(but) {
      setState(() {
        but.isPressed = !but.isPressed;
      });

      TagButtons.checked = [];
      TagButtons.checkedSql = "where tags LIKE";
      tag_list
          .where((element) => element.isPressed == true)
          .toList()
          .forEach((element) {
        TagButtons.checked.add("%" + element.value + "%");
        TagButtons.checkedSql += " '%" + element.value + "%' or tags LIKE";
      });
      TagButtons.checkedSql += " '%i lova nada%' ";
      //TagButtons.checked =    ;
    }

    tag_list.forEach((tagListItem) {
      elevatedButtonList.add(Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: ElevatedButton(
          onPressed: () => {
            tagClick(tagListItem),
          },
          child: Text(tagListItem.text),
          style: ElevatedButton.styleFrom(
            primary: tagListItem.isPressed
                ? const Color(0xFF96507F)
                : const Color(0xFFABB8CE),
            onPrimary: tagListItem.isPressed ? Colors.white : Colors.black,
            onSurface: tagListItem.isPressed ? Colors.grey : Colors.black,
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
