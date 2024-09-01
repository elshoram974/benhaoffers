import 'package:eClassify/Utils/Login/lib/login_status.dart';
import 'package:eClassify/Utils/api.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:eClassify/Utils/Login/lib/login_system.dart';
import 'package:eClassify/Utils/Login/lib/payloads.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../cloudState/cloud_state.dart';

class EmailLogin extends LoginSystem {
  @override
  Future<UserCredential?> login() async {
    UserCredential? userCredential;
    if (payload is EmailLoginPayload) {
      var payloadData = (payload as EmailLoginPayload);

      try {
        if (payloadData.type == EmailLoginType.signup) {
          userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: payloadData.email,
            password: payloadData.password,
          );
          String? token = await FirebaseMessaging.instance.getToken();

          final Map<String, String> parameters = {
            Api.firebaseId: userCredential.user!.uid
          };
          parameters.addAll(CloudState.cloudData['signup_details']);

          if(token != null) parameters[Api.fcmId] = token;

          await Api.post(
            url: Api.loginApi,
            parameter: parameters,
          );
          emit(MSuccess());
        } else {
          userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: payloadData.email,
            password: payloadData.password,
          );
        }
      } catch (e) {
        emit(MFail(e));
      }
    }
    return userCredential;
  }

  @override
  void onEvent(MLoginState state) {}
}
