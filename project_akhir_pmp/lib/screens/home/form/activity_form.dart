import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Activity {
  final String title;
  final String description;
  final DateTime timestamp;

  Activity({
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class ActivityForm extends StatelessWidget {
  final List<Activity> activities = [
    Activity(
      title: 'Logged in',
      description: 'User logged into the application.',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    Activity(
      title: 'Viewed Profile',
      description: 'User viewed their profile.',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    Activity(
      title: 'Updated Settings',
      description: 'User updated their settings.',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),

    // Add more activities here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Activity', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Menyembunyikan tombol kembali
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              leading: Icon(Icons.access_time,
                  color: Theme.of(context).primaryColor),
              title: Text(
                activity.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0),
                  Text(activity.description),
                  SizedBox(height: 4.0),
                  Text(
                    DateFormat.yMMMd().add_jm().format(activity.timestamp),
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
