import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ortho_connect/main.dart';


class LeftSide extends StatelessWidget {
  const LeftSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Container(
        color: sidebarColor,
        child: Column(
          children: [
            WindowTitleBarBox(child: MoveWindow()),
            Obx(() => SizedBox(
              height: Get.find<LeftSideController>().containerHeight.value,
              child: ListView(
                children: [
                  // a header for the sidebar with the logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    //image with adaptive size
                    child: Image.asset('assets/logo.png', fit: BoxFit.contain,),
                  ),
                  const SizedBox(height: 40),
                  ListTile(
                    title: Text('Home', style: GoogleFonts.abel(color: Colors.white),),
                    onTap: () {
                      Get.find<RightContentController>().updateSelectedOption('Home');
                    },
                  ),
                  ListTile(
                    title: Text('Patients List', style: GoogleFonts.abel(color: Colors.white),),
                    onTap: () {
                      Get.find<RightContentController>().updateSelectedOption('patientsList');
                    },
                  ),
                  ListTile(
                    title: Text('Settings', style: GoogleFonts.abel(color: Colors.white),),
                    onTap: () {
                      Get.find<RightContentController>().updateSelectedOption('Settings');
                    },
                  ),
                ],
              ),
            )),
            // Add more buttons as needed
            Expanded(child: Container())
          ],
        ),
      ),
    );
  }
}