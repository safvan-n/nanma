import '../../models/user_model.dart';
import '../core/services/mock_data_service.dart';

class AuthRepository {
  UserModel? _currentUser;
  bool _isAuthenticated = true; // Set to true by default for rich prototype testing

  AuthRepository() {
    _currentUser = MockDataService.defaultCustomer;
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simulated SMS gateway
  }

  Future<UserModel> verifyOtpAndLogin({
    required String phoneNumber,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp == '123456' || otp.length == 6) {
      _currentUser = MockDataService.defaultCustomer.copyWith(phoneNumber: phoneNumber);
      _isAuthenticated = true;
      return _currentUser!;
    }
    throw Exception('Invalid verification code. Please enter 123456');
  }

  Future<UserModel> registerUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 900));
    _currentUser = user;
    _isAuthenticated = true;
    return _currentUser!;
  }

  void switchRole(UserRole role) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(role: role);
    }
  }

  void toggleElderlyMode(bool enabled) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(isElderlyModeEnabled: enabled);
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _isAuthenticated = false;
    _currentUser = null;
  }
}
