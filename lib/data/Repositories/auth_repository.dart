import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/api.dart';
import '../../utils/constant.dart';
import '../cubits/auth/authentication_cubit.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int? forceResendingToken;

  Future<Map<String, dynamic>> signUpWithApi({
    String? phone,
    required String uid,
    required String type,
    String? fcmId,
    required String email,
    required String name,
    String? profile,
    String? countryCode,
  }) async {
    Map<String, String> parameters = {
      if (phone != null) Api.mobile: phone,
      Api.firebaseId: uid,
      Api.type: type,
      if (fcmId != null) Api.fcmId: fcmId,
      Api.email: email,
      Api.name: name,
      if (countryCode != null) Api.countryCode: countryCode,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.loginApi,
      parameter: parameters, /* useAuthToken: false*/
    );

    return {"token": response['token'], "data": response['data']};
  }

  Future<Map<String, dynamic>>? loginEmailPhone({
    required String email,
    required String password,
    required AuthenticationType type,
    String? fcmId,
    String? countryCode,
  }) async {
    Map<String, String> parameters = {
      Api.type: type.name,
      Api.password: password,
      if (fcmId != null) Api.fcmId: fcmId,
      if (countryCode != null) Api.countryCode: countryCode,
    };
    if (AuthenticationType.phone == type) {
      parameters[Api.mobile] = email;
    } else {
      parameters[Api.email] = email;
    }

    Map<String, dynamic> response = await Api.post(
      url: Api.loginApi,
      parameter: parameters,
    );

    return {"token": response['token'], "data": response['data']};
  }

  Future<Map<String, dynamic>>? requestToSendCode(String email) async {
    Map<String, String> parameters = {Api.email: email};
    Map<String, dynamic> response = await Api.post(
      url: Api.sendCode,
      parameter: parameters,
    );
    return {"token": response['token'], "data": response['data']};
  }

  Future<Map<String, dynamic>>? checkCode(String email, String code) async {
    Map<String, String> parameters = {Api.email: email, Api.code: code};
    Map<String, dynamic> response = await Api.post(
      url: Api.checkCode,
      parameter: parameters,
    );
    return {"token": response['token'], "data": response['data']};
  }
  
  Future<Map<String, dynamic>>? createNewPassword(String email, String password) async {
    Map<String, String> parameters = {Api.email: email, Api.password: password};
    Map<String, dynamic> response = await Api.post(
      url: Api.createNewPassword,
      parameter: parameters,
    );
    return {"token": response['token'], "data": response['data']};
  }

  Future<Map<String, dynamic>> numberLoginWithApi(
      {String? phone,
      required String uid,
      required String type,
      String? fcmId,
      String? email,
      String? name,
      String? profile,
      String? countryCode}) async {
    Map<String, String> parameters = {
      if (phone != null) Api.mobile: phone,
      Api.firebaseId: uid,
      Api.type: type,
      if (fcmId != null) Api.fcmId: fcmId,
      if (email != null) Api.email: email,
      if (name != null) Api.name: name,
      if (countryCode != null) Api.countryCode: countryCode,
      //if (profile != null) Api.profile: profile
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.loginApi,
      parameter: parameters, /* useAuthToken: false*/
    );

    return {"token": response['token'], "data": response['data']};
  }

  Future<dynamic> deleteUser() async {
    Map<String, dynamic> response = await Api.delete(
      url: Api.deleteUserApi,
    );

    return response;
  }

  loginEmailUser() async {}

  Future<void> sendOTP(
      {required String phoneNumber,
      required Function(String verificationId) onCodeSent,
      Function(dynamic e)? onError}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(
        seconds: Constant.otpTimeOutSecond,
      ),
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        onError?.call(ApiException(e.code));
      },
      codeSent: (String verificationId, int? resendToken) {
        forceResendingToken = resendToken;
        onCodeSent.call(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      forceResendingToken: forceResendingToken,
    );
  }

  Future<UserCredential> verifyOTP({
    required String otpVerificationId,
    required String otp,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId, smsCode: otp);
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    return userCredential;
  }
}

class MultiAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> createUserWithEmail(
      {required String email, required String password}) async {
    try {
      UserCredential credentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credentials;
    } catch (e) {
      rethrow;
    }
  }
}
