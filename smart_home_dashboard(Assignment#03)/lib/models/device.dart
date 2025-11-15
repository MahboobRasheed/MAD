import 'package:flutter/foundation.dart';

enum DeviceType { Light, Fan, AC, Camera }

class Device {
  String id;
  String name;
  DeviceType type;
  String room;
  bool isOn;
  double level;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.level = 100,
  });

  String get statusText => '${describeEnum(type)} is ${isOn ? 'ON' : 'OFF'}';
}
