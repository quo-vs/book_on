import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import '../data/shared_prefs.dart';
import '../providers/app_provider.dart';
import '../config/theme.dart';
import 'screens/goals/add_goal_screen.dart';
import 'screens/quotes/edit_quotes.dart';
import 'screens/books/edit_book.dart';
import '../screens/page_controller_screen.dart';
import 'screens/quotes/quote_share_screen.dart';
import 'screens/books/all_books_screen.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/loading/loading_cubit.dart';
import '../screens/launcher_screen.dart';

import '../screens/settings_streen.dart';

import 'data/database.dart';

late SPSettings sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();

  sharedPrefs = SPSettings();
  await sharedPrefs.init();

  final db = AppDatabase();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('uk')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => AuthenticationBloc()),
          RepositoryProvider(create: (_) => LoadingCubit()),
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
  );
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return MaterialApp(
          home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 25,
              ),
              const SizedBox(height: 16),
              Text(
                tr('failedToInitialiseServer!'),
                style: const TextStyle(color: Colors.red, fontSize: 25),
              ),
            ],
          )),
        ),
      ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return MaterialApp(
        title: 'BookOn',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: Locale(appProvider.language),
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        darkTheme: ThemeConfig.darkTheme,
        themeMode: appProvider.mode,
        home: const LauncherScreen(),
        routes: {
          PageControllerScreen.routeName: (ctx) => const PageControllerScreen(),
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
