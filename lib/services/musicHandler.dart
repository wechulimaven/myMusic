import 'dart:async';
import 'dart:io';
// import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_file_manager/flutter_file_manager.dart';
import 'package:path_provider_ex/path_provider_ex.dart';

///you need include this file only.
import 'package:flutter_audio_query/flutter_audio_query.dart';

/// create a FlutterAudioQuery instance.
final FlutterAudioQuery audioQuery = FlutterAudioQuery();

typedef void TimeChangeHandler(Duration duration);
typedef void ErrorHandler(String message);
TimeChangeHandler durationHandler;
TimeChangeHandler positionHandler;
VoidCallback startHandler;
VoidCallback completionHandler;
ErrorHandler errorHandler;
bool _handlePermissions = true;
bool _executeAfterPermissionGranted = true;
Map<String, File> loadedFiles = {};
String prefix;

class MusicFinder {
  static const platform = const MethodChannel('music');
  VoidCallback completionHandler;
  var completer = Completer();
  static const String _CHANNEL_NAME =
      "boaventura.com.devel.br.flutteraudioquery";
  static const MethodChannel channel = const MethodChannel(_CHANNEL_NAME);
  static const MethodChannel path_provider =
      const MethodChannel('plugins.flutter.io/path_provider');

  /// key used for delegate type param.
  static const String SOURCE_KEY = "source";
  static const String QUERY_KEY = "query";
  static const String SOURCE_ARTIST = 'artist';
  static const String SOURCE_ALBUM = 'album';
  static const String SOURCE_SONGS = 'song';
  static const String SOURCE_GENRE = 'genre';
  static const String SOURCE_ARTWORK = 'artwork';
  static const String SORT_TYPE = "sort_type";
  static const String PLAYLIST_METHOD_TYPE = "method_type";
  static const String SOURCE_PLAYLIST = 'playlist';

  MusicFinder() {
    channel.setMethodCallHandler(platformCallHandler);
    //durationNotifier = new ValueNotifier(new Duration());
  }

  MusicFinder setHandlePermissions(bool handlePermissions) {
    _handlePermissions = handlePermissions;
    return this;
  }

  MusicFinder setExecuteAfterPermissionGranted(
      bool executeAfterPermissionGranted) {
    _executeAfterPermissionGranted = executeAfterPermissionGranted;
    return this;
  }

  static Future<dynamic> allSongs(
      {SongSortType sortType = SongSortType.DEFAULT}) async {
    PlatformException exception;
    String _songsList;
    try {
      List<dynamic> songs = await channel.invokeMethod("getSongs", {
        SOURCE_KEY: SOURCE_SONGS,
        SORT_TYPE: sortType.index,
      });
      var mySongs = songs.map((m) => Song.fromMap(m)).toList();
      // completer.complete(mySongs);
      // return completer.future;
      return mySongs;
    } on PlatformException catch (e) {
      exception = e;
      print(e);
    }
  }

  Future<Directory> getTemporaryDirectory() async {
    final String path =
        await path_provider.invokeMethod('getTemporaryDirectory');
    if (path == null) {
      return null;
    }
    return new Directory(path);
  }

  Future<ByteData> _fetchAsset(String fileName) async {
    return await rootBundle.load('assets/$prefix$fileName');
  }

  Future<File> fetchToMemory(String fileName) async {
    final file = new File('${(await getTemporaryDirectory()).path}/$fileName');
    await file.create(recursive: true);
    return await file
        .writeAsBytes((await _fetchAsset(fileName)).buffer.asUint8List());
  }

  Future<File> load(String fileName) async {
    if (!loadedFiles.containsKey(fileName)) {
      loadedFiles[fileName] = await fetchToMemory(fileName);
    }
    return loadedFiles[fileName];
  }

  Future<dynamic> play(String fileName) async {
    File file = await load(fileName);
    await player(file.path);
  }

  Future<dynamic> player(String url, {bool isLocal: true}) =>
      channel.invokeMethod('play', {"url": url, "isLocal": isLocal});

