import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/ui/color.dart';
import '../../../shared/ui/responsive.dart';
import '../../../shared/values/assets.dart';
import '../../../shared/values/palette.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Palette.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.iconProfile,
            height: 20,
            width: 20,
            colorFilter: svgColor(Colors.white),
          ),
          const SizedBox(width: 4),
          if (!Responsive.isMobile(context))
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Username'),
            ),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
