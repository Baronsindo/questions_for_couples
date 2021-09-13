import 'package:flutter/material.dart';
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
        primarySwatch: Colors.blue,
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
  }

  void alertDialogMaker(message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('The Question is '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: message)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Copied to your clipboard !')));
              });
              Navigator.of(context).pop();

              setState(() {
                spinerVisibility = false;
              });
            },
            child: const Text('Copy & close'),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFF96507F),
                    const Color(0xFF0F0A2D),
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              children: [
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
                          color: Color(0xFFF53982),
                        ),
                        GestureDetector(
                          onTap: () => {search()},
                          child: Text(
                            "Get \n a Question",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
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
              color: Color(0xFFABB8CE),
              child: SpinKitFoldingCube(itemBuilder: (_, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: index.isEven
                        ? const Color(0xFFF53982)
                        : const Color(0xFF96507F),
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
