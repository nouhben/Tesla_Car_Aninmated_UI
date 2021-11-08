import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

class TemperatureModeControlButton extends StatelessWidget {
  const TemperatureModeControlButton({
    Key? key,
    required this.svgIconPath,
    required this.title,
    required this.onPress,
    this.isActive = false,
    required this.activeColor,
  }) : super(key: key);

  final String svgIconPath;
  final String title;
  final VoidCallback onPress;
  final bool isActive;
  final Color activeColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(66.0),
      ),
      child: Column(
        children: [
          AnimatedContainer(
            width: isActive ? 76.0 : 50.0,
            height: isActive ? 76.0 : 50.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOutBack,
            child: SvgPicture.asset(
              svgIconPath,
              color: isActive ? activeColor : Colors.white38,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              color: isActive ? activeColor : Colors.white38,
              fontSize: 16.0,
            ),
            child: Text(
              title.toUpperCase(),
              // style: TextStyle(
              //   color: isActive ? activeColor : Colors.white38,
              //   fontSize: 16.0,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
