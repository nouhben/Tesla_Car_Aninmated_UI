import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _batteryAnimationController;
  late Animation<double> _batteryAnimation;
  void setupBatteryAnimationController() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _batteryAnimation = CurvedAnimation(
      parent: _batteryAnimationController,
      // Starts from the beginning to half i.e 300ms
      curve: const Interval(0.0, 0.5),
    );
  }

  @override
  void initState() {
    setupBatteryAnimationController();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([_controller, _batteryAnimationController]),
        builder: (context, snapshot) {
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                // We need to start the battery animation once the user taps on battery tab
                // But nothing happend untill we add the controller to the animationBuilder
                // we have multiple controllers so we merge theme sincxe they bot are listenbales
                if (index == 1) {
                  _batteryAnimationController.forward();
                } else {
                  if (_controller.selectedBottomNavigationTab == 1) {
                    _batteryAnimationController.reverse();
                  }
                }
                _controller.onBottomNavigationTabChange(index);
              },
              selectedTab: _controller.selectedBottomNavigationTab,
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
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomNavigationTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth * 0.5,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomNavigationTab == 0
                            ? 1.0
                            : 0.0,
                        child: DoorLock(
                          isLocked: _controller.isRightDoorLocked,
                          onPress: _controller.updateRightDoor,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomNavigationTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth * 0.5,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomNavigationTab == 0
                            ? 1.0
                            : 0.0,
                        child: DoorLock(
                          isLocked: _controller.isLeftDoorLocked,
                          onPress: _controller.updateLeftDoor,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomNavigationTab == 0
                          ? constraints.maxHeight * 0.13
                          : constraints.maxHeight * 0.5,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomNavigationTab == 0
                            ? 1.0
                            : 0.0,
                        child: DoorLock(
                          isLocked: _controller.isBonnetDoorLocked,
                          onPress: _controller.updateBonnetDoor,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomNavigationTab == 0
                          ? constraints.maxHeight * 0.17
                          : constraints.maxHeight * 0.5,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomNavigationTab == 0
                            ? 1.0
                            : 0.0,
                        child: DoorLock(
                          isLocked: _controller.isTrunkLocked,
                          onPress: _controller.updateTrunkDoor,
                        ),
                      ),
                    ),
                    // Now that the Locks will hide
                    // We show the middle battery so another hidden animated opacity and position
                    //Battery
                    Opacity(
                      opacity: _batteryAnimation.value,
                      child: SvgPicture.asset(
                        'assets/icons/Battery.svg',
                        width: constraints.maxWidth * 0.4,
                      ),
                    ),
                    //Info
                    BatteryInfo(constraints: constraints),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class BatteryInfo extends StatelessWidget {
  const BatteryInfo({
    Key? key,
    required this.constraints,
  }) : super(key: key);
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '250 mi',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: Colors.white),
        ),
        const Text(
          '68%',
          style: TextStyle(fontSize: 24.0),
        ),
        const Spacer(),
        Text(
          'Charging'.toUpperCase(),
          style: const TextStyle(fontSize: 20.0),
        ),
        const Text(
          '16 min remaining',
          style: TextStyle(fontSize: 20.0),
        ),
        SizedBox(height: constraints.maxHeight * 0.15),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "26 mi/hr",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "320 v",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: defaultPadding),
      ],
    );
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
