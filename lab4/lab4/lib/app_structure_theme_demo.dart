import 'package:flutter/material.dart';

class AppStructureThemeDemo extends StatefulWidget {
  const AppStructureThemeDemo({super.key});

  @override
  State<AppStructureThemeDemo> createState() => _AppStructureThemeDemoState();
}

class _AppStructureThemeDemoState extends State<AppStructureThemeDemo> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    // Tạo ThemeData dựa trên trạng thái _isDarkMode
    final themeData = _isDarkMode ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: themeData,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exercise 4 – App Structure'),
          actions: [
            Row(
              children: [
                const Text('Dark'),
                Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ],
            )
          ],
        ),
        body: const Center(
          child: Text(
            'This is a simple screen with theme toggle.',
            style: TextStyle(fontSize: 16),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('FAB Clicked!')),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}