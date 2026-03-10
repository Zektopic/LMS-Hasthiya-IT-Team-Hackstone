import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/auth/login_view.dart';
import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization would normally go here
  // await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const HasthiyaLMS(),
    ),
  );
}

class HasthiyaLMS extends StatelessWidget {
  const HasthiyaLMS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasthiya LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}