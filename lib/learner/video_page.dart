// import 'package:flutter/material.dart';
//
// class VideoCoursePage extends StatefulWidget {
//   @override
//   _VideoCoursePageState createState() => _VideoCoursePageState();
// }
//
// class _VideoCoursePageState extends State<VideoCoursePage> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;
//   double _currentPosition = 0.0;
//   bool _isQuestionTime = false;
//   String _question = '';
//   String _answer = '';
//   bool _answeredCorrectly = false;
//
//   // List of questions and the timestamps at which they should appear
//   List<Map<String, dynamic>> questions = [
//     {'timestamp': 10.0, 'question': 'What is Flutter?', 'correctAnswer': 'A framework for building mobile apps'},
//     {'timestamp': 30.0, 'question': 'What is Dart?', 'correctAnswer': 'Programming language for Flutter'},
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset('assets/video/course_video.mp4');
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(false);
//     _controller.play();
//     _controller.addListener(_checkForQuestion);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.removeListener(_checkForQuestion);
//     _controller.dispose();
//   }
//
//   // Function to check if it's time to ask a question based on the video timestamp
//   void _checkForQuestion() {
//     setState(() {
//       _currentPosition = _controller.value.position.inSeconds.toDouble();
//     });
//
//     for (var question in questions) {
//       if (_currentPosition >= question['timestamp'] && !_isQuestionTime) {
//         _isQuestionTime = true;
//         _question = question['question'];
//         _answer = question['correctAnswer'];
//         break;
//       }
//     }
//   }
//
//   // Function to handle the answer submission
//   void _submitAnswer(String answer) {
//     if (answer == _answer) {
//       setState(() {
//         _answeredCorrectly = true;
//         _isQuestionTime = false; // Move on to the next part of the video
//         // Continue playing from the current timestamp
//         _controller.play();
//       });
//     } else {
//       setState(() {
//         _answeredCorrectly = false;
//         // Rewind the video to the timestamp of the last correct question
//         _controller.seekTo(Duration(seconds: questions[0]['timestamp'].toInt()));
//         _controller.play();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Course'),
//       ),
//       body: FutureBuilder<void>(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return Column(
//               children: [
//                 // Video player
//                 AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: VideoPlayer(_controller),
//                 ),
//                 // Show the question if it's time
//                 if (_isQuestionTime)
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           _question,
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         TextField(
//                           onChanged: (text) {
//                             setState(() {
//                               _answeredCorrectly = false;
//                             });
//                           },
//                           decoration: InputDecoration(
//                             labelText: 'Your Answer',
//                             border: OutlineInputBorder(),
//                           ),
//                           onSubmitted: _submitAnswer,
//                         ),
//                         SizedBox(height: 8),
//                         if (_answeredCorrectly)
//                           Text(
//                             'Correct! Proceeding...',
//                             style: TextStyle(color: Colors.green),
//                           ),
//                         if (!_answeredCorrectly && _answeredCorrectly != null)
//                           Text(
//                             'Incorrect. Rewatching...',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                       ],
//                     ),
//                   ),
//                 // Play/Pause Button
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             if (_controller.value.isPlaying) {
//                               _controller.pause();
//                             } else {
//                               _controller.play();
//                             }
//                           });
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
