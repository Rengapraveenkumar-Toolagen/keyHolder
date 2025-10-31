import 'package:flutter/material.dart';

import '../../../utils/assets.dart';

Widget userAvatarNoStatus() {
  return const Stack(
    clipBehavior: Clip.none,
    fit: StackFit.expand,
    children: [
      CircleAvatar(
        backgroundImage: AssetImage(Assets.account),
      ),
    ],
  );
}
