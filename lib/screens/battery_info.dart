import 'package:flutter/material.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

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
            children: const [
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
