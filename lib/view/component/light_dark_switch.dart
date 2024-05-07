import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../config/constants.dart';
import '../../config/global.dart';
import '../../state/user_state.dart';

class LightDarkSwitch extends StatelessWidget {
  const LightDarkSwitch({Key? key, required this.isLarge, this.width = 120})
      : super(key: key);

  final bool isLarge;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40,
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isLarge) Icon(Icons.light_mode, color: Theme.of(context).colorScheme.onBackground),
          Selector<UserState, UserState>(
            selector: (context, userState) => userState,
            //模式不同则重新构建
            shouldRebuild: (pre, next) => pre.currentBrightness != next.currentBrightness,
            builder: (ctx, userState, child) {
              Brightness currentBrightness = userState.currentBrightness;
              return Flexible(
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    splashRadius: 2,
                    value: currentBrightness == Brightness.dark,
                    onChanged: (value) {
                      if (value) {
                        //变为暗模式
                        userState.currentBrightness = Brightness.dark;
                        SystemChrome.setSystemUIOverlayStyle(systemUILight);
                      } else {
                        userState.currentBrightness = Brightness.light;
                        SystemChrome.setSystemUIOverlayStyle(systemUIDark);
                      }
                      //保存到sqlite
                      Global.userProvider.update(userState.user);
                    },
                  ),
                ),
              );
            },
          ),
          if (isLarge) Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.onBackground),
        ],
      ),
    );
  }
}
