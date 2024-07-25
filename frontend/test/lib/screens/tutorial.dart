import 'package:flutter/material.dart';
import 'package:test/screens/auth.dart';
import 'package:test/widgets/tutorial_widget.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 244, 255),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            double fontSizeTitle = width * 0.06;
            double imageWidth = width * 0.2;
            double paddingValue = width * 0.05;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tutorial",
                  style: TextStyle(
                    fontSize: fontSizeTitle,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TutorialRowsColumn(
                      imageFile: 'assets/images/tutorial/date2.png',
                      head: 'Date',
                      bodyTop: 'Input the date a',
                      bodyBottom: 'certificate was given',
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: paddingValue * 2,
                        top: paddingValue * 2,
                      ),
                      alignment: Alignment.bottomRight,
                      width: imageWidth,
                      height: height * 0.2,
                      child: Image.asset('assets/images/tutorial/right.png'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          right: paddingValue * 4,
                          top: paddingValue * 2,
                          left: paddingValue),
                      alignment: Alignment.bottomRight,
                      width: imageWidth,
                      height: height * 0.2,
                      child: Image.asset('assets/images/tutorial/left.png'),
                    ),
                    const TutorialRowsColumn(
                      imageFile: 'assets/images/tutorial/document2.png',
                      head: 'Document',
                      bodyTop: 'Input the type',
                      bodyBottom: 'of certificate gotten',
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      top: paddingValue,
                      left: paddingValue * 1.5,
                      bottom: paddingValue * 2),
                  child: const AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(seconds: 1),
                    child: TutorialRowsColumn(
                      imageFile: 'assets/images/tutorial/relax2.png',
                      head: 'Relax',
                      bodyTop: 'Sit back while we',
                      bodyBottom: 'track its expiry for you',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.01),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSizeTitle * 0.8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
