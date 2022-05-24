import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/pages/chat_page/chat_page.dart';
import 'package:pre_proyecto_universales/pages/drawer_page/drawer_page.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_canal.dart';
import 'package:pre_proyecto_universales/widgets/widget_fab.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CanalModel> canales = [];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          appBar: getCustomAppbar(context, title: 'Chat IT'),
          drawer: Drawer(child: DrawerPage()),
          floatingActionButton: FABPersonal(
            onPressed: () {},
          ),
          body: FutureBuilder(
            future: ChatService.shared.buscarCanales(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasData) {
                canales = snapshot.requireData as List<CanalModel>;
                print("SI HAY INFORMACIÓN");
              } else {
                print("NO HAY INFORMACIÓN");
              }

              return buildChats();
            },
          ),
        );
      },
    );
  }

  Widget buildChats() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: canales.length,
        itemBuilder: (context, index) {
          final canal = canales[index];

          if (canales.isNotEmpty) {
            return Channel(
              titulo: canal.name!,
              descripcion: canal.description!,
              onTap: () {
                ChatService.shared.buscarCanales();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            titulo: canal.name!,
                          )),
                );
              },
            );
          } else {
            return Container();
          }
        },
      );
}
