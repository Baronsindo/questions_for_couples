import 'package:flutter/material.dart';
import 'package:questions_for_couples/models/Tag.dart';
import 'package:questions_for_couples/tools/app_constant.dart';

class TagButtons extends StatefulWidget {
  TagButtons({Key? key}) : super(key: key);
  static List checked = [];
  static String checkedSql = "";
  @override
  _TagButtonsState createState() => _TagButtonsState();
}

class _TagButtonsState extends State<TagButtons> {
  var tagList = [
    new Tag(id: 1, value: "self", text: "Self", isPressed: false),
    new Tag(id: 1, value: "relationships", text: "Relations", isPressed: false),
    new Tag(id: 1, value: "favorite", text: "Favorite", isPressed: false),
    new Tag(id: 1, value: "marriage", text: "Marriage", isPressed: false),
    new Tag(id: 1, value: "future", text: "Future", isPressed: false),
    new Tag(id: 1, value: "sex", text: "Sex", isPressed: false),
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
      tagList
          .where((element) => element.isPressed == true)
          .toList()
          .forEach((element) {
        TagButtons.checked.add("%" + element.value + "%");
        TagButtons.checkedSql += " '%" + element.value + "%' or tags LIKE";
      });
      TagButtons.checkedSql += " '%i lova nada%' ";
      //TagButtons.checked =    ;
    }

    tagList.forEach((tagListItem) {
      elevatedButtonList.add(Container(
        width: MediaQuery.of(context).size.width * 0.27,
        child: ElevatedButton(
          onPressed: () => {
            tagClick(tagListItem),
          },
          child: Text(
            tagListItem.text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: tagListItem.isPressed
                ? AppConstant.clicked_button
                : AppConstant.button,
            onPrimary: tagListItem.isPressed
                ? AppConstant.clicked_button_text
                : AppConstant.button_text,
            // onSurface: tagListItem.isPressed
            //     ? AppConstant.clicked_button
            //     : AppConstant.clicked_button,
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
