import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/blocs.dart';
import '../blocs/signup/signup_bloc.dart';
import '../data/shared_prefs.dart';
import '../providers/app_provider.dart';
import 'services/auth_service.dart';
import '../config/theme.dart';
import '../screens/add_goal_screen.dart';
import '../screens/edit_quotes.dart';
import '../screens/edit_book.dart';
import '../screens/login_screen.dart';
import '../screens/page_controller_screen.dart';
import '../screens/quote_share_screen.dart';
import '../screens/all_books_screen.dart';

import '../screens/settings_streen.dart';

import 'data/database.dart';

late SPSettings sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  sharedPrefs = SPSettings();
  await sharedPrefs.init();

  final db = AppDatabase();

  runApp(EasyLocalization(
    supportedLocales: const [Locale('en'), Locale('uk')],
    path: 'assets/translations',
    fallbackLocale: const Locale('en'),
    child: RepositoryProvider<AuthService>(
      create: (context) {
        return AuthService();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) {
              final authRepo = RepositoryProvider.of<AuthService>(context);
              return AuthBloc(authRepo)..add(AppStarted());
            },
          ),
          BlocProvider<LoginBloc>(
            create: (context) {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              final authRepo = RepositoryProvider.of<AuthService>(context);
              return LoginBloc(authBloc, authRepo);
            },
          ),
          BlocProvider<SignupBloc>(
            create: (context) {
              final authBloc = BlocProvider.of<AuthBloc>(context);
              final authRepo = RepositoryProvider.of<AuthService>(context);
              return SignupBloc(authBloc, authRepo);
            },
          ),
        ],
        child: MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => AppProvider()),
          Provider(create: (_) => db.booksDao),
          Provider(create: (_) => db.bookLogsDao),
          Provider(create: (_) => db.goalsDao),
          Provider(create: (_) => db.quotesDao),
        ], child: App()),
      ),
    ),
  ));
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return MaterialApp(
        title: tr('title'),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: Locale(appProvider.language),
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: appProvider.mode,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            if (state is AuthInitial || state is AuthLoading) {
              return Scaffold(body: Center(child: CircularProgressIndicator(),));
            }

            if (state is AuthAuthenticated) {
              return PageControllerScreen();
            }

            if (state is AuthNotAuthenticated) {
              return LoginScreen();
            }

             return Scaffold(body:Center(child: CircularProgressIndicator(),));
          },
        ),
        routes: {
          SettingsScreen.routeName: (ctx) => const SettingsScreen(),
          EditBookScreen.routeName: (ctx) => const EditBookScreen(),
          AddGoalScreen.routeName: (ctx) => const AddGoalScreen(),
          EditQuoteScreen.routeName: (ctx) => const EditQuoteScreen(),
          QuoteShareScreen.routeName: (ctx) => const QuoteShareScreen(),
          AllBooksScreen.routeName: (ctx) => const AllBooksScreen(),
        },
      );
    });
  }
}
