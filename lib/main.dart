import 'dart:convert';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'Pages/firstPage.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Firstpage(),
    );
  }
}

class mePage extends StatefulWidget {
  String question;
  String? name;
  String finalwords;
  mePage({super.key, required this.question, required this.finalwords, this.name});


  @override
  State<mePage> createState() => _mePageState();
}

class _mePageState extends State<mePage> {
  double top = 300;
  double left = 100;
  bool isAccepted = false; // Ha bosilganini tekshirish
  bool isMoved = false; // Tugma hali joyidan jilmaganini bilish uchun

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Faqat bir marta, o'yin boshlanishidan oldin markazni hisoblaymiz
    if (!isMoved) {
      top = MediaQuery.of(context).size.height / 2 + 50; // Savoldan bir oz pastroqda
      left = MediaQuery.of(context).size.width / 2 + 50; // "Yes" dan o'ngroqda
    }
  }

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void moveButton() {
    setState(() {
      // Ekran o'lchamidan chiqib ketmasligi uchun chegaralangan random
      final double maxHeight = MediaQuery.of(context).size.height - 100;
      final double maxWidth = MediaQuery.of(context).size.width - 100;

      top = Random().nextDouble() * maxHeight;
      left = Random().nextDouble() * maxWidth;
    });
  }

  String fullquestion(){
    if(widget.name.toString().isEmpty){
      return "${widget.question}";
    }
    else{
      return "${widget.name!+","+widget.question}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient

          // 2. Main Content
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isAccepted ? " ${widget.finalwords}" : "${fullquestion()}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.afacad(
                      fontSize: MediaQuery.of(context).size.width < 600 ? 50 : 80,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Agar "Ha" bosilmagan bo'lsa tugmalarni ko'rsatish
                  if (!isAccepted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              isAccepted = true;
                            });
                            _confettiController.play();
                          },
                          child: Text("Yes!", style: GoogleFonts.poppins(fontSize: 20)),
                        ),
                        const SizedBox(width: 150), // "No" tugmasi uchun joy
                      ],
                    ),
                ],
              ),
            ),
          ),

          // 3. "No" tugmasi (Stack ichida erkin harakatlanadi)
          if (!isAccepted)
            Positioned(
              top: top,
              left: left,
              child: MouseRegion(
                onEnter: (_) => moveButton(), // Sichqoncha yaqinlashganda qochadi
                child: SizedBox(
                  width: 90,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      side: BorderSide(color: Colors.blueAccent)
                    ),
                    onPressed: moveButton,
                    child: const Text("No"),
                  ),
                ),
              ),
            ),


          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.red, Colors.pink, Colors.white, Colors.orange],
            ),
          ),
        ],
      ),
    );
  }
}