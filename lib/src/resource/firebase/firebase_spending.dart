import 'package:app_spending/src/resource/model/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreSpending {
  static Future<void> createSpendingFirebase(SpendingModel todo) async {
    final doc = FirebaseFirestore.instance.collection('spending_AppSpending');
    await doc.add({
      'idUser': todo.idUser,
    }).then((value) => FirebaseFirestore.instance.collection('spending_AppSpending').doc(value.id)
      .set({
        'idUser': todo.idUser,
        'dateTime': todo.dateTime,
        'idSpending': value.id,
        'note': todo.note,
        'moneySpending': todo.moneySpending,
        'moneyIncome': todo.moneyIncome
      })
    );
  }

  static Future<void> removeTodoFirebase(String id) async{
    final bodyIndex= FirebaseFirestore.instance.collection('spending_AppSpending');
    await bodyIndex.doc(id).delete();
  }

  static Future<void> removeAllTodoFirebase(String id) async{
    final bodyIndex= FirebaseFirestore.instance.collection('spending_AppSpending');
    final userSnapshot= await bodyIndex.where('idUser', isEqualTo: id).get();
    for (DocumentSnapshot doc in userSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<void> updateTodoFirebase(SpendingModel todo)async{
     await FirebaseFirestore.instance.collection('spending_AppSpending')
        .doc(todo.idSpending)
        .update(
          todo.toJson()
        );
  }
}
