import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tesla_annimation_ui/controllers/home_controller.dart';
import 'package:tesla_annimation_ui/models/tyre_psi.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';
import 'package:tesla_annimation_ui/widgets/door_lock.dart';
import 'package:tesla_annimation_ui/widgets/temperature_details.dart';
import 'package:tesla_annimation_ui/widgets/tesla_bottom_navigation_bar.dart';

import 'battery_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();
  late AnimationController _batteryAnimationController;
  late Animation<double> _batteryAnimation;
  late Animation<double> _batteryInfoAnimation;

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
    _batteryInfoAnimation = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.6, 1.0),
    );
  }

  //Episode 3
  late AnimationController _tempAnimationController;
  //Up to this point we are using SingleTickerProvider
  //so let's change it to be able to use multiple controllers
  late Animation<double> _carShiftAnimation;
  late Animation<double> _tempInfoAnimation;
  late Animation<double> _coolGlowAnimation;

  void setupTempAnimationController() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _carShiftAnimation = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.2, 0.4),
    );
    _tempInfoAnimation = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.45, 0.65),
    );
    _coolGlowAnimation = CurvedAnimation(
      parent: _tempAnimationController,
      curve: const Interval(0.7, 1.0),
    );
  }

  // Episode 4 tires
  late AnimationController _tiresAnimationController;
  late Animation<double> _tireInfoAnimation;
  void _setupTiresAnimationController() {
    _tiresAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _tireInfoAnimation = CurvedAnimation(
      parent: _tiresAnimationController,
      curve: const Interval(0.6, 1.0),
    );
  }

  @override
  void initState() {
    setupBatteryAnimationController();
    setupTempAnimationController();
    _setupTiresAnimationController();
    super.initState();
  }

  @override
  void dispose() {
    _batteryAnimationController.dispose();
    _tempAnimationController.dispose();
    _tiresAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(
        [
          _controller,
          _batteryAnimationController,
          _tempAnimationController,
          _tiresAnimationController,
        ],
      ),
      builder: (context, snapshot) {
        return Scaffold(
          bottomNavigationBar: TeslaBottomNavigationBar(
            onTap: (index) {
              // We need to start the battery animation once the user taps on battery tab
              // But nothing happen until we add the controller to the animationBuilder
              // we have multiple controllers so we merge theme since they both are listenable
              if (index == 1) {
                _batteryAnimationController.forward();
              } else {
                if (_controller.selectedBottomNavigationTab == 1) {
                  _batteryAnimationController.reverse(from: 0.7);
                }
              }
              if (index == 2) {
                _tempAnimationController.forward();
              } else {
                if (_controller.selectedBottomNavigationTab == 2) {
                  _tempAnimationController.reverse(from: 0.4);
                }
              }
              if (index == 3) {
                _tiresAnimationController.forward();
              } else {
                if (_controller.selectedBottomNavigationTab == 3) {
                  _tiresAnimationController.reverse(from: 0.9);
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
                  SizedBox(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  ),
                  AnimatedPositioned(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    left: constraints.maxWidth / 2 * _carShiftAnimation.value,
                    duration: defaultDuration,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: constraints.maxHeight * 0.1,
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/Car.svg',
                        width: double.infinity,
                      ),
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
                  //Info Battery
                  Positioned(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    top: 50.0 * (1 - _batteryInfoAnimation.value),
                    child: Opacity(
                      opacity: _batteryInfoAnimation.value,
                      child: BatteryInfo(constraints: constraints),
                    ),
                  ),
                  //After a delay show the battery info
                  // Temp
                  Positioned(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    top: 50.0 * (1 - _tempInfoAnimation.value),
                    child: Opacity(
                      opacity: _tempInfoAnimation.value,
                      child: TemperatureDetails(controller: _controller),
                    ),
                  ),
                  Positioned(
                    right: (1 - _coolGlowAnimation.value) * -180.0,
                    child: AnimatedSwitcher(
                      duration: defaultDuration,
                      child: _controller.isCoolSelected
                          ? Image.asset(
                              'assets/images/Cool_glow_2.png',
                              width: 220.0,
                              key: UniqueKey(),
                            )
                          : Image.asset(
                              'assets/images/Hot_glow_4.png',
                              width: 220.0,
                              key: UniqueKey(),
                            ),
                    ),
                  ),

                  // Tires
                  Positioned(
                    left: 10,
                    top: 20,
                    height: constraints.maxHeight *
                        0.45 *
                        (_tireInfoAnimation.value),
                    width: constraints.maxWidth *
                        0.45 *
                        (_tireInfoAnimation.value),
                    child: Opacity(
                      child: TyrePsiCard(tyrePsi: demoPsiList.first),
                      opacity: _tireInfoAnimation.value,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration,
                    right: 10,
                    top: 20,
                    height: constraints.maxHeight *
                        0.45 *
                        (_tireInfoAnimation.value),
                    width: constraints.maxWidth *
                        0.45 *
                        (_tireInfoAnimation.value),
                    child: Opacity(
                      child: TyrePsiCard(tyrePsi: demoPsiList[1]),
                      opacity: _tireInfoAnimation.value,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration * 1.3,
                    left: 10,
                    bottom: 20,
                    height: constraints.maxHeight *
                        0.45 *
                        (_tireInfoAnimation.value),
                    width: constraints.maxWidth *
                        0.45 *
                        (_tireInfoAnimation.value),
                    child: Opacity(
                      child: TyrePsiCard(tyrePsi: demoPsiList[2]),
                      opacity: _tireInfoAnimation.value,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: defaultDuration * 1.5,
                    right: 10,
                    bottom: 20,
                    height: constraints.maxHeight *
                        0.45 *
                        (_tireInfoAnimation.value),
                    width: constraints.maxWidth *
                        0.45 *
                        (_tireInfoAnimation.value),
                    child: Opacity(
                      child: TyrePsiCard(tyrePsi: demoPsiList[3]),
                      opacity: _tireInfoAnimation.value,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TyrePsiCard extends StatelessWidget {
  const TyrePsiCard({
    Key? key,
    required this.tyrePsi,
  }) : super(key: key);

  final TyrePsi tyrePsi;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: tyrePsi.isLowPressure
            ? redColor.withOpacity(0.2)
            : primaryColor.withOpacity(0.2),
        border: Border.all(
          color: tyrePsi.isLowPressure ? redColor : primaryColor,
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tyrePsi.psi.toString() + 'Psi',
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: defaultPadding),
          Text(
            tyrePsi.temp.toString() + '\u2103',
            style: Theme.of(context).textTheme.caption,
          ),
          tyrePsi.isLowPressure ? const Spacer() : const SizedBox.shrink(),
          tyrePsi.isLowPressure
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LOW'.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'PRESSURE'.toUpperCase(),
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                            fontSize: 16.0,
                          ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
