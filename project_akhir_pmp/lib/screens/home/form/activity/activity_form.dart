import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:project_akhir_pmp/screens/home/form/activity/activity.dart';

class ActivityForm extends StatefulWidget {
  ActivityForm({Key? key}) : super(key: key);

  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';
  bool _sortAscending = true;
  Color _selectedBackgroundColor = const Color.fromARGB(255, 215, 215, 215);
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _showDeadline = false;
  DateTime? _selectedDeadline;

  void _addActivity(Activity activity) async {
    await _firestore.collection('activities').add(activity.toMap());
  }

  void _editActivity(Activity activity) async {
    await activity.updateInFirestore();
  }

  void _deleteActivity(Activity activity) async {
    await activity.deleteFromFirestore();
  }

  void _togglePin(Activity activity) async {
    final updatedActivity = Activity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      timestamp: activity.timestamp,
      backgroundColor: activity.backgroundColor,
      pinned: !activity.pinned,
      favorite: activity.favorite,
      deadline: activity.deadline,
      completed: activity.completed,
    );
    await updatedActivity.updateInFirestore();
  }

  void _toggleFavorite(Activity activity) async {
    final updatedActivity = Activity(
      id: activity.id,
      title: activity.title,
      description: activity.description,
      timestamp: activity.timestamp,
      backgroundColor: activity.backgroundColor,
      pinned: activity.pinned,
      favorite: !activity.favorite,
      deadline: activity.deadline,
      completed: activity.completed,
    );
    await updatedActivity.updateInFirestore();
  }

  //tambah activity
  void _showAddActivityModalSheet(BuildContext context,
      [Activity? activity]) async {
    final _titleController = TextEditingController(text: activity?.title ?? '');
    final _descriptionController =
        TextEditingController(text: activity?.description ?? '');
    _selectedDate = activity?.timestamp;
    _selectedTime =
        activity != null ? TimeOfDay.fromDateTime(activity.timestamp) : null;
    _selectedDeadline = activity?.deadline;
    String? _errorMessage;

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity == null ? 'Add Activity' : 'Edit Activity',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Text('Select Background Color:'),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () async {
                                final selectedColor = await showDialog<Color>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Select Background Color'),
                                      content: SingleChildScrollView(
                                        child: BlockPicker(
                                          pickerColor: _selectedBackgroundColor,
                                          onColorChanged: (color) {
                                            Navigator.of(context).pop(color);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (selectedColor != null) {
                                  setState(() {
                                    _selectedBackgroundColor = selectedColor;
                                  });
                                }
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                color: _selectedBackgroundColor,
                              ),
                            ),
                          ],
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
                                    _errorMessage = null;
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = 'Please select a date.';
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
                                    _errorMessage = null;
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = 'Please select a time.';
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Switch(
                                  value: _showDeadline,
                                  onChanged: (value) {
                                    setState(() {
                                      _showDeadline = value;
                                      if (!_showDeadline) {
                                        _selectedDeadline = null;
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text('Set Deadline'),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            if (_showDeadline) ...[
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFD2F2F),
                                    ),
                                    onPressed: () async {
                                      final pickedDeadline =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDeadline ?? DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDeadline != null) {
                                        setState(() {
                                          _selectedDeadline = pickedDeadline;
                                        });
                                      }
                                    },
                                    child: Text(
                                      _selectedDeadline == null
                                          ? 'Select Deadline Date'
                                          : DateFormat.yMMMd()
                                              .format(_selectedDeadline!),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFD2F2F),
                                    ),
                                    onPressed: () async {
                                      final pickedTime = await showTimePicker(
                                        context: context,
                                        initialTime: _selectedDeadline != null
                                            ? TimeOfDay.fromDateTime(
                                                _selectedDeadline!)
                                            : TimeOfDay.now(),
                                      );

                                      if (pickedTime != null) {
                                        setState(() {
                                          _selectedDeadline = DateTime(
                                            _selectedDeadline!.year,
                                            _selectedDeadline!.month,
                                            _selectedDeadline!.day,
                                            pickedTime.hour,
                                            pickedTime.minute,
                                          );
                                        });
                                      }
                                    },
                                    child: Text(
                                      _selectedDeadline == null
                                          ? 'Select Deadline Time'
                                          : DateFormat.Hm()
                                              .format(_selectedDeadline!),
                                    ),
                                  ),
                                ],
                              ),
                              if (_selectedDeadline != null &&
                                  (_selectedDeadline!
                                          .isBefore(_selectedDate!) ||
                                      _selectedDeadline!.isAtSameMomentAs(
                                          DateTime(
                                              _selectedDate!.year,
                                              _selectedDate!.month,
                                              _selectedDate!.day,
                                              _selectedTime!.hour,
                                              _selectedTime!.minute)) ||
                                      _selectedDeadline!.isBefore(DateTime(
                                          _selectedDate!.year,
                                          _selectedDate!.month,
                                          _selectedDate!.day,
                                          _selectedTime!.hour,
                                          _selectedTime!.minute))))
                                ...[]
                            ],
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validasi
                                if (_titleController.text.trim().isEmpty ||
                                    _descriptionController.text
                                        .trim()
                                        .isEmpty) {
                                  setState(() {
                                    _errorMessage = 'Semua field harus diisi.';
                                  });
                                  return;
                                }

                                if (_selectedDate == null ||
                                    _selectedTime == null) {
                                  setState(() {
                                    _errorMessage =
                                        'Please select date and time.';
                                  });
                                  return;
                                }

                                if (_showDeadline &&
                                    (_selectedDeadline == null ||
                                        _selectedDeadline!
                                            .isBefore(_selectedDate!) ||
                                        _selectedDeadline!.isAtSameMomentAs(
                                            DateTime(
                                                _selectedDate!.year,
                                                _selectedDate!.month,
                                                _selectedDate!.day,
                                                _selectedTime!.hour,
                                                _selectedTime!.minute)) ||
                                        _selectedDeadline!.isBefore(DateTime(
                                            _selectedDate!.year,
                                            _selectedDate!.month,
                                            _selectedDate!.day,
                                            _selectedTime!.hour,
                                            _selectedTime!.minute)))) {
                                  setState(() {
                                    _errorMessage =
                                        'Waktu Deadline tidak boleh di set lebih awal dari waktu awal';
                                  });
                                  return;
                                }

                                final dateTime = DateTime(
                                  _selectedDate!.year,
                                  _selectedDate!.month,
                                  _selectedDate!.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute,
                                );
                                final newActivity = Activity(
                                  id: '',
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  timestamp: dateTime,
                                  backgroundColor: _selectedBackgroundColor,
                                  pinned: false,
                                  favorite: false,
                                  deadline:
                                      _showDeadline ? _selectedDeadline : null,
                                  completed: false,
                                );
                                if (activity == null) {
                                  _addActivity(newActivity);
                                  _showSnackBar(context, 'Activity added');
                                } else {
                                  final updatedActivity = Activity(
                                    id: activity.id,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    timestamp: dateTime,
                                    backgroundColor: _selectedBackgroundColor,
                                    pinned: activity.pinned,
                                    favorite: activity.favorite,
                                    deadline: _showDeadline
                                        ? _selectedDeadline
                                        : null,
                                    completed: activity.completed,
                                  );
                                  _editActivity(updatedActivity);
                                }
                                Navigator.of(context).pop(true);
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
      },
    );

    if (result != null && !result) {
      setState(() {
        _showDeadline = false;
        _errorMessage = null;
      });
    }
  }

  //shorthing
  Stream<List<Activity>> _getActivities() {
    return _firestore
        .collection('activities')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList())
        .map((activities) {
      if (activities.isEmpty) return [];

      activities.sort((a, b) {
        if (a.pinned && !b.pinned) {
          return -1;
        } else if (!a.pinned && b.pinned) {
          return 1;
        } else {
          return _sortAscending
              ? a.title.compareTo(b.title)
              : b.title.compareTo(a.title);
        }
      });

      return activities;
    });
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

  //detail activity
  void _showActivityDetails(Activity activity) {
    bool _completed = activity.completed;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: Colors.white,
              elevation: 4.0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activity.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            color: Colors.grey, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Timestamp: ${DateFormat.yMMMd().add_jm().format(activity.timestamp)}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (activity.deadline != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Deadline: ${DateFormat.yMMMd().add_Hm().format(activity.deadline!)}',
                            style: TextStyle(
                              color: _completed ? Colors.grey : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: _completed,
                            onChanged: (value) {
                              setState(() {
                                _completed = value!;
                              });
                              final updatedActivity = Activity(
                                id: activity.id,
                                title: activity.title,
                                description: activity.description,
                                timestamp: activity.timestamp,
                                backgroundColor: activity.backgroundColor,
                                pinned: activity.pinned,
                                favorite: activity.favorite,
                                deadline: activity.deadline,
                                completed: value!,
                              );
                              _editActivity(updatedActivity);
                            },
                          ),
                          const Text(
                            'Mark as Completed',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.white,
                title: const Text('Activity',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black)),
                centerTitle: true,
                automaticallyImplyLeading: false,
                elevation: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search activities...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        prefixIcon: const Icon(Icons.search),
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
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                    ),
                    items: const [
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
                ]),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<Activity>>(
        stream: _getActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found.'));
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
                        const Icon(
                          Icons.push_pin,
                          color: Colors.red,
                        ),
                      if (activity.favorite)
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        ),
                      if (activity.deadline != null && !activity.completed)
                        const Icon(
                          Icons.schedule,
                          color: Colors.red,
                        ),
                      if (activity.deadline != null && activity.completed)
                        const Icon(
                          Icons.schedule,
                          color: Colors.grey,
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
                        style: const TextStyle(color: Colors.black38),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showAddActivityModalSheet(context, activity);
                        _showSnackBar(context, 'Activity updated');
                      } else if (value == 'delete') {
                        _deleteActivity(activity);
                        _showSnackBar(context, 'Activity deleted');
                      } else if (value == 'pin') {
                        _togglePin(activity);
                      } else if (value == 'favorite') {
                        _toggleFavorite(activity);
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'favorite',
                        child:
                            Text(activity.favorite ? 'Unfavorite' : 'Favorite'),
                      ),
                      PopupMenuItem(
                        value: 'pin',
                        child: Text(activity.pinned ? 'Unpin' : 'Pin'),
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

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.black87,
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      action: SnackBarAction(
        label: 'Close',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
