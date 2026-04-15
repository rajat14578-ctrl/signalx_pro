import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SignalScreen(),
    );
  }
}

class SignalScreen extends StatefulWidget {
  @override
  _SignalScreenState createState() => _SignalScreenState();
}

class _SignalScreenState extends State<SignalScreen> {
  Map signal = {};

  Future<void> fetchSignal() async {
    var res = await http.get(Uri.parse("http://YOUR_IP:5000/signal"));
    setState(() {
      signal = json.decode(res.body);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSignal();
  }

  @override
  Widget build(BuildContext context) {
    String signalType = signal['signal'] ?? "WAIT";

    Color signalColor = signalType == "BUY"
        ? Colors.green
        : signalType == "SELL"
            ? Colors.red
            : Colors.grey;

    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      appBar: AppBar(
        title: Text("🚀 SignalX Pro"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: signal.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text("Signal",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey)),
                        SizedBox(height: 10),
                        Text(signalType,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: signalColor)),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  buildCard("Pair", signal['pair']),
                  SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: buildCard("Entry", signal['entry'])),
                      SizedBox(width: 10),
                      Expanded(child: buildCard("SL", signal['sl'], color: Colors.red)),
                      SizedBox(width: 10),
                      Expanded(child: buildCard("TP", signal['tp'], color: Colors.green)),
                    ],
                  ),

                  SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: fetchSignal,
                    icon: Icon(Icons.refresh),
                    label: Text("Refresh"),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildCard(String title, dynamic value, {Color color = Colors.white}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          SizedBox(height: 8),
          Text(value.toString(),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
        ],
      ),
    );
  }
}
