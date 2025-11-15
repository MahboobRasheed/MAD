import 'package:flutter/material.dart';
import '../models/device.dart';
import '../widgets/device_card.dart';
import 'device_detail.dart';
import 'add_device.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Device> devices = [];

  @override
  void initState() {
    super.initState();
    devices = [
      Device(id: "1", name: "Living Room Light", type: DeviceType.Light, room: "Living Room", isOn: true, level: 80),
      Device(id: "2", name: "Bedroom Fan", type: DeviceType.Fan, room: "Bedroom", isOn: false, level: 60),
      Device(id: "3", name: "Hall AC", type: DeviceType.AC, room: "Hall", isOn: true, level: 22),
      Device(id: "4", name: "Front Camera", type: DeviceType.Camera, room: "Entrance", isOn: true),
    ];
  }

  void _toggle(Device d, bool value) {
    setState(() {
      d.isOn = value;
    });
  }

  Future<void> _addDevice() async {
    final newDevice = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddDeviceScreen()),
    );

    if (newDevice != null) {
      setState(() => devices.add(newDevice));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    int count = width > 800 ? 4 : width > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Home Dashboard"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addDevice,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.count(
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: devices
              .map(
                (d) => DeviceCard(
                  device: d,
                  onToggle: (v) => _toggle(d, v),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DeviceDetailScreen(device: d),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
