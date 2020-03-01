import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

//TODO move all redux pieces to separate files
class AudioPlayerTask extends BackgroundAudioTask {
  final _queue = <MediaItem>[
    MediaItem(
      id: "https://zvukipro.com/uploads/files/2019-08/1567011688_nature_forest.mp3",
      album: "Autumn",
      title: "Forest atmosphere",
      artist: "Autumn",
      duration: 5739820,
      artUri:
      "https://cdn.shopify.com/s/files/1/0276/4233/files/glorious_leaves_in_autumn_large.jpg",
    ),
    MediaItem(
      id: "https://zvukipro.com/uploads/files/2019-08/1567065079_ee07b7aaabd66d0.mp3",
      album: "Nature",
      title: "Gentle jingle",
      artist: "Nature",
      duration: 2856950,
      artUri:"https://media.pitchfork.com/photos/5929bca413d197565213b382/1:1/w_600/124fe55e.jpg",
    )
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
        //skipToPreviousControl,
        pauseControl,
        stopControl,
        //skipToNextControl,
      ];
    } else {
      return [
        //skipToPreviousControl,
        playControl,
        stopControl,
        //skipToNextControl,
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