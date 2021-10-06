import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tesla_annimation_ui/controllers/home_controller.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

import 'widgets/door_lock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController _controller = HomeController();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, snapshot) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {},
              selectedTab: 0,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                  builder: (context, constraints) => Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: constraints.maxHeight * 0.1,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/Car.svg',
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            right: constraints.maxWidth * 0.05,
                            child: DoorLock(
                              isLocked: _controller.isRightDoorLocked,
                              onPress: _controller.updateRightDoor,
                            ),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.05,
                            child: DoorLock(
                              isLocked: _controller.isLeftDoorLocked,
                              onPress: _controller.updateLeftDoor,
                            ),
                          ),
                          Positioned(
                            top: constraints.maxHeight * 0.13,
                            child: DoorLock(
                              isLocked: _controller.isBonnetDoorLocked,
                              onPress: _controller.updateBonnetDoor,
                            ),
                          ),
                          Positioned(
                            bottom: constraints.maxHeight * 0.17,
                            child: DoorLock(
                              isLocked: _controller.isTrunkLocked,
                              onPress: _controller.updateTrunkDoor,
                            ),
                          ),
                        ],
                      )),
            ),
          );
        });
  }
}

class TeslaBottomNavigationBar extends StatelessWidget {
  TeslaBottomNavigationBar({
    Key? key,
    required this.selectedTab,
    required this.onTap,
  }) : super(key: key);
  final int selectedTab;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      currentIndex: selectedTab,
      items: List.generate(
        kNavIconsPath.length,
        (index) => BottomNavigationBarItem(
          icon: SvgPicture.asset(
            kNavIconsPath[index],
            color: index == selectedTab ? primaryColor : Colors.white54,
          ),
          label: '',
        ),
      ),
    );
  }
}
