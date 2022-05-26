import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/pages/sign_up_page/sign_up.dart';
import 'package:pre_proyecto_universales/widgets/widget_message.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  ChatService._privateConstructor();
  static final ChatService shared = ChatService._privateConstructor();

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  // Future guardar() async {
  //   await databaseReference.set({"modo": "ThemeMode.light"});

  //   DatabaseReference starCountRef = FirebaseDatabase.instance.ref('modo');
  //   starCountRef.onValue.listen(
  //     (DatabaseEvent event) {
  //       final data = event.snapshot.value;
  //       print("LA DATA OBTENIDA ES: ${data}");
  //     },
  //   );
  // }

  DatabaseReference getCanales() {
    return FirebaseDatabase.instance.ref("Canales");
  }

  DatabaseReference getMisCanales(String uid) {
    return FirebaseDatabase.instance.ref("Canales/$uid");
  }

  DatabaseReference getMensajes(String key) {
    return FirebaseDatabase.instance.ref("Canales/$key/mensajes");
  }

  getMiCanales(String uid) async {
    //Home.misCanales = [];
    var ref = FirebaseDatabase.instance.ref();
    var snapshot = await ref.child("Usuarios/$uid/Canales").get();
    for (var item in snapshot.children) {
      dynamic mapa = item.value;

      if (Home.misCanales!.isEmpty) {
        Home.misCanales!.add(CanalModel(key: mapa));
      } else {
        Home.misCanales!.forEach((element) {
          if (element.key != mapa) {
            Home.misCanales!.add(CanalModel(key: mapa));
          }
        });
      }
    }
  }

  Future buscarUsuario(uid) async {
    String nombre = "Desconocido";
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

    // DatabaseReference ref = FirebaseDatabase.instance.ref().child("Canales").get();
    // ref.onValue.listen(
    //   (DatabaseEvent event) {
    //     final data = event.snapshot.value;
    //     print("LA DATA OBTENIDA ES: ${data}");

    //Map<String, dynamic> canales = data as Map<String, dynamic>;

    //final body = json.encode(canales);
    //print(body);
    //for (var item in data) {}
    //   },
    // );
    // List<CanalModel> canalesPrueba = [CanalModel(id: "1", name: "prueba")];

    // return canalesPrueba;
  }

  Future<List<CanalModel>> buscarMisCanales(String? uid) async {
    List<CanalModel> misCanales = [];
    try {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('Usuarios').get();
      if (snapshot.exists) {
        for (var item in snapshot.children) {
          //print(item.value);
          dynamic mapa = item.value;
          // misCanales.add(
          //   CanalModel(
          //     key: snapshot.key!,
          //     name: mapa["nombre"],
          //     descripcion: mapa["descripcion"],
          //   ),
          // );

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
          'fecha_creación': DateTime.now().millisecondsSinceEpoch,
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
      String chanel, String nameChanel, UsuarioModel user) async {
    String message = "Usuario agregado al canal con exito";
    try {
      await addUser(user);
      await databaseReference
          .child("Canales")
          .child(chanel)
          .child('usuarios')
          .child(user.uid!)
          .set(user.uid);
      await databaseReference
          .child("Usuarios")
          .child(user.uid!)
          .child("Canales/$chanel")
          .set(nameChanel);
    } catch (e) {
      message = "Error al agregar el usuario al canal";
    }
    return message;
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
          //change: data['change'],
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
}
