import 'package:flutter/material.dart';
import 'package:questions_for_couples/tools/app_constant.dart';
import 'package:questions_for_couples/widgets/tag_buttons.dart';
import 'package:flutter/services.dart';
import 'package:questions_for_couples/tools/database_hepler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:questions_for_couples/tools/ad_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  //? variables for ads
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

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

    //? init ads
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
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
                ),
                Container(
                  // TODO : Testi hada f device lakhor
                  width: _bannerAd.size.width.toDouble(),
                  height: _bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),
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
