import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:pre_proyecto_universales/util/app_string.dart';

class People extends StatefulWidget {
  UsuarioModel usuario;
  CanalModel canal;
  VoidCallback? onTap;
  bool agregado;

  People({
    Key? key,
    required this.usuario,
    this.onTap,
    required this.canal,
    required this.agregado,
  }) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  bool seleccionado = false;

  @override
  Widget build(BuildContext context) {
    bool esMiCanal = (widget.canal.creador == Home.user!.uid);

    return InkWell(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 75,
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: widget.usuario.photoURL! != ""
                    ? NetworkImage(widget.usuario.photoURL!)
                    : const NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNL_ZnOTpXSvhf1UaK7beHey2BX42U6solRA&usqp=CAU"),
              ),
              title: Text(widget.usuario.name!),
              subtitle: Text(widget.usuario.email!),
              trailing: esMiCanal
                  ? IconButton(
                      icon: widget.agregado
                          ? const Icon(Icons.delete)
                          : const Icon(Icons.group_add_rounded),
                      onPressed: () async {
                        if (widget.agregado) {
                          openDialogEliminar(context, widget.canal.key!,
                              widget.canal.name!, widget.usuario);
                        } else {
                          openDialogAgregar(context, widget.canal.key!,
                              widget.canal.name!, widget.usuario);
                        }
                      },
                    )
                  : null,
            ),
          )
        ],
      ),
    );
  }

  Future openDialogEliminar(
      context, String canalKey, String canalNme, UsuarioModel usuario) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Eliminar"),
        content:
            Text("¿Quieres Eliminar a ${usuario.name} del canal $canalNme?"),
        actions: [
          TextButton(
            child: Text(
              localizations.dictionary(Strings.botonCancelar),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              localizations.dictionary(Strings.aceptar),
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              await ChatService.shared.deleteUserToChannel(
                  widget.canal.key!, widget.canal.name!, widget.usuario);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future openDialogAgregar(
      context, String canalKey, String canalNme, UsuarioModel usuario) {
    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Agregar"),
        content: Text("¿Quieres Agregar a ${usuario.name} al canal $canalNme?"),
        actions: [
          TextButton(
            child: Text(
              localizations.dictionary(Strings.botonCancelar),
              style: const TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              localizations.dictionary(Strings.aceptar),
            ),
            onPressed: () async {
              await ChatService.shared.addUserToChanel(
                  widget.canal.key!, widget.canal.name!, widget.usuario);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
