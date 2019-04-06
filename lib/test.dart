import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colombia',
      theme: ThemeData(fontFamily: 'WorkSansMedium'),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  AudioPlayer audioPlayer = AudioPlayer();
  int index = 0;
  List colors = [
    [Colors.lightBlue, Colors.lightBlue[300], Color(0xFFC2B280)],
    [Colors.lightBlue, Colors.lightBlue[300], Colors.green[700]],
    [Color(0xFF00283a), Color(0xFF1c698c), Color(0xFF99874f)],
  ];

  List question = ['Capital'];
  List options = [
    ['Bogotá', 'Medellin', 'Cali']
  ];
  List answer = [0];

  _play() async {
    int result = await audioPlayer.play(
        "http://www.vogelstimmen.info/Vogelstimmen_GRATIS/Silbermoewe_Larus_argentatus_R_AMPLE-E06351R.mp3");
    if (result == 1) {
      // success
    }
  }

  @override
  Widget build(BuildContext context) {
    // _play();
    return Scaffold(
        body: Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.7, 0.8],
                    colors: colors[index],
                  ),
                ),
                // child: FlareActor(
                //   "assets/Bob.flr",
                //   animation: "Jump",
                // ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Colombia',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white)),
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Discover the hidden wonders of this beautiful country',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Swiper(
              onIndexChanged: (int idx) {
                setState(() {
                  index = idx % 3;
                });
                // _play();
              },
              itemBuilder: (BuildContext context, int idx) =>
                  InfoCard(question[idx], options[idx], answer[idx]),
              itemCount: question.length,
              itemWidth: 400,
              itemHeight: 500,
              layout: SwiperLayout.STACK,
            ),
          ],
        ),
      ],
    ));
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final List options;
  final int answer;

  InfoCard(this.title, this.options, this.answer);

  _options() {
    List<Widget> list = List<Widget>();
    for (var i = 0; i < options.length; i++) {
      list.add(Padding(padding: EdgeInsets.all(10), child: Text(options[i])));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40),
      child: FlipCard(
        back: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.title),
                    Expanded(
                      child: FlareActor(
                        "assets/Bob.flr",
                        animation: "Dance",
                      ),
                    ),
                    Container(
                      color: Colors.yellow,
                      child:
                          Text(title, style: Theme.of(context).textTheme.title),
                    ),
                  ],
                ))),
        front: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(title, style: Theme.of(context).textTheme.title),
                ),
                // Expanded(
                //   child: FlareActor(
                //     "assets/Bob.flr",
                //     animation: "Wave",
                //   ),
                // ),
                Expanded(
                  child: Column(children: _options()),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[300],
                  child: Text('Reveal the answer',
                      style: Theme.of(context).textTheme.title),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
