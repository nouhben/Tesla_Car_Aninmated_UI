import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

class DoorLock extends StatelessWidget {
  const DoorLock({
    Key? key,
    required this.onPress,
    required this.isLocked,
  }) : super(key: key);

  final VoidCallback onPress;
  final bool isLocked;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      // TODO: animate the lock
      child: AnimatedSwitcher(
        duration: defaultDuration,
        child: isLocked
            //We use key because if we don't flutter thinks
            //it is the same widget so it does not show any animation
            //when we use keys it knows they are different
            ? SvgPicture.asset(
                'assets/icons/door_lock.svg',
                key: const ValueKey('lock'),
              )
            : SvgPicture.asset(
                'assets/icons/door_unlock.svg',
                key: const ValueKey('unlock'),
              ),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        switchInCurve: Curves.easeInOutBack, // To add jumping effect
      ),
    );
  }
}
