import 'package:flutter/services.dart';

class VinPlayer {
  static VinPlayer _instance;
  static VinPlayer get instance => _getInstance();

  static _getInstance(){
     if (_instance == null) {
      _instance = new VinPlayer._();
    }
    return _instance;
  }


  static MethodChannel _channel;
  VinPlayer._() {
    _channel = const MethodChannel('audio_manager')
      ..setMethodCallHandler(_handler);
    getCurrentVolume();
  }
}
