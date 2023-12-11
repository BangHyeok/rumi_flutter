import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:senior_fitness_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import 'package:senior_fitness_app/video2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:senior_fitness_app/posedetecter.dart';

Future<List<dynamic>> fetchData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/fitness'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

class Myfit extends StatefulWidget {
  const Myfit({Key? key}) : super(key: key);

  @override
  State<Myfit> createState() => _Myfit();
}


class _Myfit extends State<Myfit> {
  Future<List<dynamic>>? futureData;
  String? name;
  String? birth;
  String? gender;
  String? age;
  VideoPlayerController? _controller;
  final String videoPath = 'images/2.mp4'; // 동영상 URL를 지정해주세요.

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
    futureData = fetchData();
    _loadData();
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      birth = prefs.getString('birth');
      gender = prefs.getString('gender');
      if (birth != null) {
        DateTime birthDate = DateFormat('yyyy-MM-dd').parse(birth!);
        age = calculateAge(birthDate).toString();
      }

    });
  }

  int calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    final int month1 = currentDate.month;
    final int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      final int day1 = currentDate.day;
      final int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static String youtubeId = 'AdYRASHRKwE';

  final YoutubePlayerController _con = YoutubePlayerController(
    initialVideoId: youtubeId,
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
  bool showOtherData = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: 80.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0), // 여백 추가
          child: Image.asset('images/rumi.png'),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0), // 텍스트 위쪽 여백 추가
          child: Text(
            '루미',
            style: TextStyle(
              letterSpacing: 2.0,
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              height: 1.2, // 텍스트의 높이 조절
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child : Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 40.0, 0.0, 0.0),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  '$name 님의 결과입니다.',
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              FutureBuilder<List<dynamic>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return CircularProgressIndicator();
                },
              ),
              SizedBox(
                height: 30.0,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 50,
                    color: Color(0xFF1F4EF5), // 'CEE9E3' 색상
                    child: Center(
                      child: Text(
                        '나이',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // 텍스트 색상을 흰색으로 변경
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 50,
                    color: Colors.white,
                    child: Center(
                      child: Text('$age', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    color: Color(0xFF1F4EF5), // 'CEE9E3' 색상
                    child: Center(
                      child: Text(
                        '신체나이',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white, // 텍스트 색상을 흰색으로 변경
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 110,
                    height: 50,
                    color: Colors.white,
                    child: Center(
                      child: Text('80', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
<<<<<<< HEAD
                width: MediaQuery.of(context).size.width * 0.2,
=======
                width: MediaQuery.of(context).size.width * 0.6,
>>>>>>> b1f6867815468945e32ba6614fd599a5e0fb7854
                height: MediaQuery.of(context).size.width * 0.1,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PoseDetectorView()),
                    );
                  },
                  child: Text(
                    '임시버튼',
                    style: TextStyle(color: Colors.white, fontSize: 28.0),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF1F4EF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_controller!.value.isInitialized) {
                    setState(() {
                      _controller!.value.isPlaying
                          ? _controller!.pause()
                          : _controller!.play();
                    });
                  }
                  // 여기에 측정하기 버튼이 눌렸을 때의 동작 추가
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF1F4EF5), // 색상 코드 CEE9E3
                  minimumSize: const Size(210.0, 70.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '측정하기',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // 텍스트 색상을 흰색으로 변경
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              // 다른 데이터를 보여줄지 여부를 저장하는 변수
              Container(
              width: 800,
              height: 700,
              decoration: BoxDecoration(
                color: Color(0xFF83B4F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            child: Text(
                              showOtherData ? '30초간 앉았다 일어서기 [하체 근력]':'30초간 아령 들기 [상체근력]',
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              showOtherData = !showOtherData; // 버튼 클릭 시 다른 데이터를 보여줄지 여부를 변경
                            });
                          },
                          child: Text(
                            '→',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: 300.0, // 조절하고자 하는 너비
                    height: 200.0, // 조절하고자 하는 높이
                    child: showOtherData
                        ? Container(
                      // 다른 데이터 보여주는 위젯 구현
                    )
                        : LineChart(
                      LineChartData(
                        backgroundColor: Color(0xFFFFFDFD),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        minX: 0,
                        maxX: 7,
                        minY: 0,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 30),
                              FlSpot(1, 40),
                              FlSpot(2, 20),
                              FlSpot(3, 60),
                              FlSpot(4, 50),
                              FlSpot(5, 70),
                              FlSpot(6, 70),
                              FlSpot(7, 90),
                            ],
                            isCurved: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: 300.0, // 조절하고자 하는 너비
                    height: 200.0, // 조절하고자 하는 높이
                    child: showOtherData
                        ? Container(
                      // 다른 데이터 보여주는 위젯 구현
                    )
                    : YoutubePlayer(
                        controller: _con,
                    ),
                    ),
              ],
            ),
          ),
         ],
        ),
      ),
    ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                  // 여기에 메인으로 이동 버튼이 눌렸을 때의 동작 추가
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF1F4EF5),
                  minimumSize: const Size(210.0, 70.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  '처음으로 이동',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
