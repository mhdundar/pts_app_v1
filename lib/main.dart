import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pts_app_v1/screens/company/company_create_screen.dart';
import 'package:pts_app_v1/screens/company/company_list_screen.dart';
import 'package:pts_app_v1/screens/login/login_screen.dart';
import 'package:pts_app_v1/screens/main/main_shell.dart';
import 'package:pts_app_v1/services/auth_service.dart';
import 'package:pts_app_v1/utils/secure_storage.dart';
import 'package:pts_app_v1/utils/jwt_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthService.setupInterceptors();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isLoggedIn() async {
    final rememberMe = await SecureStorage.readRememberMe();
    final accessToken = await SecureStorage.readAccessToken();
    final refreshToken = await SecureStorage.readRefreshToken();

    // Eğer kullanıcı "Beni Hatırla" dediyse
    if (rememberMe) {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final success = await AuthService.refreshToken();
        if (success) {
          AuthService.accessTokenTemp =
              await SecureStorage.readAccessToken(); // yeni tokenı aktar
          return true;
        }
      }
      return false;
    }

    // Eğer "Beni Hatırla" seçilmediyse sadece access token kontrol edilir
    if (accessToken != null && accessToken.isNotEmpty) {
      final isExpired = JwtHelper.isExpired(accessToken);
      if (!isExpired) {
        AuthService.accessTokenTemp = accessToken;
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'PTS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1C1E),
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.blueAccent,
          secondary: Colors.blue,
        ),
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const MainShell(),
        '/orders': (context) => const MainShell(),
        '/company': (context) => const MainShell(),
        '/users': (context) => const MainShell(),
        '/company/list': (_) => const CompanyListScreen(),
        '/company/create': (_) => const CompanyCreateScreen(),
      },
      home: FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            return const ErrorScreen();
          }

          final isLoggedIn = snapshot.data ?? false;
          return isLoggedIn ? const MainShell() : const LoginScreen();
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1C1C1E),
      body: Center(
        child: Text(
          "Bir hata oluştu",
          style: TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
