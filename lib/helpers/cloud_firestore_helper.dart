import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();

  static final CloudFirestoreHelper cloudFireStoreHelper =
      CloudFirestoreHelper._();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  int todo_id = 0;

  Future<void> getTodoID() async {
    CollectionReference counterID = firebaseFirestore.collection("id_counter");
    DocumentSnapshot authorDocument = await counterID.doc("todo_id").get();
    todo_id = authorDocument.get("id");
    print("object ==> $todo_id");
  }

  Future updateTodoID({required int id}) async {
    CollectionReference counterID = firebaseFirestore.collection("id_counter");
    await counterID.doc("todo_id").update({'id': id});
  }
  
  
  Future addTODO({required String title, required String description}) async {

    await getTodoID();

    Map<String, dynamic> data = {
      'todo_id' : todo_id,
      'todo_title' : title,
      'todo_description' : description
    };
    firebaseFirestore.collection("TODO").doc("todo_$todo_id").set(data).then((value) {
      updateTodoID(id: ++todo_id);
    });
    
  }

  Future deleteTODO({required int id}) async {

    firebaseFirestore.collection("TODO").doc("todo_$id").delete().then((value) {
      updateTodoID(id: --todo_id);
    });
  }

}
