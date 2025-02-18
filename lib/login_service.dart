import 'package:shared_preferences/shared_preferences.dart';  
  
class LoginService {  
  static const String _isLoggedInKey = 'isLoggedIn';  
  
  // Method to check if the user is logged in  
  Future<bool> isLoggedIn() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    return prefs.getBool(_isLoggedInKey) ?? false;  
  }  
  
  // Method to set the login status to true  
  Future<void> login() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.setBool(_isLoggedInKey, true);  
  }  
  
  // Method to set the login status to false  
  Future<void> logout() async {  
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    await prefs.setBool(_isLoggedInKey, false);  
  }  
}  
