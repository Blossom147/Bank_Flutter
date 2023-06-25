
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr/screens/home_screen.dart';

import '../login_screen.dart';
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            SizedBox(height: 50),
            Icon(
              Icons.check_circle,
              size: 250,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(
              'Giao dịch thành công',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text('Thoát'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
