import 'package:firebase_database/firebase_database.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/create_group/users_to_add.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/pages/sign_up_page/sign_up.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  ChatService._privateConstructor();
  static final ChatService shared = ChatService._privateConstructor();

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  DatabaseReference getCanales() {
    return FirebaseDatabase.instance.ref("Canales");
  }

  DatabaseReference getUsuarios() {
    return FirebaseDatabase.instance.ref("Usuarios");
  }

  DatabaseReference getMisCanales(String uid) {
    return FirebaseDatabase.instance.ref("Canales/$uid");
  }

  DatabaseReference getMensajes(String key) {
    return FirebaseDatabase.instance.ref("Canales/$key/mensajes");
  }

  getMiCanales(String uid) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child("Usuarios/$uid/Canales").get();
    Home.misCanales = [];
    for (var item in snapshot.children) {
      dynamic mapa = item.value;
      Home.misCanales!.add(CanalModel(key: mapa));
    }
  }

  getMisUsuarios(String uid, String keyCanal) async {
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child("Usuarios/$uid/Canales").get();
    UsersToAdd.usuariosDeEsteCanal = [];
    for (var item in snapshot.children) {
      dynamic mapa = item.value;
      print("Lo que viene en el mapa es: $mapa");
      if (mapa == keyCanal) {
        print("ESTE USUARIO YA ESTÁ EN EL CANAL");
        UsersToAdd.usuariosDeEsteCanal!.add(UsuarioModel(uid: mapa));
      }
    }
  }

  Future actualizarMensaje(String texto, String idUsuario, String keyCanal,
      String idMensaje, DateTime fechaEnvio) async {
    final messageData = {
      'texto': texto,
      'usuario': idUsuario,
      'type': "text",
      'fecha_envio': fechaEnvio.millisecondsSinceEpoch,
    };

    await FirebaseDatabase.instance
        .ref()
        .child("Canales")
        .child(keyCanal)
        .child("mensajes")
        .child(idMensaje)
        .update(messageData);
  }

  Future eliminarMensaje(String keyCanal, String idMensaje) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Canales")
        .child(keyCanal)
        .child("mensajes")
        .child(idMensaje)
        .remove();
  }

  Future buscarUsuario(uid) async {
    String nombre = "Desconocido";
    String foto = "";
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child("Usuarios/$uid").get();
    //print(snapshot.value);
    for (var item in snapshot.children) {
      if (item.key == "nombre") {
        nombre = item.value.toString();
        //print(nombre);
      }
    }

    return nombre;
  }

  Future buscarUsuario2(uid) async {
    String nombre = "Desconocido";
    UsuarioModel usuario = UsuarioModel();
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child("Usuarios").get();
    //print(snapshot.value);
    for (var item in snapshot.children) {
      if (item.key == uid) {
        dynamic mapa = item.value;
        nombre = mapa["nombre"];
        usuario = UsuarioModel(
            uid: item.key, name: mapa["nombre"], photoURL: mapa["urlImage"]);
      }
    }
    return usuario;
  }

  Stream<List<CanalModel>> get buscarCanales async* {
    List<CanalModel> misCanales = [];
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Canales').get();
      if (snapshot.exists) {
        for (var item in snapshot.children) {
          dynamic mapa = item.value;
          misCanales.add(
            CanalModel(
              key: snapshot.key!,
              name: mapa["nombre"],
              descripcion: mapa["descripcion"],
            ),
          );
        }
      } else {
        print('No data available.');
      }
      yield misCanales;
    } catch (e) {
      yield misCanales;
    }
  }

  Future<List<CanalModel>> buscarMisCanales(String? uid) async {
    List<CanalModel> misCanales = [];
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Usuarios').get();
      if (snapshot.exists) {
        for (var item in snapshot.children) {
          dynamic mapa = item.value;
          for (var item in snapshot.children) {}
        }
      } else {
        print('No data available.');
      }
      return misCanales;
    } catch (e) {
      return misCanales;
    }
  }

  Future<void> crearORegistrarCanalGeneral(UsuarioModel usuario) async {
    bool create = await ChatService.shared
        .newChanel("General", "General", "Grupo general", usuario);
    if (create) {
      await ChatService.shared.newMessage(
          "General", "Bienvenido a la comunidad", usuario.uid!, "notification");
      await ChatService.shared.addUserToChanel("General", "General", usuario);
    } else {
      await ChatService.shared.addUserToChanel("General", "General", usuario);
    }
  }

  Future<bool> newChanel(String id, String chanelName, String description,
      UsuarioModel usuario) async {
    final chanel = databaseReference.child('Canales/$id');
    late bool response = false;
    await chanel.get().then((value) {
      if (value.value == null) {
        chanel.set({
          'nombre': chanelName,
          'descripcion': description,
          'fecha_creacion': DateTime.now().millisecondsSinceEpoch,
          'creador': usuario.uid,
          'administradores': {usuario.uid: usuario.uid},
          'usuarios': {usuario.uid: usuario.uid},
        });
        response = true;
      }
    });
    return response;
  }

  Future<String> addUserToChanel(
      String keyChannel, String nameChanel, UsuarioModel user) async {
    String message = "Usuario agregado al canal con exito";
    try {
      await addUser(user);
      await databaseReference
          .child("Canales")
          .child(keyChannel)
          .child('usuarios')
          .child(user.uid!)
          .set(user.uid);
      await databaseReference
          .child("Usuarios")
          .child(user.uid!)
          .child("Canales/$keyChannel")
          .set(keyChannel);
    } catch (e) {
      message = "Error al agregar el usuario al canal";
    }
    return message;
  }

  Future<String> addNewUserToChanel(
      String keyChannel, String nameChanel, UsuarioModel user) async {
    String message = "Usuario agregado al canal con exito";
    try {
      await databaseReference
          .child("Canales")
          .child(keyChannel)
          .child('usuarios')
          .child(user.uid!)
          .set(user.uid);
      await databaseReference
          .child("Usuarios")
          .child(user.uid!)
          .child("Canales/$keyChannel")
          .set(keyChannel);
    } catch (e) {
      message = "Error al agregar el usuario al canal";
    }
    return message;
  }

  Future deleteUserToChannel(
      String keyChannel, String nameChanel, UsuarioModel user) async {
    await databaseReference
        .child("Canales")
        .child(keyChannel)
        .child('usuarios')
        .child(user.uid!)
        .remove();

    await databaseReference
        .child("Usuarios")
        .child(user.uid!)
        .child("Canales")
        .child(keyChannel)
        .remove();
  }

  Future deleteChannelToUser(
      String keyChannel, String nameChanel, UsuarioModel user) async {
    await databaseReference
        .child("Usuarios")
        .child(user.uid!)
        .child("Canales")
        .child(keyChannel)
        .remove();
  }

  Future<String> addUser(UsuarioModel user) async {
    String message = "Usuario agregado con exito";
    try {
      final userF = databaseReference.child("Usuarios/${user.uid}");
      await userF.get().then((value) {
        if (value.value == null) {
          userF.set({
            'nombre': user.name == "" ? SignUp.nombre : user.name,
            'correo': user.email,
            'urlImage': '',
            'estado': true,
            'change': false,
          });
        }
      });
    } catch (e) {
      message = "Error al agregar el usuario";
    }
    return message;
  }

  Future<UsuarioModel> getUser(String id) async {
    final user = databaseReference.child('Usuarios/$id');
    late UsuarioModel retorno = UsuarioModel();
    await user.get().then((value) {
      if (value.value != null) {
        final data = Map<String, dynamic>.from(value.value as dynamic);
        retorno = UsuarioModel(
          uid: id,
          email: data['correo'],
          name: data['nombre'],
          photoURL: data['urlImage'],
          canales: Map<String, dynamic>.from(data['Canales'] as dynamic),
        );
      }
    });
    return retorno;
  }

  Future<void> newMessage(
      String chanel, String message, String userId, String type) async {
    Uuid uuid = const Uuid();
    final id = uuid.v4();
    final messageData = {
      'texto': message,
      'usuario': userId,
      'type': type,
      'fecha_envio': DateTime.now().millisecondsSinceEpoch,
    };
    await databaseReference
        .child("Canales")
        .child(chanel)
        .child('mensajes')
        .child(id)
        .set(messageData);
  }

  Future<void> crearNuevoGrupo(
      String nombreCanal, String descripcion, UsuarioModel usuario) async {
    Uuid uuid = const Uuid();
    final id = uuid.v4();

    bool create = await ChatService.shared
        .newChanel(id, nombreCanal, descripcion, usuario);
    if (create) {
      await ChatService.shared.newMessage(
          id, "Bienvenido a la comunidad", usuario.uid!, "notification");
      await ChatService.shared.addUserToChanel(id, nombreCanal, usuario);
    } else {
      await ChatService.shared.newMessage(
          id, "Bienvenido a la comunidad", usuario.uid!, "notification");
      await ChatService.shared.addUserToChanel(id, nombreCanal, usuario);
    }
  }

  Future<void> eliminarCanal(String keyCanal, String idUsuario) async {
    //await eliminarCanalDeMiUsuario(idUsuario, keyCanal);
    await FirebaseDatabase.instance
        .ref()
        .child("Canales")
        .child(keyCanal)
        .remove();
  }

  Future<void> eliminarCanalDeMiUsuario(
      String idUsuario, String keyCanal) async {
    await FirebaseDatabase.instance
        .ref()
        .child("Usuarios")
        .child(idUsuario)
        .child("Canales")
        .child(keyCanal)
        .remove();
  }
}
