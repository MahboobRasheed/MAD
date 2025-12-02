import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';

class ActivityListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Activities')),
      body: RefreshIndicator(
        onRefresh: () => provider.loadActivities(),
        child: provider.loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: provider.activities.length,
                itemBuilder: (_, i) {
                  final a = provider.activities[i];
                  return ListTile(
                    leading: a.imagePath != null ? Image.file(File(a.imagePath!), width: 56, height: 56, fit: BoxFit.cover) : null,
                    title: Text('${a.latitude.toStringAsFixed(5)}, ${a.longitude.toStringAsFixed(5)}'),
                    subtitle: Text(a.timestamp.toLocal().toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await provider.deleteActivity(a.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted')));
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
