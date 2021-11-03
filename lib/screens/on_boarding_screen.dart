import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../blocs/onBoarding/on_boarding_cubit.dart';
import '../blocs/onBoarding/on_boarding_state.dart';
import '../screens/welcome_screen.dart';

import '../main.dart';
import '../utils/helper.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<String> _titleList = ['BookOn', 'Books traker'];

  final List<String> _subtitleList = [
    'Welcome to BookOn World!',
    'Track your books'
  ];

  final List<dynamic> _imageList = [
    'assets/images/logo_new.png',
    Icons.track_changes,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnBoardingCubit, OnBoardingInitial>(
          builder: (context, state) {
            return Stack(
              children: [
                PageView.builder(
                  itemBuilder: (context, index) => getPage(_imageList[index],
                      _titleList[index], _subtitleList[index], context),
                  controller: pageController,
                  itemCount: _titleList.length,
                  onPageChanged: (int index) {
                    context.read<OnBoardingCubit>().onPageChanged(index);
                  },
                ),
                Visibility(
                  visible: state.currentPageCount + 1 == _titleList.length,
                  child: Align(
                    alignment: Directionality.of(context) == TextDirection.LTR
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    child:
                        BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        if (state.authState == AuthState.unauthenticated) {
                          Helper.pushAndRemoveUntil(
                              context, const WelcomeScreen(), false);
                        }
                      },
                      child: OutlineButton(
                        onPressed: () {
                          context
                              .read<AuthenticationBloc>()
                              .add(FinishedOnBoardingEvent());
                        },
                        child: const Text('Continue'),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: _titleList.length,
                        effect: const ScrollingDotsEffect(
                            //activeDotColor: Colors.white,
                            //dotColor: Colors.grey.shade400,
                            dotWidth: 8,
                            dotHeight: 8,
                            fixedCenter: true),
                      )),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget getPage(
      dynamic image, String title, String subTitle, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image is String
            ? Image.asset(
                image,
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              )
            : Icon(
                image as IconData,
                color: Colors.white,
                size: 150,
              ),
        const SizedBox(height: 40),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            subTitle,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Future<bool> setFinishedOnBoarding() async {
    return await sharedPrefs.setOnBoardingFinished(true);
  }
}
