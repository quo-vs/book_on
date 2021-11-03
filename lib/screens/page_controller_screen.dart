import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/books/books_screen.dart';
import '../screens/goals/goals_screen.dart';
import '../screens/quotes/quotes_screen.dart';
import '../screens/statistics/statistics_screen.dart';
import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_state.dart';
import '../screens/welcome_screen.dart';
import '../utils/helper.dart';

class PageControllerScreen extends StatefulWidget {
  static const routeName = '/home';

  final int? initialPage;

  const PageControllerScreen({Key? key, this.initialPage}) : super(key: key);

  @override
  State<PageControllerScreen> createState() => _PageControllerScreenState();
}

class _PageControllerScreenState extends State<PageControllerScreen> {
  int _page = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  _getPage(int page) {
    switch (page) {
      case 0:
        return const BooksScreen();
      case 1:
        return const QuotesSctreen();
      case 2:
        return const GoalsScreen();
      case 3:
        return const StatisticsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.authState == AuthState.unauthenticated) {
          Helper.pushAndRemoveUntil(context, const WelcomeScreen(), false);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
            child: _getPage(_page),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: _page,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              _page = position;
            });
          },
          tabs: [
            TabData(
              iconData: Icons.book,
              title: tr('books'),
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(0);
              },
            ),
            TabData(
              iconData: Icons.format_quote_sharp,
              title: tr('quotes'),
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(1);
              },
            ),
            TabData(
              iconData: Icons.emoji_objects,
              title: tr('goals'),
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(2);
              },
            ),
            TabData(
              iconData: Icons.data_usage_rounded,
              title: tr('stats'),
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage != null ? widget.initialPage! : 0;
  }
}
