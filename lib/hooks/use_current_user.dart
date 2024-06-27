import 'package:fquery/fquery.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thatsapp/models/user.dart';

User? useCurrentUser() {
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

  final query = useQuery<User?, Error>(
    ['currentUser'],
    verifyAndGetUser,
  );
  return query.data;
}
