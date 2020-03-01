import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExerciseTimer extends StatefulWidget {
  final bool counting;
  final Duration duration;
  final Duration timePassed;

  ExerciseTimer({Key key, this.counting,
    @required this.duration, this.timePassed}):super(key: key);

  @override
  _ExerciseTimerState createState() =>
      _ExerciseTimerState(counting: counting,
      duration: duration,
      timePassed: timePassed);
}

class _ExerciseTimerState extends State<ExerciseTimer> with TickerProviderStateMixin {
  AnimationController controller;
  bool counting = false;
  Duration duration;
  Duration timePassed;

  Function callback;


  _ExerciseTimerState({Key key, this.counting : false,
  this.duration, this.timePassed});

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 120),
    );


  }

  @override
  Widget build(BuildContext context) {
    print('Timer is rebuit');
    setupCountdownTimer();

    return Container(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(

          children: <Widget>[
          Expanded(
            child: Align(
            alignment: FractionalOffset.center,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                      child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child){
                        return new CustomPaint(
                          painter: TimerPainter(
                            animation: controller,
                            color: Colors.pink,
                            backgroundColor: Colors.grey[100],
                          ),
                        );
                      },
                  )),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AnimatedBuilder(
                            animation: controller,
                            builder: (BuildContext context, Widget child) {
                              return Text(
                                timerString,
                                style: TextStyle(color: Colors.white),
                              );
                            }),
                        Text(
                          "day 1",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),),
            Container(
              margin: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return Icon(controller.isAnimating
                            ? Icons.pause
                            : Icons.play_arrow);

                        // Icon(isPlaying
                        // ? Icons.pause
                        // : Icons.play_arrow);
                      },
                    ),
                    onPressed: () {
                      // setState(() => isPlaying = !isPlaying);

                      if (controller.isAnimating) {
                        controller.stop(canceled: true);
                      } else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    },
                  )
                ],
              ),
            )
          ]
    )));
  }

  setupCountdownTimer(){
    if (counting) {
      controller.stop(canceled: true);
      counting = false;
    } else {
      controller.reverse(
        ///TODO set animation progress?
          from: controller.value == 0.0
              ? 1.0
              : controller.value);
    }
  }
  stopCountdownTimer(){}
  resumeCountdownTimer(){}

  setupCountdownTimer2(bool isCounting) =>
   setState(() {counting = isCounting;});

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString().padLeft(2, '0')}';
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter( {
    this.animation,
    this.backgroundColor,
    this.color,
  } ) : super( repaint: animation );

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint( Canvas canvas, Size size ) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);

  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }

}
