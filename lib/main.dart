import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/auth/login_view.dart';
import 'views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // NOTE: Firebase initialization commented out because flutterfire configure
  // has not generated the firebase_options.dart file yet.
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */
  
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