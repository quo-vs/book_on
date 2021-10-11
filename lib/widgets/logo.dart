import 'package:flutter/material.dart';

import '../utils/constants.dart';

class LogoImage extends StatelessWidget {
  const LogoImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConst.imageLogoHeight,
      margin: const EdgeInsets.only(
        top: AppConst.heightBetweenWidgets,
        bottom: AppConst.heightBetweenWidgets,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.0),
        child: const Image(
          image: AssetImage('assets/images/logo_new.png'),
          width: AppConst.imageLogoWidth,
        ),
      ),
    );
  }
}
