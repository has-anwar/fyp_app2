import 'package:app2/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProfileLabelText extends StatelessWidget {
  ProfileLabelText({@required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal*5, color: kOrangeColor),
    );
  }
}
