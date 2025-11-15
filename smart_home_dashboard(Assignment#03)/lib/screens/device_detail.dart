import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceDetailScreen extends StatefulWidget {
  final Device device;
  DeviceDetailScreen({required this.device});

  @override
  _DeviceDetailScreenState createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  late double level;

  @override
  void initState() {
    super.initState();
    level = widget.device.level;
  }

  IconData icon(DeviceType type) {
    switch (type) {
      case DeviceType.Light:
        return Icons.lightbulb;
      case DeviceType.Fan:
        return Icons.toys;
      case DeviceType.AC:
        return Icons.ac_unit;
      case DeviceType.Camera:
        return Icons.videocam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon(widget.device.type), size: 120),
            SizedBox(height: 10),
            Text(widget.device.statusText, style: TextStyle(fontSize: 18)),
            Switch(
              value: widget.device.isOn,
              onChanged: (v) => setState(() => widget.device.isOn = v),
            ),
            SizedBox(height: 20),
            if (widget.device.type == DeviceType.Light ||
                widget.device.type == DeviceType.Fan)
              Slider(
                min: 0,
                max: 100,
                value: level,
                onChanged: widget.device.isOn
                    ? (v) {
                        setState(() {
                          level = v;
                          widget.device.level = v;
                        });
                      }
                    : null,
              )
            else if (widget.device.type == DeviceType.AC)
              Slider(
                min: 16,
                max: 30,
                value: widget.device.level,
                onChanged: widget.device.isOn
                    ? (v) => setState(() => widget.device.level = v)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
