import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late DatabaseReference _usersRef;
  late DatabaseReference _coursesRef;
  late DatabaseReference _recommendationsRef;

  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> recommendations = [];

  @override
  void initState() {
    super.initState();
    _usersRef = _dbRef.child('users');
    _coursesRef = _dbRef.child('courses');
    _recommendationsRef = _dbRef.child('recommendations');
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Fetch user data
      final userSnapshot = await _usersRef.child('userId1').get();
      if (userSnapshot.exists) {
        setState(() {
          user = Map<String, dynamic>.from(userSnapshot.value as Map);
        });
      }

      // Fetch courses data
      final coursesSnapshot = await _coursesRef.get();
      if (coursesSnapshot.exists) {
        final courseData = Map<String, dynamic>.from(coursesSnapshot.value as Map);
        setState(() {
          courses = courseData.entries.map((entry) {
            return Map<String, dynamic>.from(entry.value);
          }).toList();
        });
      }

      // Fetch recommendations data
      final recommendationsSnapshot = await _recommendationsRef.get();
      if (recommendationsSnapshot.exists) {
        final recommendationsData =
        Map<String, dynamic>.from(recommendationsSnapshot.value as Map);
        setState(() {
          recommendations = recommendationsData.entries.map((entry) {
            return Map<String, dynamic>.from(entry.value);
          }).toList();
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.bell),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user['profile']?['imageUrl'] ??
                          'https://via.placeholder.com/150', // Fetched profile image
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${user['profile']?['firstName'] ?? ''} ${user['profile']?['lastName'] ?? ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${user['email'] ?? ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Recommendations'),
              onTap: () {
                Navigator.pushNamed(context, '/recommendations');
              },
            ),
            ListTile(
              title: const Text('My Courses'),
              onTap: () {
                Navigator.pushNamed(context, '/myCourses');
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              "Welcome, ${user['profile']?['firstName'] ?? 'User'}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recommendations');
              },
              child: const Text('View Recommendations'),
            ),
            const SizedBox(height: 16),
            Text(
              'Available Courses',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              child: Text('search'),
              onTap: (){
                Navigator.pushNamed(context, '/search');
              },
            ),
            const SizedBox(height: 8),
            // Inside the Dashboard class
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(courses.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      String courseId = courses[index].keys.first; // Get the courseId from the keys
                      print(courses[index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseScreen(
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            courses[index]['imageUrl']?.isNotEmpty == true
                                ? courses[index]['imageUrl']
                                : 'https://via.placeholder.com/150', // Fallback image URL
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            courses[index]['title'] ?? 'Course Title',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            courses[index]['description'] ?? 'Course description',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class RecommendationScreen extends StatelessWidget {
  final List<Map<String, dynamic>> recommendations;

  const RecommendationScreen({Key? key, required this.recommendations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: ListView.builder(
        itemCount: recommendations.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(recommendations[index]['imageUrl'] ?? ''),
            title: Text(recommendations[index]['title'] ?? ''),
            subtitle: Text(recommendations[index]['description'] ?? ''),
          );
        },
      ),
    );
  }
}

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final DatabaseReference _coursesRef = FirebaseDatabase.instance.ref('courses');
  late Future<Map<String, dynamic>> courses;

  @override
  void initState() {
    super.initState();
    courses = _getCourses();
  }

  Future<Map<String, dynamic>> _getCourses() async {
    final snapshot = await _coursesRef.get();
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: courses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No courses available.'));
          }

          final coursesData = snapshot.data!;

          return ListView.builder(
            itemCount: coursesData.length,
            itemBuilder: (context, index) {
              String courseId = coursesData.keys.elementAt(index);
              var course = coursesData[courseId];
              return ListTile(
                title: Text(course['title']),
                subtitle: Text(course['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailScreen(courseId: courseId),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  CourseDetailScreen({required this.courseId});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late DatabaseReference _courseRef;
  late Future<Map<String, dynamic>> courseData;

  @override
  void initState() {
    super.initState();
    _courseRef = FirebaseDatabase.instance.ref('courses/${widget.courseId}');
    courseData = _getCourseData();
  }

  Future<Map<String, dynamic>> _getCourseData() async {
    final snapshot = await _courseRef.get();
    return Map<String, dynamic>.from(snapshot.value as Map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Course Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: courseData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          var course = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(course['title'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(course['description']),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: course['videoContent'].length,
                  itemBuilder: (context, index) {
                    String videoId = course['videoContent'].keys.elementAt(index);
                    var video = course['videoContent'][videoId];
                    return ListTile(
                      title: Text("Video ${index + 1}"),
                      subtitle: Text("Length: ${video['length']} seconds"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              courseId: widget.courseId,
                              videoId: videoId,  // Pass the videoId to the VideoScreen
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class VideoPlayerScreen extends StatefulWidget {
  final String courseId;
  final String videoId;

  VideoPlayerScreen({required this.courseId, required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  String videoUrl = '';
  List<Map<String, dynamic>> questions = [];
  bool isLoading = true;
  int currentQuestionIndex = -1;
  bool showQuestion = false;
  String geminiResponse = '';
  final List<Map<String, String>> chatMessages = []; // List to store chat messages

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  // Fetch video URL and questions from Firebase
  Future<void> _fetchVideoData() async {
    try {
      DatabaseReference courseRef = FirebaseDatabase.instance
          .ref()
          .child('courses/${widget.courseId}/videoContent/${widget.videoId}');

      DatabaseEvent event = await courseRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        var videoData = snapshot.value as Map<dynamic, dynamic>;

        setState(() {
          videoUrl = videoData['url'] ?? '';
          isLoading = false;
          var videoQuestions = videoData['questions'];
          if (videoQuestions is List) {
            questions = videoQuestions.map((question) {
              return {
                'question': question['question'],
                'options': question['options'],
                'correctOption': question['correctOption'],
                'timestamp': question['timestamp'],
              };
            }).toList();
          }
        });

        if (videoUrl.isNotEmpty) {
          _initializeVideoPlayer();
        }
      } else {
        print("No video data found.");
      }
    } catch (e) {
      print("Error fetching video data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.addListener(() {
          _checkForQuestion(_controller.value.position.inSeconds.toDouble());
        });
      });
  }

  void _checkForQuestion(double currentTime) {
    for (int i = 0; i < questions.length; i++) {
      if (currentTime == questions[i]['timestamp'] && currentQuestionIndex != i) {
        setState(() {
          currentQuestionIndex = i;
          showQuestion = true;
        });
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
        break;
      }
    }
  }

  void _handleAnswer(String selectedOption) {
    String correctOption = questions[currentQuestionIndex]['correctOption'];
    if (selectedOption == correctOption) {
      print("Correct Answer!");
      Future.delayed(Duration(seconds: 2), () {
        if (_controller.value.isInitialized && !_controller.value.isPlaying) {
          double timestampInSeconds = questions[currentQuestionIndex]['timestamp'].toDouble();
          Duration newTimestamp = Duration(seconds: (timestampInSeconds).toInt() + 2);
          _controller.seekTo(newTimestamp).then((_) {
            if (_controller.value.isInitialized && !_controller.value.isPlaying) {
              _controller.play();
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  currentQuestionIndex = -1;
                  showQuestion = false;
                });
              });
            }
          }).catchError((error) {
            print("Error seeking to timestamp: $error");
          });
        }
      });
    } else {
      print("Wrong Answer. Try again.");
      if (_controller.value.isInitialized) {
        _controller.seekTo(Duration(seconds: questions[currentQuestionIndex]['timestamp'].toInt())).then((_) {
          if (_controller.value.isInitialized && !_controller.value.isPlaying) {
            _controller.play();
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                currentQuestionIndex = -1;
                showQuestion = false;
              });
            });
          }
        }).catchError((error) {
          print("Error seeking to timestamp: $error");
        });
      }
    }
  }
  Future<void> generateContent(String question, String videoLink) async {
    String apiKey = 'AIzaSyDPO8eulyNlh8uE5K1pGyaltgt76nf0044';

    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'contents': [
        {'parts': [{'text': 'Video Link: $videoLink\n\nQuestion: $question'}]}
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Debugging: Print the full response to check the structure
        print("API Response: $data");

        // Ensure the response contains 'candidates' and the structure is correct
        if (data.containsKey('candidates') && data['candidates'].isNotEmpty) {
          String aiMessage = data['candidates'][0]['content']['parts'][0]['text'];

          setState(() {
            geminiResponse = aiMessage;  // Set geminiResponse to the AI message directly
            // Add the AI response to the chat history
            chatMessages.add({'sender': 'AI', 'message': aiMessage});
          });
        } else {
          setState(() {
            geminiResponse = 'No response from Gemini API.';
          });
        }
      } else {
        setState(() {
          geminiResponse = 'Failed to generate content: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        geminiResponse = 'Error: $e';
      });
    }
  }

  void _askQuestionToGemini(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ask Gemini'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Enter your question...'),
              ),
              SizedBox(height: 16),
              if (geminiResponse.isNotEmpty)
                Text('Response: $geminiResponse'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                String question = _controller.text;
                if (question.isNotEmpty) {
                  generateContent(question, videoUrl);
                  // Add user question to the chat
                  setState(() {
                    chatMessages.add({'sender': 'User', 'message': question});
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _askQuestionToGemini(context);
        },
        child: const Icon(Icons.question_answer),
        tooltip: 'Ask Gemini',
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          ElevatedButton(
            onPressed: showQuestion
                ? null
                : () {
              if (_controller.value.isPlaying) {
                _controller.pause();
              } else {
                _controller.play();
              }
              setState(() {});
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Timestamp: ${_controller.value.position.inSeconds}s",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          if (showQuestion)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    questions[currentQuestionIndex]['question'] ?? '',
                    style: TextStyle(fontSize: 18),
                  ),
                  ...List.generate(
                    questions[currentQuestionIndex]['options'].length,
                        (index) {
                      return ElevatedButton(
                        onPressed: () {
                          _handleAnswer(
                              questions[currentQuestionIndex]['options'][index]);
                        },
                        child: Text(questions[currentQuestionIndex]['options'][index]),
                      );
                    },
                  ),
                ],
              ),
            ),
          // Chat interface
          Expanded(
            child: ListView.builder(
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    chatMessages[index]['sender']!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(chatMessages[index]['message']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
