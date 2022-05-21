import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/pages/drawer_page/drawer_page.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_fab.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: getCustomAppbar(context, title: 'Chat IT'),
      drawer: Drawer(child: DrawerPage()),
      floatingActionButton: FABPersonal(
        onPressed: () {},
      ),
    );
  }
}