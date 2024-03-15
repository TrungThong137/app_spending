
import 'package:app_spending/src/resource/firebase/firebase_spending.dart';
import 'package:app_spending/src/resource/firebase/firebase_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/shared_preferences.dart';
import '../model/model.dart';

class Authentication {
  void signUp(
    String email,
    String password,
    String fullName,
    Function onSuccess,
    Function(String) onError,
  ) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        final check = await FireStoreUser.createUser(Users(
          idUser: user.user!.uid,
          fullName: fullName,
          emailAddress: email,
          dateCreate: DateTime.now().toString(),
        ));
        if (check == true) {
          onSuccess();
        } else {
          onError('loi');
        }
      });
    } on FirebaseAuthException catch (e) {
      onError('SignIn fail, please try again');
      if (e.code == 'weak-password') {
        onError('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        onError('The account already exists for that email.');
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  void signIn(String email, String password, Function onSuccess, Function(String) onError)async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
      ).then((user)async{
        user.user?.getIdToken().then((idToken) async {
          await AppPref.setToken(idToken!);
          await AppPref.setDataUser('id', user.user!.uid);
        });
        onSuccess();
      });
    } on FirebaseAuthException catch (e) {
      onError('SignIn fail, please try again');
      if (e.code == 'user-not-found') {
        onError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        onError('Wrong password provided for that user.');
      }
    }catch(e){
      onError(e.toString());
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final userRecords =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return userRecords.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteAccountUSer() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.delete();
      final id= user.uid;
      await FireStoreUser.removeUser(id.toString());
      await FireStoreSpending.removeAllTodoFirebase(id.toString());
      await signOut();
    }
  }
}
