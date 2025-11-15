import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  DeviceCard({
    required this.device,
    required this.onToggle,
    required this.onTap,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  double scale = 1.0;

  IconData icon(DeviceType type) {
    switch (type) {
      case DeviceType.Light:
        return Icons.lightbulb_outline;
      case DeviceType.Fan:
        return Icons.toys;
      case DeviceType.AC:
        return Icons.ac_unit;
      case DeviceType.Camera:
        return Icons.videocam_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => scale = 0.95),
      onTapUp: (_) => setState(() => scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: Duration(milliseconds: 120),
        scale: scale,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon(widget.device.type), size: 30),
                    Switch(
                      value: widget.device.isOn,
                      onChanged: widget.onToggle,
                    )
                  ],
                ),
                Spacer(),
                Text(widget.device.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(widget.device.statusText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
