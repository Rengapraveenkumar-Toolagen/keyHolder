import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

Widget userAvatar(bool statusOfUserAvatar, bool isDrawer) {
  return Container(
    padding: const EdgeInsets.all(3.0),
    height: isDrawer ? 95.0 : 58.0,
    width: isDrawer ? 95.0 : 58.0,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100.0),
      gradient: dartBlueToLightBlueVector,
    ),
    child: Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage(Assets.account),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 16.0,
            width: 16.0,
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: whiteBorderColor,
            ),
            child: Container(
              height: 12.0,
              width: 12.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color:
                    statusOfUserAvatar ? greenStatusColor : yellowStatusColor,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
