import 'package:adoptanddonate_new/screens/donateanimal/donor_cat_list.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class BannerWidget extends StatelessWidget {

  static const String id = 'banner-screen';
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height * 0.25,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(0, 188, 212, 1),
      boxShadow: [
        BoxShadow(
          color: Colors.white.withOpacity(0.2), // Light shadow
          offset: const Offset(-4, -4),
          blurRadius: 8,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // Dark shadow
          offset: const Offset(4, 4),
          blurRadius: 8,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      "CATS",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 55.0,
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                        child: AnimatedTextKit(
                          repeatForever: true,
                          isRepeatingAnimation: true,
                          animatedTexts: [
                            FadeAnimatedText(
                              'Save Life',
                              duration: const Duration(seconds: 4),
                            ),
                            FadeAnimatedText(
                              'Give Home',
                              duration: const Duration(seconds: 4),
                            ),
                            FadeAnimatedText('Do Right thing',
                                duration: const Duration(seconds: 4)),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Image.asset('lib/assets/images/banner.jpg', height: 128,width: 220,fit: BoxFit.cover,),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Adopt Cat",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, DonorCategoryListScreen.id);
                  },
                  style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.5),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Donate Cat',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
  
  }
}