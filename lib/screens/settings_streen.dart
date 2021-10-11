import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import '../blocs/auth/auth.dart';
import '../providers/app_provider.dart';
import '../utils/constants.dart';
import '../screens/login_screen.dart';
import '../utils/functions.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List _items;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    _items = [
      {
        'icon': Icons.dark_mode,
        'title': tr('darkMode'),
        'function': () => () {},
      },
      {
        'icon': Icons.map,
        'title': tr('changeLanguage'),
        'function': () => () {},
      },
      {
        'icon': Icons.info,
        'title': tr('about'),
        'function': () => showAbout(),
      },
      {
        'icon': Icons.logout,
        'title': tr('logout'),
        'function': () => _logout(),
      },
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              centerTitle: true,
              title: Text(tr('settings')),
            ),
      body: _isLoading
          ? const CircularProgressIndicator()
          : Container(
            padding: const EdgeInsets.only(top: AppConst.heightBetweenWidgets),
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  if (_items[index]['title'] == tr('darkMode')) {
                    return _buildThemeSwitch(_items[index]);
                  }

                  if (_items[index]['title'] == tr('changeLanguage')) {
                    return _buildLanguageDropdown(
                        context, tr('changeLanguage'), _items[index]['icon']);
                  }

                  return ListTile(
                    onTap: _items[index]['function'],
                    leading: Icon(_items[index]['icon']),
                    title: Text(_items[index]['title']),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider();
                },
                itemCount: _items.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
          ),
    );
  }

  _logout() {
    BlocProvider.of<AuthBloc>(context).add(LoggedOut());
    Functions.pushPageReplacement(context, const LoginScreen());
  }

  Widget _buildThemeSwitch(Map item) {
    return SwitchListTile(
      secondary: Icon(
        item['icon'],
      ),
      title: Text(
        item['title'],
      ),
      value: Provider.of<AppProvider>(context).mode == ThemeMode.light
          ? false
          : true,
      onChanged: (v) {
        if (v) {
          Provider.of<AppProvider>(context, listen: false).setTheme('dark');
        } else {
          Provider.of<AppProvider>(context, listen: false).setTheme('light');
        }
      },
    );
  }

  Widget _buildLanguageDropdown(
      BuildContext context, String title, IconData iconData) {
    return ListTile(
      leading: Icon(iconData),
      title: Text(title),
      trailing: DropdownButton(
        underline: Container(),
        icon: const Icon(
          Icons.more_vert,
        ),
        items: [
          ...context.supportedLocales.map((locale) {
            return DropdownMenuItem(
              child: Text(language(locale.toString())),
              value: locale.languageCode,
            );
          }).toList()
        ],
        onChanged: (String? value) async {
          if (value != null) {
            setState(() {
              _isLoading = true;
            });

            await Provider.of<AppProvider>(context, listen: false)
                .setLanguage(context, value);
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }

  String language(String locale) {
    switch(locale) {
      case "uk": {
        return tr('ukrainian');
      }
      case "en": {
        return tr('english');
      }
      default:
        return tr('english');
    }
  }

  showAbout() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            tr('about'),
          ),
          content: Text(
            tr('aboutApp'),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.pop(context),
              child: Text(
                tr('close'),
              ),
            ),
          ],
        );
      },
    );
  }
}
