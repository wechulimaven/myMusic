
// import 'dart:io';
// import 'main.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_audio_query/flutter_audio_query.dart';
// import 'package:flutter_music_player/widget.dart';

// class SongWidget extends StatelessWidget {
//   final List<SongInfo> songList;

//   SongWidget({@required this.songList});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: songList.length,
//         itemBuilder: (context, songIndex) {
//           SongInfo song = songList[songIndex];
//           if (song.displayName.contains(".mp3"))
//             return Card(
//               elevation: 5,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     ClipRRect(
//                       child: Image(
//                         height: 90,
//                         width: 150,
//                         fit: BoxFit.cover,
//                         image: FileImage(File(song.albumArtwork)),
//                       ),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.5,
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.4,
//                                 child: Text(song.title,
//                                     style: TextStyle(
//                                         fontSize: 13,
//                                         fontWeight: FontWeight.w700)),
//                               ),
//                               Text("Release Year: ${song.year}",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500)),
//                               Text("Artist: ${song.artist}",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500)),
//                               Text("Composer: ${song.composer}",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500)),
//                               Text(
//                                   "Duration: ${parseToMinutesSeconds(int.parse(song.duration))} min",
//                                   style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w500)),
//                             ],
//                           ),
//                           InkWell(
//                             onTap: () {
//                               audioManagerInstance
//                                   .start("file://${song.filePath}", song.title,
//                                       desc: song.displayName,
//                                       auto: true,
//                                       cover: song.albumArtwork)
//                                   .then((err) {
//                                 print(err);
//                               });
//                             },
//                             child: IconText(
//                               iconData: Icons.play_circle_outline,
//                               iconColor: Colors.red,
//                               string: "Play",
//                               textColor: Colors.black,
//                               iconSize: 25,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           return SizedBox(
//             height: 0,
//           );
//         });
//   }

//   static String parseToMinutesSeconds(int ms) {
//     String data;
//     Duration duration = Duration(milliseconds: ms);

//     int minutes = duration.inMinutes;
//     int seconds = (duration.inSeconds) - (minutes * 60);

//     data = minutes.toString() + ":";
//     if (seconds <= 9) data += "0";

//     data += seconds.toString();
//     return data;
//   }


















// // import 'package:audioplayers/audio_cache.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';

// // typedef void OnError(Exception exception);

// // void main() {
// //   runApp(new MaterialApp(home: new ExampleApp()));
// // }

// // class ExampleApp extends StatefulWidget {
// //   @override
// //   _ExampleAppState createState() => new _ExampleAppState();
// // }

// // class _ExampleAppState extends State<ExampleApp> {
// //   Duration _duration = new Duration();
// //   Duration _position = new Duration();
// //   AudioPlayer advancedPlayer;
// //   AudioCache audioCache;

// //   @override
// //   void initState(){
// //     super.initState();
// //     initPlayer();
// //   }

// //   void initPlayer(){
// //     advancedPlayer = new AudioPlayer();
// //     audioCache = new AudioCache(fixedPlayer: advancedPlayer);

// //     advancedPlayer.durationHandler = (d) => setState(() {
// //       _duration = d;
// //     });

// //     advancedPlayer.positionHandler = (p) => setState(() {
// //     _position = p;
// //     });
// //   }

// //   String localFilePath;

// //   Widget _tab(List<Widget> children) {
// //     return Center(
// //       child: Container(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           children: children
// //               .map((w) => Container(child: w, padding: EdgeInsets.all(6.0)))
// //               .toList(),
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _btn(String txt, VoidCallback onPressed) {
// //     return ButtonTheme(
// //         minWidth: 48.0,
// //         child: RaisedButton(child: Text(txt), onPressed: onPressed));
// //   }

// //   Widget slider() {
// //     return Slider(
// //         value: _position.inSeconds.toDouble(),
// //         min: 0.0,
// //         max: _duration.inSeconds.toDouble(),
// //         onChanged: (double value) {
// //           setState(() {
// //             seekToSecond(value.toInt());
// //             value = value;
// //           });});
// //   }

// //   Widget localAsset() {
// //     return _tab([
// //       Text('Play Local Asset \'audio.mp3\':'),
// //       _btn('Play', () => audioCache.play('audio.mp3')),
// //       _btn('Pause',() => advancedPlayer.pause()),
// //       _btn('Stop', () => advancedPlayer.stop()),
// //       slider()
// //     ]);
// //   }

// //   void seekToSecond(int second){
// //     Duration newDuration = Duration(seconds: second);

// //     advancedPlayer.seek(newDuration);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return DefaultTabController(
// //       length: 1,
// //       child: Scaffold(
// //         appBar: AppBar(
// //           bottom: TabBar(
// //             tabs: [
// //               Tab(text: 'Local Asset'),
// //             ],
// //           ),
// //           title: Text('audioplayers Example'),
// //         ),
// //         body: TabBarView(
// //           children: [localAsset()],
// //         ),
// //       ),
// //     );
// //   }
// // }