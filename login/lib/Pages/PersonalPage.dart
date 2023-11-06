import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/DTO/StatisticResponseDTO.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({
    Key? key,
    required this.loginId,
    required this.userName,
  }) : super(key: key);
  final int loginId;
  final String userName;

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  StatisticResponseDTO? statisticResponse;

  @override
  void initState() {
    super.initState();
    fetchStatisic();
  }

  void fetchStatisic() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/statistic/messageType?memberId=${widget.loginId}'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print('서버응답: $responseData');

        StatisticResponseDTO statisticDTO =
            StatisticResponseDTO.fromJson(responseData);

        setState(() {
          statisticResponse = statisticDTO;
        });
      } else {
        print('오류 발생: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during fetching statistics: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFF51C878),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '이름: ${widget.userName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 30,
          ),
          Text(
            '채팅 통계',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Container(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: PieChart(
                    percentage: statisticResponse?.sta_hate ?? 0,
                  ),
                ),
              ),
              SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: const Color(0xFF51C878),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Clean: ${statisticResponse?.nClean ?? 0}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color:const Color.fromARGB(255, 244, 54, 54),
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Hate: ${statisticResponse?.nHate ?? 0}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}

class PieChart extends CustomPainter {
  final int percentage;
  final double textScaleFactor;

  PieChart({required this.percentage, this.textScaleFactor = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    // 화면에 그릴 paint 정의
    Paint paint = Paint()
      ..color = const Color(0xFF51C878)
      ..strokeWidth = 18.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // 원의 반지름을 구한다. 선의 굵이에 영향을 받지 않게 보정
    double radius = min(size.width / 2 - paint.strokeWidth / 2,
        size.height / 2 - paint.strokeWidth / 2);

    // 그래프가 가운데로 그려지도록 좌표를 정한다.
    Offset center = Offset(size.width / 2, size.height / 2);

    // 원 그래프를 그린다.
    canvas.drawCircle(center, radius, paint);

    // 호(arc)의 각도를 정한다. 정해진 각도만큼만 그린다.
    double arcAngle = 2 * pi * (percentage / 100.0);

    // 호를 그릴때 색 변경
    paint..color = const Color.fromARGB(255, 244, 54, 54);

    // 호(arc)를 그린다.
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paint);

    // 텍스트를 화면에 표시한다.
    drawText(canvas, size, '$percentage %');
  }

  // 원의 중앙에 텍스트를 적는다.
  void drawText(Canvas canvas, Size size, String text) {
    double fontSize = getFontSize(size, text);

    TextSpan sp = TextSpan(
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black),
        text: text);

    TextPainter tp = TextPainter(text: sp, textDirection: TextDirection.ltr);

    // 필수로 호출해야 한다. 텍스트 페인터에 그려질 텍스트의 크기와 방향을 결정한다.
    tp.layout();

    double dx = size.width / 2 - tp.width / 2;
    double dy = size.height / 2 - tp.height / 2;

    Offset offset = Offset(dx, dy);
    tp.paint(canvas, offset);
  }

  // 화면 크기에 비례하도록 텍스트 폰트 크기를 정한다.
  double getFontSize(Size size, String text) {
    return size.width / (text.length+text.length) * textScaleFactor;
  }

  // 다르면 다시 그리도록
  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }
}
