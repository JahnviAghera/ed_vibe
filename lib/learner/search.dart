import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool _isLoading = false;

  // Search for courses based on user input
  Future<void> _searchCourses(String query) async {
    setState(() {
      _isLoading = true;
      searchResults.clear();
    });

    try {
      DatabaseReference coursesRef = FirebaseDatabase.instance.ref().child('courses');

      // Listen for child added events and filter based on query
      coursesRef.onChildAdded.listen((event) {
        Map<String, dynamic> course = Map<String, dynamic>.from(event.snapshot.value as Map);

        // Check if the course title contains the query string
        if (course['title'].toLowerCase().contains(query.toLowerCase())) {
          setState(() {
            searchResults.add(course);
          });
        }
      });
    } catch (e) {
      print("Error searching courses: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Courses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  _searchCourses(query);
                } else {
                  setState(() {
                    searchResults.clear();
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Search courses...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            // Show loading indicator if necessary
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> course = searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Image.network(
                            course['imageUrl'] ?? 'assets/example.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(course['title'] ?? 'Course Title'),
                          subtitle: Text(course['description'] ?? 'Course description goes here.'),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              // Navigate to the course detail page
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
