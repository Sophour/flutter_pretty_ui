import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meditivitytest2/services/background_audio_service/background_audio_task.dart';

import 'exercise_timer.dart';



class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlayerPageWidget();
  }
}



class PlayerPageWidget extends StatefulWidget {
  PlayerPageWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PlayerPageDefaultState createState() => _PlayerPageDefaultState();
}

class _PlayerPageDefaultState extends State<PlayerPageWidget> with WidgetsBindingObserver{

  bool _settingsTabIsActive = false;
  bool _audiotrackIsPaused = false;

  bool counting = false;
  Duration duration;
  Duration timePassed;
  Function myTimerCallback;

  @override
  void initState( ) {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();


  }

  @override
  void dispose() {
    disconnect();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Color(0xffafb6bc)),
    onPressed: () {
    Navigator.pop(context);
    },
      ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.pause),
              onPressed: (){
                AudioService.pause();
              },
            ),
            IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: (){
                AudioService.start(
                  backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                  androidNotificationChannelName: 'Audio Service Demo',
                  notificationColor: 0xff413c69,
                  androidNotificationIcon: 'mipmap/ic_launcher',

                  enableQueue: true,
                );
              },

            ),
            IconButton(
              icon: Icon(Icons.settings),
            )
          ],
      ),


      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://www.nacional.hr/wp-content/uploads/2019/04/rain-3443977_1920.jpg'),
              fit: BoxFit.fitHeight,

            ),
          ),

          child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(

            child: Text('Title Title'),
          ),
          Container(
            child: SizedBox(
            width: 230,
            height: 230,
              child: ExerciseTimer(
                  counting: counting,
                  duration: Duration(seconds: 120),
                  timePassed: Duration(seconds: 0)
              ),
          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              OutlineButton(
                child: Text('Pause', style: TextStyle(color: Colors.white),),
                onPressed: (){

                },
              )
            ],
          )
        ],

      )),

    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        connect();
        break;
      case AppLifecycleState.paused:
        disconnect();
        break;
      default:
        break;
    }
  }
}

