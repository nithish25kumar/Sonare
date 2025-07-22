import 'package:Sonera/core/configs/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Creatorpage extends StatefulWidget {
  const Creatorpage({super.key});

  @override
  State<Creatorpage> createState() => _CreatorpageState();
}

class _CreatorpageState extends State<Creatorpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            100,
          ),
          child: AppBar(
            leading: IconButton(
                onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new)),
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50))),
            title: Text(
              'Creator Info',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 25,
                  letterSpacing: 5),
            ),
            centerTitle: true,
          )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/images/img.png'),
              ),
              const SizedBox(height: 15),
              const Text(
                'Nithishkumar K',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'VIT Vellore',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  launchUrl(Uri.parse(
                      'https://www.linkedin.com/in/nithish-kumar-9b29b3287/'));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      FontAwesomeIcons.linkedin,
                      size: 20,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "LinkedIn",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
