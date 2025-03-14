import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';
import '../../main.dart';

class RightWelcomeScreen extends StatelessWidget {
  const RightWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [backgroundStartColor, backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            WindowTitleBarBox(
              child: Row(
                children: [Expanded(child: MoveWindow()), const WindowButtons()],
              ),
            ),

            SizedBox(height: 260, child: Image.asset('assets/logo.png')),
            const SizedBox(height: 40),
            //clock with seconds
            DigitalClock(
              digitAnimationStyle: Curves.elasticOut,
              is24HourTimeFormat: false,
              areaDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              hourMinuteDigitTextStyle: GoogleFonts.abel(
                color: Colors.white,
                fontSize: 50,
              ),
              amPmDigitTextStyle: GoogleFonts.abel(
                color: Colors.white,
                fontSize: 20,
              ),
              secondDigitTextStyle: GoogleFonts.abel(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Back to the login', style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 20),
            // Add more components as needed
          ],
        ),
      ),
    );
  }
}
