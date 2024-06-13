import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_akhir_pmp/screens/home/home_screen.dart';

class HomeForm extends StatelessWidget {
  const HomeForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Home',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            elevation: 0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row for Profile and Notifications cards
            Row(
              children: [
                Expanded(
                  child: buildProfileCard(),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: buildNotificationsCard(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Row for Settings and Recent Activities cards
            Row(
              children: [
                Expanded(
                  child: buildSettingsCard(context),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: buildRecentActivitiesCard(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileCard() {
    return GestureDetector(
      onTap: () {
        // Implement navigation to profile page
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 73, 165, 240),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.person, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'View and edit your profile',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to HomeScreen with index 2 (Favorites)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(initialIndex: 2),
          ),
        );
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 248, 177, 70),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.star, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Favorites',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('favorites')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }

                if (snapshot.hasError) {
                  return Text('Failed to load favorites: ${snapshot.error}');
                }

                int numberOfFavorites = snapshot.data!.docs.length;

                return Text(
                  'View your recent favorites ($numberOfFavorites)',
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to HomeScreen with index 3 (Settings)
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(initialIndex: 3),
          ),
        );
      },
      child: Container(
        height: 150,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 253, 104, 154),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.settings, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Adjust your preferences',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecentActivitiesCard(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('activities').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Failed to load activities: ${snapshot.error}');
        }

        int numberOfActivities = snapshot.data!.docs.length;

        return GestureDetector(
          onTap: () {
            // Navigate to HomeScreen with index 1 (Activities)
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(initialIndex: 1),
              ),
            );
          },
          child: Container(
            height: 150,
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 248, 88, 227),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.7),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.history, color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Check your recent activities ($numberOfActivities)',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