  Future<dynamic> pause() => channel.invokeMethod('pause');

  Future<dynamic> stop() => channel.invokeMethod('stop');

  Future<dynamic> mute(bool muted) => channel.invokeMethod('mute', muted);

  Future<dynamic> seek(double seconds) => channel.invokeMethod('seek', seconds);

  void setDurationHandler(TimeChangeHandler handler) {
    durationHandler = handler;
  }

  void setPositionHandler(TimeChangeHandler handler) {
    positionHandler = handler;
  }

  void setStartHandler(VoidCallback callback) {
    startHandler = callback;
  }

  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }

  Future platformCallHandler(MethodCall call) async {
    //    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "audio.onDuration":
        final duration = new Duration(milliseconds: call.arguments);
        if (durationHandler != null) {
          durationHandler(duration);
        }
        //durationNotifier.value = duration;
        break;
      case "audio.onCurrentPosition":
        if (positionHandler != null) {
          positionHandler(new Duration(milliseconds: call.arguments));
        }
        break;
      case "audio.onStart":
        if (startHandler != null) {
          startHandler();
        }
        break;
      case "audio.onComplete":
        if (completionHandler != null) {
          completionHandler();
        }
        break;
      case "audio.onError":
        if (errorHandler != null) {
          errorHandler(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}

var files;

void getFiles() async {
  //asyn function to get list of files
  List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  var root = storageInfo[0]
      .rootDir; //storageInfo[1] for SD card, geting the root directory
  var fm = FileManager(root: Directory(root)); //
  files = await fm.filesTree(
      excludedPaths: ["/storage/emulated/0/Android"],
      extensions: ["mp3"] //optional, to filter files, list only mp3 files
      );
  // setState(() {}); //update the UI
}

// class MusicFinder {
//   static const MethodChannel channel = const MethodChannel('music_finder');
// bool _handlePermissions = true;
// bool _executeAfterPermissionGranted = true;

//   static const MethodChannel platform = const MethodChannel('music');

//   TimeChangeHandler durationHandler;
//   TimeChangeHandler positionHandler;
//   VoidCallback startHandler;
// VoidCallback completionHandler;
//   ErrorHandler errorHandler;

// MusicFinder() {
//   _channel.setMethodCallHandler(platformCallHandler);
//   //durationNotifier = new ValueNotifier(new Duration());
// }
//   Future<dynamic> play(String url, {bool isLocal: false}) =>
//       _channel.invokeMethod('play', {"url": url, "isLocal": isLocal});

// Future<dynamic> pause() => _channel.invokeMethod('pause');

//   Future<dynamic> stop() => _channel.invokeMethod('stop');

//   Future<dynamic> mute(bool muted) => _channel.invokeMethod('mute', muted);

//   Future<dynamic> seek(double seconds) =>
//       _channel.invokeMethod('seek', seconds);

//   void setDurationHandler(TimeChangeHandler handler) {
//     durationHandler = handler;
//   }

//   void setPositionHandler(TimeChangeHandler handler) {
//     positionHandler = handler;
//   }

//   void setStartHandler(VoidCallback callback) {
//     startHandler = callback;
//   }

// void setCompletionHandler(VoidCallback callback) {
//   completionHandler = callback;
// }

//   void setErrorHandler(ErrorHandler handler) {
//     errorHandler = handler;
//   }

//   //Finder

// MusicFinder setHandlePermissions(bool handlePermissions) {
//   _handlePermissions = handlePermissions;
//   return this;
// }

// MusicFinder setExecuteAfterPermissionGranted(
//     bool executeAfterPermissionGranted) {
//   _executeAfterPermissionGranted = executeAfterPermissionGranted;
//   return this;
// }

//   static Future<String> get platformVersion =>
//       _channel.invokeMethod('getPlatformVersion');

//   static Future<dynamic> allSongs() async {
//     var completer = new Completer();

//     // At some time you need to complete the future:

//     Map params = <String, dynamic>{
//       "handlePermissions": true,
//       "executeAfterPermissionGranted": true,
//     };
//     List<dynamic> songs = await _channel.invokeMethod('getSongs', params);
//     print(songs.runtimeType);
// var mySongs = songs.map((m) => new Song.fromMap(m)).toList();
// completer.complete(mySongs);
// return completer.future;
//   }

//   // static Future<bool> isLicensed() async {
//   //   // invokeMethod returns a Future<T?>, so we handle the case where
//   //   // the return value is null by treating null as false.
//   //   return _channel
//   //       .invokeMethod<bool>('isLicensed')
//   //       .then<bool>((bool value) => value ?? false);
//   // }

//   // static Future<List<Song>> allSongs() async {
//   //   // invokeMethod here returns a Future<dynamic> that completes to a
//   //   // List<dynamic> with Map<dynamic, dynamic> entries. Post-processing
//   //   // code thus cannot assume e.g. List<Map<String, String>> even though
//   //   // the actual values involved would support such a typed container.
//   //   // The correct type cannot be inferred with any value of `T`.
//   //   final List<dynamic> songs = await platform.invokeMethod('getSongs');
//   //   var mySongs = songs.map((m) => Song.fromMap(m)).toList();
//   //   return mySongs;
//   // }

//   // static Future<dynamic> allSongs() async {
//   //   PlatformException exception;
//   //   String _songsList;
//   //   var completer = Completer();
//   //   try {
//   //     // final String result = await platform.invokeMethod('getSongs');
//   //     // _songsList = result;
// List<dynamic> songs = await platform.invokeMethod('getSongs');
// var mySongs = songs.map((m) => Song.fromMap(m)).toList();
// completer.complete(mySongs);
// return completer.future;
//   //   } on PlatformException catch (e) {
//   //     exception = e;
//   //     print(e);
//   //   }

//   // }

// Future platformCallHandler(MethodCall call) async {
//   //    print("_platformCallHandler call ${call.method} ${call.arguments}");
//   switch (call.method) {
//     case "audio.onDuration":
//       final duration = new Duration(milliseconds: call.arguments);
//       if (durationHandler != null) {
//         durationHandler(duration);
//       }
//       //durationNotifier.value = duration;
//       break;
//     case "audio.onCurrentPosition":
//       if (positionHandler != null) {
//         positionHandler(new Duration(milliseconds: call.arguments));
//       }
//       break;
//     case "audio.onStart":
//       if (startHandler != null) {
//         startHandler();
//       }
//       break;
//     case "audio.onComplete":
//       if (completionHandler != null) {
//         completionHandler();
//       }
//       break;
//     case "audio.onError":
//       if (errorHandler != null) {
//         errorHandler(call.arguments);
//       }
//       break;
//     default:
//       print('Unknowm method ${call.method} ');
//   }
// }
// }

class Song {
  int id;
  String artist;
  String title;
  String album;
  String albumId;
  int duration;
  String uri;
  String albumArt;
  int isFav;
  int timeStamp;
  int count;

  static List<String> columns = [
    'id',
    'artist',
    'title',
    'album',
    'albumId',
    'duration',
    'uri',
    'albumArt',
    'isFav',
    'timeStamp',
    'count'
  ];

  Song(this.id, this.artist, this.title, this.album, this.albumId,
      this.duration, this.uri, this.albumArt,
      {this.isFav = 0, this.timeStamp = 0, this.count});
  Song.fromMap(Map m) {
    id = m["id"];
    artist = m["artist"];
    title = m["title"];
    count = m['count'];
    album = m["album"];
    albumId = m["albumId"];
    duration = m["duration"];
    uri = m["uri"];
    albumArt = m["albumArt"];
    isFav = m["isFav"];
    timeStamp = m["timeStamp"];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count': count,
      'artist': artist,
      'title': title,
      'album': album,
      'albumId': albumId,
      'duration': duration,
      'uri': uri,
      'albumArt': albumArt,
      'isFav': isFav,
      'timeStamp': timeStamp,
    };
  }
}
