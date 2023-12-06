import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhishGuard App',
      home: CheckBaitScreen(),
    );
  }
}

class CheckBaitScreen extends StatefulWidget {
  @override
  _CheckBaitScreenState createState() => _CheckBaitScreenState();
}

class _CheckBaitScreenState extends State<CheckBaitScreen> {
  String phishingCheckResult = '';
  String sslCheckResult = '';

  TextEditingController phishingUrlController = TextEditingController();
  TextEditingController sslUrlController = TextEditingController();

  void checkPhishing() async {
    String url = 'https://checkbait-v2.onrender.com/predict?url=${phishingUrlController.text}';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        phishingCheckResult = response.body;
      });
    } else {
      setState(() {
        phishingCheckResult = 'Error: ${response.statusCode}';
      });
    }
  }



  void viewSSL() async {
    String url = 'https://checkbait-v2.onrender.com/check_ssl?hosts=${sslUrlController.text}';

    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        sslCheckResult = response.body;
      });
    } else {
      setState(() {
        sslCheckResult = 'Error: ${response.statusCode}';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PhishGuard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Phishing Check',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phishingUrlController,
              decoration: InputDecoration(
                hintText: 'Enter a URL to check for phishing',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: checkPhishing,
              child: Text('Check'),
            ),
            SizedBox(height: 32.0),
            Text(
              'SSL Certificate Check',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: sslUrlController,
              decoration: InputDecoration(
                hintText: 'Enter a URL to check SSL certificate',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: viewSSL,
              child: Text('View'),
            ),
            SizedBox(height: 16.0),
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(phishingCheckResult),
                  Text(sslCheckResult),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}
