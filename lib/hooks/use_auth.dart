// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fquery/fquery.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/models/user.dart';

class UseAuthResult {
  User? currentUser;
  bool isAuthVerifying;
  Function logout;
  UseAuthResult({
    this.currentUser,
    required this.isAuthVerifying,
    required this.logout,
  });
}

UseAuthResult useAuth() {
  User _decodeUserFromToken(String token) {
    final decoded = JwtDecoder.decode(token);
    return User.fromMap(decoded);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<User?> verifyAndGetUser() async {
    // No token found ~ Unauthenticated
    final token = await getToken();
    if (token == null) {
      return null;
    }

    try {
      // Parse token from user
      return _decodeUserFromToken(token);
    } catch (error) {
      // Malformed token ~ unauthenticated
      return null;
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  final query = useQuery<User?, Error>(
    ['currentUser'],
    verifyAndGetUser,
  );

  return UseAuthResult(
    isAuthVerifying: query.isLoading,
    currentUser: query.data,
    logout: logout,
  );
}
