import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yt/learner/course_detail.dart';
import 'package:yt/learner/recommendation.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  late DatabaseReference _usersRef;
  late DatabaseReference _coursesRef;
  late DatabaseReference _eventsRef;

  Map<String, dynamic> user = {};
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> events = [];

  @override
  void initState() {
    super.initState();
    _usersRef = _dbRef.child('users');
    _coursesRef = _dbRef.child('courses');
    _eventsRef = _dbRef.child('events');
    fetchData();
  }

  Future<void> fetchData() async {
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

    // Fetch events data
    final eventsSnapshot = await _eventsRef.get();
    if (eventsSnapshot.exists) {
      final eventData = Map<String, dynamic>.from(eventsSnapshot.value as Map);
      setState(() {
        events = eventData.entries.map((entry) {
          return Map<String, dynamic>.from(entry.value);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: const Color(0xFFCBD5E1)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14344054),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.bell,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2551A9),
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: const Center(
                          child: Text(
                            '5',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 1, color: const Color(0xFFCBD5E1)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14344054),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.person,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(user['profile']?['avatarUrl'] ?? ''),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${user['profile']?['firstName']} ${user['profile']?['lastName']}',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    '${user['email']}',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Search'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Messages'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Tutor Bookings'),
              onTap: () {},
            ),
            ListTile(
              title: Text('My Courses'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Rating & Reviews'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData, // The method to reload data
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFD1D5DB)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/search');
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.search,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Search',
                            style: TextStyle(color: Color(0xFF94A3B8)),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Recommendation"),
                  ],
                ),
                SizedBox(height: 8),
                // Horizontal Carousel (Course Cards)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(courses.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          width: 210,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFD1D5DB)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Course Image
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  'assets/example.png',
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Course Title and Description
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      courses[index]['title'] ?? 'Course Title',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      courses[index]['description'] ?? 'Course description goes here.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Action Button
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: // Inside the SingleChildScrollView where you display courses
                                ElevatedButton(
                                  onPressed: () {
                                    final courseId = courses[index]['courseId']; // Get course ID
                                    final userId = user['userId']; // Ensure user ID is valid

                                    // Navigate to the Course Page with course details and user ID
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CourseDetailPage(courseId: courseId, userId: userId)
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  ),
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),


                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Courses"),
                  ],
                ),
                SizedBox(height: 8),
                Column(
                  children: [
                    SizedBox(height: 8),
                    // Display the list of enrolled courses
                    SingleChildScrollView(
                      child: Column(
                        children: List.generate(events.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD1D5DB)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Course Title and Description
                                  Text(
                                    events[index]['title'] ?? 'Course Title',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    events[index]['description'] ?? 'Course description goes here.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
