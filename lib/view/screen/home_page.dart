import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../provider/solar_provider.dart';
import 'details_page.dart';
import 'favourite_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final Animation<double> _rotationAnimation;
  final PageController _pageController = PageController(viewportFraction: 0.8);

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), // Adjust rotation speed
    )..repeat(); // Non-stop rotation

    // Initialize the Tween for rotation
    _rotationAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_rotationController);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerTrue = Provider.of<SolarProvider>(context);
    final providerFalse = Provider.of<SolarProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7F52FF), Color(0xFFFF90FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explore\nSolar System',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return PageView.builder(
                    controller: _pageController,
                    itemCount: providerTrue.solarList.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = _pageController.hasClients
                              ? (_pageController.page ?? _pageController.initialPage.toDouble())
                              : _pageController.initialPage.toDouble();
                          double scale =
                          (1 - (value - index).abs()).clamp(0.8, 1.0);

                          return Transform.scale(
                            scale: scale,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // White card background
                                  Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.4),
                                          Colors.white.withOpacity(0.1),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 50),
                                          Text(
                                            providerTrue.solarList[index].name,
                                            style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height: 100,
                                            child: Text(
                                              providerTrue.solarList[index]
                                                  .description ??
                                                  "Lorem Ipsum Dolor Sit Amet Consectetur.",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Planet image with non-stop rotation
                                  Positioned(
                                    top: 70,
                                    child: AnimatedBuilder(
                                      animation: _rotationAnimation,
                                      builder: (context, child) {
                                        return Transform.rotate(
                                          angle: _rotationAnimation.value,
                                          child: Hero(
                                            tag: index,
                                            child: Container(
                                              height: 200,
                                              width: 200,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(providerTrue
                                                      .solarList[index].image),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 60,
                                      child: GestureDetector(
                                        onTap: () {
                                          providerFalse.changePlanteIndex(index);
                                          Navigator.of(context).push(PageTransition(
                                              duration:
                                              const Duration(milliseconds: 500),
                                              child: const DetailsScreen(),
                                              type:
                                              PageTransitionType.rightToLeft));
                                        },
                                        child: Container(
                                          height: 53,
                                          width: 53,
                                          decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Icon(Icons.arrow_forward),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        // Track the selected tab
        onTap: (index) {
          setState(() {
            Pageindex = index;
            print(Pageindex);
            Navigator.of(context).push(
              PageTransition(
                  duration: const Duration(milliseconds: 500),
                  child: pages,
                  type: PageTransitionType.rightToLeft),
            );
          });
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

int Pageindex = 0;
Widget pages = FavouriteScreen();
