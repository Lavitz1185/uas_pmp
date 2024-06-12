import 'package:flutter/material.dart';
// import 'package:project_akhir_pmp/theme/theme.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading:
                    Icon(Icons.person, color: Theme.of(context).primaryColor),
                title: Text(
                  'User Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('View and edit your profile'),
                onTap: () {
                  // Implement navigation to profile page
                },
              ),
            ),
            // Settings Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading:
                    Icon(Icons.settings, color: Theme.of(context).primaryColor),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Adjust your preferences'),
                onTap: () {
                  // Implement navigation to settings page
                },
              ),
            ),
            // Notifications Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: Icon(Icons.notifications,
                    color: Theme.of(context).primaryColor),
                title: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('View recent notifications'),
                onTap: () {
                  // Implement navigation to notifications page
                },
              ),
            ),
            // Recent Activities Card
            Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading:
                    Icon(Icons.history, color: Theme.of(context).primaryColor),
                title: Text(
                  'Recent Activities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Check your recent activities'),
                onTap: () {
                  // Implement navigation to activity page
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
