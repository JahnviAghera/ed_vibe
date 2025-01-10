import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF6),
      appBar: AppBar(
        title: Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: (){},
                child: Image.asset('assets/menu-2.png'),
              )
            ],
          ),
        ),
      ),
      body: Center(
      ),
    );
  }
}
