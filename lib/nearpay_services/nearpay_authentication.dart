
class AuthenticationData {
 
  static Map<String, dynamic> loginWithJWT(String jwt) {
    return {'authType': 'jwt', 'authValue': jwt};
  }

  static Map<String, dynamic> loginWithMobile(String mobileNumber) {
    return {'authType': 'mobile', 'authValue': mobileNumber};
  }

  static Map<String, dynamic> loginWithEmail(String email) {
    return {'authType': 'email', 'authValue': email};
  }

  static Map<String, dynamic> userEnter() {
    return {'authType': 'userEnter'};
  }
}
