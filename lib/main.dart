import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(primarySwatch: Colors.brown),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  double age = 0.0;
  var selectedyear;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
    animation = animationController;
    animation = Tween<double>(begin: 0, end: age).animate(
        CurvedAnimation(parent: animationController, curve: Curves.fastLinearToSlowEaseIn)
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _showPicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1500),
      lastDate: DateTime.now(),
    ).then((dt) {
      if (dt != null) {
        setState(() {
          selectedyear = dt.year;
          CalculateAge();
        });
      }
    });
  }

  void CalculateAge() {
    setState(() {
      age = (DateTime.now().year - selectedyear!).toDouble();
      animation = Tween<double>(begin: animation.value, end: age).animate(
          CurvedAnimation(parent: animationController, curve: Curves.bounceOut)
      );
    });
    animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Age Calculator"),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: _showPicker,
              child: Text(selectedyear != null ? selectedyear.toString() : "Select your year of birth"),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black, width: 3),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Your Age is ${animation.value.toStringAsFixed(0)}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
