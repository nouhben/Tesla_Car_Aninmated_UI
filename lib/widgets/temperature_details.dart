import 'package:flutter/material.dart';
import 'package:tesla_annimation_ui/controllers/home_controller.dart';
import 'package:tesla_annimation_ui/shared/constants.dart';

import 'temperature_mode_control_button.dart';

class TemperatureDetails extends StatelessWidget {
  const TemperatureDetails({
    Key? key,
    required HomeController controller,
  })  : _controller = controller,
        super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TemperatureModeControlButton(
                  title: 'cool',
                  svgIconPath: 'assets/icons/coolShape.svg',
                  activeColor: primaryColor,
                  isActive: _controller.isCoolSelected,
                  onPress: _controller.updateCoolSelected,
                ),
                const SizedBox(width: defaultPadding),
                TemperatureModeControlButton(
                  title: 'heat',
                  svgIconPath: 'assets/icons/heatShape.svg',
                  activeColor: redColor,
                  isActive: !_controller.isCoolSelected,
                  onPress: _controller.updateCoolSelected,
                ),
              ],
            ),
          ),
          const Spacer(),
          const TemperatureCounter(),
          const Spacer(),
          Text(
            'current temperature'.toUpperCase(),
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'inside'.toUpperCase(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '29' ' \u2103',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
              const SizedBox(width: defaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'outside'.toUpperCase(),
                    style: Theme.of(context).textTheme.caption,
                  ),
                  Text(
                    '31' ' \u2103',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TemperatureCounter extends StatefulWidget {
  const TemperatureCounter({
    Key? key,
  }) : super(key: key);

  @override
  State<TemperatureCounter> createState() => _TemperatureCounterState();
}

class _TemperatureCounterState extends State<TemperatureCounter> {
  int temperature = 20;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => setState(() => temperature++),
          icon: const Icon(Icons.arrow_drop_up, size: 48.0),
        ),
        Text(
          temperature.toString() + ' \u2103',
          style: const TextStyle(
            fontSize: 76.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => setState(() => temperature--),
          icon: const Icon(Icons.arrow_drop_down, size: 48.0),
        ),
      ],
    );
  }
}
