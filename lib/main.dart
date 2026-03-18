import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/auth/login_view.dart';
import 'views/home/main_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI style for immersive dark theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.surfaceColor,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const HackstonLMS(),
    ),
  );
}

class HackstonLMS extends StatelessWidget {
  const HackstonLMS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackston LMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AuthViewModel>(
        builder: (context, auth, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: auth.isAuthenticated
                ? const MainShell(key: ValueKey('home'))
                : const LoginView(key: ValueKey('login')),
          );
        },
      ),
    );
  }
}
