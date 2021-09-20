import 'package:flutter/material.dart';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:questions_for_couples/widgets/tag_buttons.dart';
import 'package:flutter/services.dart';
import 'package:questions_for_couples/tools/database_hepler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:questions_for_couples/models/Tag.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: AppConstant.clicked_button,
          ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = new DatabaseHelper();
  bool spinerVisibility = false;
  void search() async {
    print(TagButtons.checkedSql);
    setState(() {
      spinerVisibility = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (TagButtons.checked.length == 0) {
      db.getRandomQuestion().then((value) => {
            alertDialogMaker(value[0].text),
          });
    } else {
      db.getQuestionByTag(TagButtons.checkedSql).then((value) => {
            alertDialogMaker(value[0].text),
          });
    }
    setState(() {
      spinerVisibility = false;
    });
  }

  void alertDialogMaker(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(child: Text(message)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppConstant.close_button,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();

                      setState(() {
                        spinerVisibility = false;
                      });
                    },
                    child: const Text('Close'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: AppConstant.copy_button,
                    ),
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: message))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Copied to your clipboard !')));
                      });
                      Navigator.of(context).pop();

                      setState(() {
                        spinerVisibility = false;
                      });
                    },
                    child: const Text('Copy'),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Questions For Couples')),
        backgroundColor: Color(0xFFF53982),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Text(
                    "------------ Chose a category ------------",
                    style: TextStyle(color: AppConstant.label),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TagButtons(),
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          onPressed: () => {search()},
                          icon: Icon(Icons.favorite),
                          iconSize: 300,
                          color: AppConstant.main,
                        ),
                        GestureDetector(
                          onTap: () => {search()},
                          child: Text(
                            "Get \n a Question",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppConstant.clicked_button_text,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: spinerVisibility,
            child: Container(
              color: AppConstant.clicked_button_text,
              child: SpinKitFoldingCube(itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven ? AppConstant.main : AppConstant.info,
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
