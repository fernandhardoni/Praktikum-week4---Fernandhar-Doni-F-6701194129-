import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: CalculatorScreen(),
  ));
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController number1Controller = TextEditingController();
  final TextEditingController number2Controller = TextEditingController();
  final TextEditingController operationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Sederhana"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: number1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Input Bilangan 1'),
            ),
            TextField(
              controller: number2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Input Bilangan 2'),
            ),
            TextField(
              controller: operationController,
              decoration: InputDecoration(labelText: 'Input Operasi Aritmatika  ( + , - , * , / )'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: performCalculation,
              child: Text('Hitung'),
            ),
            ElevatedButton(
              onPressed: navigateToResultScreen,
              child: Text('Tampilkan Hasil'),
            ),
          ],
        ),
      ),
    );
  }

  void performCalculation() {
    double num1 = double.tryParse(number1Controller.text) ?? 0.0;
    double num2 = double.tryParse(number2Controller.text) ?? 0.0;
    String operation = operationController.text;
    double result = 0.0;

    if (operation == '+') {
      result = num1 + num2;
    } else if (operation == '-') {
      result = num1 - num2;
    } else if (operation == '*') {
      result = num1 * num2;
    } else if (operation == '/') {
      if (num2 != 0) {
        result = num1 / num2;
      } else {
        // Handle division by zero
        result = 0.0;
      }
    }

    saveResult(result, operation);
  }

  void saveResult(double result, String operation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('result', result);
    prefs.setString('operation', operation);
  }

  void navigateToResultScreen() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ResultScreen(),
    ));
  }
}

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double result = 0.0;
  String operation = "";

  @override
  void initState() {
    super.initState();
    loadResult();
  }

  void loadResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      result = prefs.getDouble('result') ?? 0.0;
      operation = prefs.getString('operation') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil Operasi Aritmatika"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hasil: $result'),
            Text('Operasi: $operation'),
          ],
        ),
      ),
    );
  }
}
