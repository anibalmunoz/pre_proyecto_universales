import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/chat_page/chat_page.dart';
import 'package:pre_proyecto_universales/pages/drawer_page/drawer_page.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/widgets/widget_appbar.dart';
import 'package:pre_proyecto_universales/widgets/widget_canal.dart';
import 'package:pre_proyecto_universales/widgets/widget_fab.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UsuarioModel? user;
  List<CanalModel> canalesLista = [];

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    user = authService.getUsuario();

    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Scaffold(
          appBar: getCustomAppbar(context, title: 'Chat IT'),
          drawer: Drawer(child: DrawerPage()),
          floatingActionButton: FABPersonal(
            onPressed: () {},
          ),
          body: StreamBuilder(
            stream: ChatService.shared.getCanales().onValue,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:

                case ConnectionState.done:
                  if (snapshot.hasData) {
                    Map<dynamic, dynamic> canales =
                        snapshot.data.snapshot.value;

                    canales.forEach((llave, valor) {
                      Map<String, dynamic> data =
                          json.decode(json.encode(valor));
                      CanalModel canal = CanalModel.fromJson(data);
                      canal.key = llave;

                      if (canalesLista
                          .where((element) => element.key == llave)
                          .isEmpty) {
                        canalesLista.add(
                          CanalModel(
                            key: llave,
                            name: data["nombre"],
                            descripcion: data["descripcion"],
                          ),
                        );
                      }
                      //print("LA DATA ES:   $llave");

                      //print("EL NOMBRE DE CANAL ES: " + data["nombre"]);
                    });

                    print("SI HAY INFORMACIÓN");
                    return buildChats();
                  } else {
                    print("NO HAY INFORMACIÓN");
                  }

                  return const Center(child: CircularProgressIndicator());

                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }

  Widget buildChats() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: canalesLista.length,
        itemBuilder: (context, index) {
          final canal = canalesLista[index];

          if (canalesLista.isNotEmpty) {
            return Channel(
              titulo: canal.name!,
              descripcion: canal.descripcion!,
              onTap: () {
                ChatService.shared.buscarMisCanales(user!.uid);
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
