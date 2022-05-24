import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/localization/localizations.dart';
import 'package:pre_proyecto_universales/main.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';

class UserInfo extends StatelessWidget {
  UsuarioModel user;
  UserInfo({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark =
        (MediaQuery.of(context).platformBrightness == Brightness.light &&
                MyApp.themeNotifier.value == ThemeMode.dark) ||
            ((MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.system) ||
                (MediaQuery.of(context).platformBrightness == Brightness.dark &&
                    MyApp.themeNotifier.value == ThemeMode.dark));

    AppLocalizations localizations =
        Localizations.of<AppLocalizations>(context, AppLocalizations)!;

    final userPhoto = Container(
      width: 90.0,
      height: 90.0,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.tealAccent, width: 2.0, style: BorderStyle.solid),
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover, //image: AssetImage(user.fotoURL)
            image: user.photoURL != null
                ? NetworkImage(user.photoURL!)
                : const NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ce/Oxygen480-places-user-identity.svg/1200px-Oxygen480-places-user-identity.svg.png'),
          )),
    );

    final userInfo = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: user.name != null
                  ? Text(
                      user.name!,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'Lato',
                      ),
                    )
                  : const Text(''),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: user.email != null
                  ? Text(
                      user.email!,
                      style: TextStyle(
                        fontSize: 15.0,
                        color: isDark ? Colors.white : Colors.black,
                        fontFamily: 'Lato',
                      ),
                    )
                  : const Text(''),
            ),
          ],
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          userPhoto,
          const SizedBox(
            height: 15,
          ),
          userInfo
        ],
      ),
    );
  }
}
