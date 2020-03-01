import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: 5739820,
      artUri:
      "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    MediaItem(
      id: "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: 2856950,
      artUri:"https://www.meme-arsenal.com/memes/2d9182fabc8b91e05f023061e63c3e40.jpg",
      //"https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    ),
    new MediaItem(
      id: "https://t2.akniga.club/b/14223/eBD7gVXw775lOeP-1xmvsdZzaC3HWqHuGCK5oaI1DUI,/02.%20%D0%A1%D0%B0%D0%BF%D0%BA%D0%BE%D0%B2%D1%81%D0%BA%D0%B8%D0%B9%20%D0%90%D0%BD%D0%B4%D0%B6%D0%B5%D0%B9%20-%20%D0%91%D0%B0%D1%88%D0%BD%D1%8F%20%D0%9B%D0%B0%D1%81%D1%82%D0%BE%D1%87%D0%BA%D0%B8.mp3",
      album: "Witcher",
      title: "Zirael-2",
      artist: "Sapkovsky",
      duration: 2856950,
      artUri:
      "https://www.meme-arsenal.com/memes/2d9182fabc8b91e05f023061e63c3e40.jpg",
    ),
    new MediaItem(
      id: "https://t2.akniga.club/b/14223/eBD7gVXw775lOeP-1xmvsdZzaC3HWqHuGCK5oaI1DUI,/01.%20%D0%A1%D0%B0%D0%BF%D0%BA%D0%BE%D0%B2%D1%81%D0%BA%D0%B8%D0%B9%20%D0%90%D0%BD%D0%B4%D0%B6%D0%B5%D0%B9%20-%20%D0%91%D0%B0%D1%88%D0%BD%D1%8F%20%D0%9B%D0%B0%D1%81%D1%82%D0%BE%D1%87%D0%BA%D0%B8.mp3",
      album: "Witcher",
      title: "Zirael",
      artist: "Sapkovsky",
      duration: 2856950,
      artUri:
      "https://www.meme-arsenal.com/memes/2d9182fabc8b91e05f023061e63c3e40.jpg",
    ),
  ];
  int _queueIndex = -1;
  AudioPlayer audioPlayer = new AudioPlayer();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;

  bool get hasNext => _queueIndex + 1 < _queue.length;

  bool get hasPrevious => _queueIndex > 0;

  MediaItem get mediaItem => _queue[_queueIndex];

  BasicPlaybackState _stateToBasicState(AudioPlaybackState state) {
    switch (state) {
      case AudioPlaybackState.none:
        return BasicPlaybackState.none;
      case AudioPlaybackState.stopped:
        return BasicPlaybackState.stopped;
      case AudioPlaybackState.paused:
        return BasicPlaybackState.paused;
      case AudioPlaybackState.playing:
        return BasicPlaybackState.playing;
//      case AudioPlaybackState.buffering:
//        return BasicPlaybackState.buffering;
      case AudioPlaybackState.connecting:
        return _skipState ?? BasicPlaybackState.connecting;
      case AudioPlaybackState.completed:
        return BasicPlaybackState.stopped;
      default:
        throw Exception("Illegal state");
    }
  }

  @override
  Future<void> onStart() async {
    var playerStateSubscription = audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    var eventSubscription = audioPlayer.playbackEventStream.listen((event) {
      final state = _stateToBasicState(event.state);
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: event.position.inMilliseconds,
        );
      }
    });

    AudioServiceBackground.setQueue(_queue);
    await onSkipToNext();
    await _completer.future;
    playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < _queue.length)) return;
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await audioPlayer.stop();
    }
    // Load next item
    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    await audioPlayer.setUrl(mediaItem.id);
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      audioPlayer.pause();
    }
  }

  @override
  void onSeekTo(int position) {
    audioPlayer.seek(Duration(milliseconds: position));
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() {
    audioPlayer.stop();
    _setState(state: BasicPlaybackState.stopped);
    _completer.complete();
  }


  @override
  void onAddQueueItem( MediaItem mediaItem ) {
   _addNewMediaItem(mediaItem);
  }

  _addNewMediaItem(MediaItem mediaItem) async{
    _queue.add(mediaItem);
//    if (_playing) {
//      // Stop current item
//      await audioPlayer.stop();
//    }
    AudioServiceBackground.setQueue(_queue);

  }


  @override
  void onPlayFromMediaId( String mediaId ) {
    _setMediaFromId(int.parse(mediaId));
  }

//  _setMediaFromId(int mediaId) async{
//    AudioServiceBackground.setMediaItem(_queue[mediaId]);
//    //audioPlayer.
//  }

  Future<void> _setMediaFromId(int id) async {
    final newPos = id;
    if (!(newPos >= 0 && newPos < _queue.length)) {
      print('Index is fucked up');
      return;}
    if (_playing == null) {
      // First time, we want to start playing
      _playing = true;
    } else if (_playing) {
      // Stop current item
      await audioPlayer.stop();
    }
    // Load next item
    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    //TODO set a correct state (play->stop->play)
    _skipState = id > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    await audioPlayer.setUrl(mediaItem.id);
    _skipState = null;
    // Resume playback if we were playing
    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  void _setState({@required BasicPlaybackState state, int position}) {
    if (position == null) {
      position = audioPlayer.playbackEvent.position.inMilliseconds;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }



  List<MediaControl> getControls(BasicPlaybackState state) {
    if (_playing) {
      return [
        skipToPreviousControl,
        pauseControl,
        stopControl,
        skipToNextControl,
      ];
    } else {
      return [
        skipToPreviousControl,
        playControl,
        stopControl,
        skipToNextControl,
      ];
    }
  }
}


MediaControl playControl = MediaControl(
  androidIcon: 'drawable/ic_action_play_arrow',
  label: 'Play',
  action: MediaAction.play,
);
MediaControl pauseControl = MediaControl(
  androidIcon: 'drawable/ic_action_pause',
  label: 'Pause',
  action: MediaAction.pause,
);
MediaControl skipToNextControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Next',
  action: MediaAction.skipToNext,
);
MediaControl skipToPreviousControl = MediaControl(
  androidIcon: 'drawable/ic_action_skip_previous',
  label: 'Previous',
  action: MediaAction.skipToPrevious,
);
MediaControl stopControl = MediaControl(
  androidIcon: 'drawable/ic_action_stop',
  label: 'Stop',
  action: MediaAction.stop,
);
MediaControl playFromMediaId = MediaControl(
  androidIcon: 'drawable/ic_action_skip_next',
  label: 'Play track #',
  action: MediaAction.playFromMediaId,
);

void audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(() => AudioPlayerTask());
}


void connect() async {
  await AudioService.connect();
}

void disconnect() {
  AudioService.disconnect();
}