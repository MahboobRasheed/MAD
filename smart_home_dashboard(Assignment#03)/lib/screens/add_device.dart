import 'package:flutter/material.dart';
import '../models/device.dart';
import 'package:uuid/uuid.dart';

class AddDeviceScreen extends StatefulWidget {
  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String room = "";
  bool isOn = false;
  DeviceType type = DeviceType.Light;

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final device = Device(
        id: Uuid().v4(),
        name: name,
        type: type,
        room: room,
        isOn: isOn,
      );

      Navigator.pop(context, device);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Device")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Device Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => name = v!,
              ),
              DropdownButtonFormField<DeviceType>(
                value: type,
                items: DeviceType.values
                    .map((t) => DropdownMenuItem(
                          child: Text(t.toString().split('.').last),
                          value: t,
                        ))
                    .toList(),
                onChanged: (v) => setState(() => type = v!),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Room Name"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => room = v!,
              ),
              SwitchListTile(
                title: Text("Power ON"),
                value: isOn,
                onChanged: (v) => setState(() => isOn = v),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submit,
                child: Text("Add Device"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
