import 'package:flutter/material.dart';

import '../../../common/widgets/button/basic_app_button.dart';
import '../../../core/configs/assets/app_images.dart';

import '../../choose_mode/pages/choose_mode.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.introBG),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                // 🟣 App Name Header
                const Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Sonare',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const Spacer(),

                const Text(
                  'Feel the Beat, Live the Moment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 21),

                const Text(
                  'Sonare brings you endless music without limits. Discover your sound, skip the ads, and vibe freely.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                BasicAppButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ChooseModePage(),
                      ),
                    );
                  },
                  title: 'Get Started',
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
