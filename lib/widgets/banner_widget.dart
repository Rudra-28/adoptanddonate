import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 25,
          color: const Color.fromRGBO(0, 188, 212, 1),
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
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "DOGS",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 20),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 45.0,
                            child: DefaultTextStyle(
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                isRepeatingAnimation: true,
                                animatedTexts: [
                                  FadeAnimatedText('Reached 1000 donations in last 1 week',duration: const Duration(seconds: 4)),
                                  FadeAnimatedText('Comfortable way of giving new home to speechless animals', duration:const  Duration(seconds: 4)),
                                  FadeAnimatedText('Do Right thing',duration:const Duration(seconds: 4)),
                                ],
                                onTap: () {
                                  print("Tap Event");
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: Colors.white,
                          oppositeShadowLightSource: true,
                        ),
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network('https://icons8.com/icon/46394/cat'),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(child: NeumorphicButton(
                      onPressed: (){},
                    style: const NeumorphicStyle(color: Colors.white),
                      child: const Text("Adopt Cat", textAlign: TextAlign.center,),
                    )),
                    const SizedBox(width: 20,),
                Expanded(child: NeumorphicButton(
                  onPressed: (){},
                  child:const Text('Donate Cat', textAlign: TextAlign.center),
                )),
                  ],
                )
              ],
            ),
          ),),
    );
  }
}
