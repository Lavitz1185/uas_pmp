import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final IconData icon;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.icon,
  });

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Activity(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      icon: IconData(data['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timestamp': timestamp,
      'icon': icon.codePoint,
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

class ActivityForm extends StatefulWidget {
  ActivityForm({super.key});

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  bool _sortAscending = true; // Flag to track sorting order

  IconData _selectedIcon = Icons.event; // Default icon

  void _addActivity(Activity activity) async {
    await _firestore.collection('activities').add(activity.toMap());
  }

  void _editActivity(Activity activity) async {
    await activity.updateInFirestore();
  }

  void _deleteActivity(Activity activity) async {
    await activity.deleteFromFirestore();
  }

  Future<void> _showAddActivityModalSheet(BuildContext context,
      [Activity? activity]) async {
    final _titleController = TextEditingController(text: activity?.title ?? '');
    final _descriptionController =
        TextEditingController(text: activity?.description ?? '');
    DateTime? _selectedDate = activity?.timestamp;
    TimeOfDay? _selectedTime =
        activity != null ? TimeOfDay.fromDateTime(activity.timestamp) : null;

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity == null ? 'Add Activity' : 'Edit Activity',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            // Show dialog to pick an icon
                            final selectedIcon = await showDialog<IconData>(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Select Icon'),
                                  content: SingleChildScrollView(
                                    child: IconPicker(
                                      onIconSelected: (icon) {
                                        Navigator.of(context).pop(icon);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                            if (selectedIcon != null) {
                              setState(() {
                                _selectedIcon = selectedIcon;
                              });
                            }
                          },
                          icon: Icon(_selectedIcon),
                          iconSize: 36,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            _selectedDate == null
                                ? 'Select Date'
                                : DateFormat.yMMMd().format(_selectedDate!),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime ?? TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                _selectedTime = pickedTime;
                              });
                            }
                          },
                          child: Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : _selectedTime!.format(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_titleController.text.isNotEmpty &&
                                _descriptionController.text.isNotEmpty &&
                                _selectedDate != null &&
                                _selectedTime != null) {
                              final dateTime = DateTime(
                                _selectedDate!.year,
                                _selectedDate!.month,
                                _selectedDate!.day,
                                _selectedTime!.hour,
                                _selectedTime!.minute,
                              );
                              if (activity == null) {
                                final newActivity = Activity(
                                  id: '', // Firestore will generate the ID
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  timestamp: dateTime,
                                  icon: _selectedIcon,
                                );
                                _addActivity(newActivity);
                              } else {
                                final updatedActivity = Activity(
                                  id: activity.id,
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  timestamp: dateTime,
                                  icon: _selectedIcon,
                                );
                                _editActivity(updatedActivity);
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(activity == null ? 'Add' : 'Update'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Stream<List<Activity>> _getActivities() {
    return _firestore
        .collection('activities')
        .orderBy('timestamp', descending: !_sortAscending)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList());
  }

  List<Activity> _filterActivities(List<Activity> activities) {
    if (_searchQuery.isEmpty) {
      return activities;
    }
    return activities
        .where((activity) =>
            activity.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Activity',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        automaticallyImplyLeading: false, // Menyembunyikan tombol kembali
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search activities...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<bool>(
                  value: _sortAscending,
                  onChanged: (newValue) {
                    setState(() {
                      _sortAscending = newValue!;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: true,
                      child: Text('A-Z'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('Z-A'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Activity>>(
        stream: _getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No activities found.'));
          }

          final activities = _filterActivities(snapshot.data!);
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(activity.icon,
                      color: Theme.of(context).primaryColor),
                  title: Text(
                    activity.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(activity.description),
                      const SizedBox(height: 4.0),
                      Text(
                        DateFormat.yMMMd().add_jm().format(activity.timestamp),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showAddActivityModalSheet(context, activity);
                      } else if (value == 'delete') {
                        _deleteActivity(activity);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivityModalSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class IconPicker extends StatelessWidget {
  final Function(IconData) onIconSelected;

  IconPicker({required this.onIconSelected});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: IconsData.iconList.length,
      itemBuilder: (context, index) {
        final IconData iconData = IconsData.iconList[index];
        return IconButton(
          icon: Icon(iconData),
          onPressed: () {
            onIconSelected(iconData);
          },
        );
      },
    );
  }
}

class IconsData {
  static const iconList = [
    Icons.event,
    Icons.work,
    Icons.school,
    Icons.home,
    Icons.directions_run,
    Icons.restaurant,
    Icons.shopping_cart,
    Icons.airplane_ticket,
    Icons.book,
    Icons.brush,
    Icons.camera,
    Icons.sports_soccer,
    Icons.music_note,
    Icons.local_movies,
    Icons.event_seat,
    Icons.star,
    Icons.local_pizza,
    Icons.card_giftcard,
    Icons.pets,
    Icons.train,
    Icons.business,
    Icons.airport_shuttle,
    Icons.beach_access,
    Icons.toys,
  ];
}
