import 'package:flutter/foundation.dart';

class HomeController with ChangeNotifier {
  bool isRightDoorLocked = true;
  bool isLeftDoorLocked = true;
  bool isBonnetDoorLocked = true;
  bool isTrunkLocked = true;

  void updateRightDoor() {
    isRightDoorLocked = !isRightDoorLocked;
    notifyListeners();
  }

  void updateLeftDoor() {
    isLeftDoorLocked = !isLeftDoorLocked;
    notifyListeners();
  }

  void updateBonnetDoor() {
    isBonnetDoorLocked = !isBonnetDoorLocked;
    notifyListeners();
  }

  void updateTrunkDoor() {
    isTrunkLocked = !isTrunkLocked;
    notifyListeners();
  }
}
