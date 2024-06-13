import 'package:flutter/material.dart';
import 'package:project_akhir_pmp/screens/home/form/activity/activity_form.dart';
import 'package:project_akhir_pmp/screens/home/form/home_form.dart';
import 'package:project_akhir_pmp/screens/home/form/settings/setting_form.dart';
import 'package:project_akhir_pmp/screens/home/form/favorite_form.dart'; // Import FavoriteForm
import 'package:provider/provider.dart';
import 'package:project_akhir_pmp/screens/home/form/settings/change_theme.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeForm(),
    ActivityForm(),
    const FavoriteForm(),
    const SettingForm(), // Now this will use Navigator to push UserProfileForm
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ThemeNotifier>(context);

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: _onItemTapped,
      ),
    );
  }
}
