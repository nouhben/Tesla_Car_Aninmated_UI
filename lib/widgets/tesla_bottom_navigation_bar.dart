import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

class TeslaBottomNavigationBar extends StatelessWidget {
  const TeslaBottomNavigationBar({
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
