import 'package:flutter/material.dart';
import 'package:project_akhir_pmp/screens/opening/signin_screen.dart';
// import 'package:project_akhir_pmp/theme/theme.dart';

class SettingForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'SETTINGS',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.logout),
                  Text('Log Out'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
