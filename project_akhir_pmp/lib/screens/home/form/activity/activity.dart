import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final Color backgroundColor;
  bool pinned;
  bool favorite;
  DateTime? deadline; 
  bool completed; 

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.backgroundColor,
    this.pinned = false,
    this.favorite = false,
    this.deadline,
    this.completed = false,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      backgroundColor: Color(data['backgroundColor']),
      pinned: data['pinned'] ?? false,
      favorite: data['favorite'] ?? false,
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      completed: data['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'backgroundColor': backgroundColor.value,
      'pinned': pinned,
      'favorite': favorite,
      'deadline': deadline,
      'completed': completed,
    };
  }

  Future<void> updateInFirestore() async {
    await FirebaseFirestore.instance
        .collection('activities')
        .doc(id)
        .update(toMap());
  }

  Future<void> deleteFromFirestore() async {
    await FirebaseFirestore.instance.collection('activities').doc(id).delete();
  }
}
