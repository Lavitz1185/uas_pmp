import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:cloud_firestore/cloud_firestore.dart'; // Untuk mengakses Firestore
import 'package:project_akhir_pmp/screens/home/form/activity/activity.dart';

class FavoriteForm extends StatefulWidget {
  const FavoriteForm({Key? key}) : super(key: key);

  @override
  State<FavoriteForm> createState() => _FavoriteFormState();
}

class _FavoriteFormState extends State<FavoriteForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            title: Text(
              'Favorite Activities',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('activities')
            .where('favorite',
                isEqualTo: true) // Filter activities marked as favorite
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorite activities found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final activity = Activity(
                id: doc.id,
                title: data['title'],
                description: data['description'],
                timestamp: (data['timestamp'] as Timestamp).toDate(),
                backgroundColor: Color(data['backgroundColor']),
                pinned: data['pinned'] ?? false,
                favorite: data['favorite'] ?? false,
              );

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: activity.backgroundColor,
                child: ListTile(
                  onTap: () => _showActivityDetails(activity),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (activity.pinned)
                        Icon(
                          Icons.push_pin,
                          color: Colors.red,
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(
                        activity.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        DateFormat.yMMMd().add_jm().format(activity.timestamp),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons
                        .remove_circle), // Ganti dengan icon favorit jika perlu
                    onPressed: () {
                      _removeFromFavorites(
                          activity); // Implement method to remove from favorites
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to remove activity from favorites
  void _removeFromFavorites(Activity activity) async {
    try {
      await _firestore.collection('activities').doc(activity.id).update({
        'favorite': false, // Set favorite to false to remove from favorites
      });
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  // Method to show activity details (similar to ActivityForm)
  void _showActivityDetails(Activity activity) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(activity.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Timestamp: ${DateFormat.yMMMd().add_jm().format(activity.timestamp)}',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
