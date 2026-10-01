import 'package:flutter/material.dart';

import 'app_structure_theme_demo.dart';
import 'common_ui_fixes_demo.dart';
import 'core_widgets_demo.dart';
import 'input_controls_demo.dart';
import 'layout_demo.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DemoHomePage(),
  ));
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo Lab'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Core'),
              Tab(text: 'Input'),
              Tab(text: 'Layout'),
              Tab(text: 'Fixes'),
              Tab(text: 'Theme'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            CoreWidgetsDemo(),
            InputControlsDemo(),
            LayoutDemo(),
            CommonUIFixesDemo(),
            AppStructureThemeDemo(),
          ],
        ),
      ),
    );
  }
}
