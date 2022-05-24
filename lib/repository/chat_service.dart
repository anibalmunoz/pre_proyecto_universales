import 'package:firebase_database/firebase_database.dart';
import 'package:pre_proyecto_universales/models/channel_model.dart';

class ChatService {
  ChatService._privateConstructor();
  static final ChatService shared = ChatService._privateConstructor();

  DatabaseReference databaseReference = FirebaseDatabase.instance.ref("modo");

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

  Future<List<CanalModel>> buscarCanales() async {
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
              description: mapa["descripcion"],
            ),
          );
        }
      } else {
        print('No data available.');
      }
      return misCanales;
    } catch (e) {
      return misCanales;
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
}
