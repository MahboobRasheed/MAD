import 'dart:io';

import 'package:flutter/material.dart';
import '../models/activity.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;
  final VoidCallback onDelete;
  ActivityTile({required this.activity, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: activity.imagePath != null ? Image.file(File(activity.imagePath!), width: 56, height: 56, fit: BoxFit.cover) : null,
      title: Text('${activity.latitude.toStringAsFixed(5)}, ${activity.longitude.toStringAsFixed(5)}'),
      subtitle: Text(activity.timestamp.toLocal().toString()),
      trailing: IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
    );
  }
}
