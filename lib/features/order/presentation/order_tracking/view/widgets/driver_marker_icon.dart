import 'package:flower_app/core/utils/image_path/images_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The delivery hero on the map (the scooter, from [ImagesPath.scooter]).
class DriverMarkerIcon extends StatelessWidget {
  const DriverMarkerIcon({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(ImagesPath.scooter, width: size, height: size);
  }
}
