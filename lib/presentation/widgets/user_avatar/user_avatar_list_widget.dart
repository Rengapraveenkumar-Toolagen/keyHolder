import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/colors/colors.dart';
import '../widgets.dart';

Widget userAvatarListWidget(List<String> users) {
  return users.length > 3
      ? Row(
          children: [
            Row(children: [
              for (int i = users.length - 3; i < users.length; i++)
                Align(
                    widthFactor: 0.5,
                    child: CircleAvatar(
                        radius: 14.r,
                        backgroundColor: white,
                        child: CircleAvatar(
                            radius: 12.r,
                            backgroundColor: getAvatarColor(i),
                            child: Text(getInitials(users[i]),
                                style: TextStyle(
                                    fontSize: 10.sp, color: white))))),
            ]),
            Align(
              widthFactor: 0.5,
              child: CircleAvatar(
                radius: 14.r,
                backgroundColor: white,
                child: CircleAvatar(
                    radius: 12.r,
                    backgroundColor: getAvatarColor(4),
                    child: Text('+${users.length - 3}',
                        style: TextStyle(fontSize: 10.sp, color: white))),
              ),
            )
          ],
        )
      : Row(children: [
          for (int i = 0; i < users.length; i++)
            Align(
                widthFactor: 0.5,
                child: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: white,
                    child: CircleAvatar(
                        radius: 12.r,
                        backgroundColor: getAvatarColor(i),
                        child: Text(getInitials(users[i]),
                            style: TextStyle(fontSize: 10.sp, color: white)))))
        ]);
}
