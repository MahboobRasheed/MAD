import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';
import 'activity_list_screen.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _lat;
  double? _lng;
  File? _image;

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
    });
  }

  Future<void> _captureImage() async {
    final picker = ImagePicker();
    // On desktop (Windows) the ImagePicker camera implementation requires a
    // camera delegate which isn't provided. Use gallery as a fallback on
    // Windows to avoid runtime crash.
    ImageSource source = ImageSource.camera;
    try {
      if (Platform.isWindows) source = ImageSource.gallery;
    } catch (_) {}
    final x = await picker.pickImage(source: source, maxWidth: 1024);
    if (x != null) setState(() => _image = File(x.path));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('SmartTracker')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(onPressed: _getLocation, child: Text('Get Location')),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(onPressed: _captureImage, child: Text('Capture Image')),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (_lat != null && _lng != null)
              Text('Location: ${_lat!.toStringAsFixed(6)}, ${_lng!.toStringAsFixed(6)}'),
            if (_image != null) ...[
              SizedBox(height: 8),
              Image.file(_image!, height: 120),
            ],
            SizedBox(height: 12),
            ElevatedButton(
                onPressed: (_lat != null && _lng != null)
                    ? () async {
                        await provider.addActivity(_lat!, _lng!, _image?.path);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Activity saved')));
                      }
                    : null,
                child: Text('Save Activity')),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen())), child: Text('Open Map'))),
                SizedBox(width: 8),
                Expanded(child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityListScreen())), child: Text('View Activities'))),
              ],
            ),
            SizedBox(height: 12),
            if (provider.loading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
