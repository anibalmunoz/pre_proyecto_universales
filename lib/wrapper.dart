import 'package:flutter/material.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/pages/login_pages/login_form.dart';
import 'package:pre_proyecto_universales/repository/auth_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<Usuario?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<Usuario?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final Usuario? usuario = snapshot.data;
          return usuario == null ? LoginForm() : Home();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
