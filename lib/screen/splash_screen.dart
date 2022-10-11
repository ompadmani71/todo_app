import 'package:firebase_miner/screen/home_screen.dart';
import 'package:firebase_miner/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final blueColor = const Color(0XFF5e92f3);
  final yellowColor = const Color(0XFFfdd835);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)  {

      Future.delayed(
          const Duration(seconds: 3),
              ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            bool? isLogged = prefs.getBool("isLogged");

            if(isLogged == true){
              return Get.offAll(const HomeScreen());
            } else{
              return Get.offAll(const LoginScreen());
            }

          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [blueColor, yellowColor],
            ),
            color: blueColor.withOpacity(0.30),
            image: const DecorationImage(
                image: AssetImage("assets/images/flutter_fire.png"))),
      ),
    );
  }
}
