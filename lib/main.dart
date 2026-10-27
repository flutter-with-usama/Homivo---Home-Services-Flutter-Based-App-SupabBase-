import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/supabase_constants.dart';
import 'core/services/local_cache_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/counter_repository_impl.dart';
import 'data/repositories/onboarding_repository_impl.dart';
import 'viewmodels/counter_viewmodel.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/login_viewmodel.dart';
import 'viewmodels/onboarding_viewmodel.dart';
import 'viewmodels/provider_dashboard_viewmodel.dart';
import 'views/screens/client_main_screen.dart';
import 'views/screens/login_screen.dart';
import 'views/screens/onboarding_screen.dart';
import 'views/screens/role_selection_screen.dart';
import 'views/screens/provider_dashboard_screen.dart';
import 'features_provider/home/provider_main_screen.dart';
import 'views/screens/forgot_password_screen.dart';
import 'views/screens/admin_providers_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConstants.url,
    anonKey: SupabaseConstants.anonKey,
  );
  await LocalCacheService.instance.initialize();

  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(
    MyApp(
      initialRoute: LocalCacheService.instance.onboardingCompleted
          ? '/login'
          : '/',
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterViewModel>(
          create: (_) => CounterViewModel(CounterRepositoryImpl()),
        ),
        ChangeNotifierProvider<OnboardingViewModel>(
          create: (_) => OnboardingViewModel(OnboardingRepositoryImpl()),
        ),
        // LoginViewModel is global — shared by LoginScreen
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
        // RegisterViewModel is NOT global — created locally in RegisterScreen
        // with the chosen role injected. Removed from here.
        ChangeNotifierProvider<HomeViewModel>(create: (_) => HomeViewModel()),
        ChangeNotifierProvider<ProviderDashboardViewModel>(
          create: (_) => ProviderDashboardViewModel(),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: initialRoute,
        routes: {
          '/': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          // /register is gone — RegisterScreen is pushed with a role argument
          // via RoleSelectionScreen using Navigator.push (not named route)
          '/role-select': (_) => const RoleSelectionScreen(),
          '/home': (_) => const ClientMainScreen(),
          '/provider': (_) => const ProviderDashboardScreen(),
          '/provider-home': (_) => const ProviderMainScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/admin': (_) => const AdminProvidersScreen(),
        },
      ),
    );
  }
}
