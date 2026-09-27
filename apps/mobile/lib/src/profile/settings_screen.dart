import 'package:flutter/material.dart';

/// Settings: language, clear cache, permissions, logout, delete account (store rule).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: const [
          ListTile(leading: Icon(Icons.language), title: Text('Language')),
          ListTile(leading: Icon(Icons.cleaning_services_outlined), title: Text('Clear cache')),
          ListTile(leading: Icon(Icons.photo_library_outlined), title: Text('Photo permission')),
          ListTile(leading: Icon(Icons.logout), title: Text('Logout')),
          ListTile(
              leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
              title: Text('Delete account', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
