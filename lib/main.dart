import 'package:flutter/material.dart';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:questions_for_couples/widgets/tag_buttons.dart';
import 'package:flutter/services.dart';
import 'package:questions_for_couples/tools/database_hepler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:questions_for_couples/models/Tag.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:decorated_icon/decorated_icon.dart';

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
        fontFamily: 'Ubuntu',
        // This is the theme of your
        //theme: ThemeData(fontFamily: 'Raleway'), application.
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
      home: SplashScreenView(
        navigateRoute: MyHomePage(),
        duration: 3000,
        imageSize: 165,
        imageSrc: "assets/images/splash_logo.png",
        backgroundColor: AppConstant.main,
        text: "QueMe",
        textStyle: TextStyle(
          fontSize: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var db = new DatabaseHelper();
  bool spinerVisibility = false;
  late AnimationController _controller;
  Tween<double> _tween = Tween(begin: 0.85, end: 0.9);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    _controller.repeat(reverse: true);
  }

  void search() async {
    print(TagButtons.checkedSql);
    setState(() {
      spinerVisibility = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (TagButtons.checked.length == 0) {
      db.getRandomQuestion().then((value) => {
            alertDialogMaker(value[0].text),
            setState(() {
              spinerVisibility = false;
            })
          });
    } else {
      db.getQuestionByTag(TagButtons.checkedSql).then((value) => {
            alertDialogMaker(value[0].text),
            setState(() {
              spinerVisibility = false;
            })
          });
    }
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
        title: Center(
          child: Text(
            'Questions For Couples',
            style: TextStyle(
              fontFamily: "Ubuntu",
            ),
          ),
        ),
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
                    "--------   Chose a category   --------",
                    style: TextStyle(
                      color: AppConstant.label,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TagButtons(),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => {search()},
                      child: ScaleTransition(
                        scale: _tween.animate(
                          CurvedAnimation(
                              parent: _controller, curve: Curves.fastOutSlowIn),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            DecoratedIcon(
                              Icons.favorite,
                              color: AppConstant.main,
                              size: 300,
                              shadows: [
                                BoxShadow(
                                  offset: const Offset(3.0, 3.0),
                                  // blurRadius: 2.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Text(
                              "?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppConstant.clicked_button_text,
                                fontSize: 160,
                              ),
                            ),
                          ],
                        ),
                      ),
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
              child: SpinKitFoldingCube(
                  size: 120.0,
                  itemBuilder: (_, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? AppConstant.main
                            : AppConstant.copy_button,
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
