import 'package:flutter/material.dart';
import 'package:test/screens/tutorial.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 255),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            double logoSize = width * 0.4;
            double fontSizeTitle = width * 0.07;
            double fontSizeSubtitle = width * 0.03;
            double buttonWidth = width * 0.6;
            double buttonHeight = height * 0.08;

            return Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: logoSize,
                        child: Image.asset('assets/images/Logo.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "Event Echo",
                          style: TextStyle(
                            fontSize: fontSizeTitle,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        "Echoing Moments, Mastering Time",
                        style: TextStyle(
                          fontSize: fontSizeSubtitle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorialScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: buttonWidth * 0.1,
                        vertical: buttonHeight * 0.15),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle * 0.6,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "By clicking on 'Get Started', you agree to our",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(199, 0, 0, 0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Text(
                        " and ",
                        style: TextStyle(
                          color: Color.fromARGB(199, 0, 0, 0),
                          fontSize: 12,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
