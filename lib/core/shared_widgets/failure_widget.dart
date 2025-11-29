import 'package:flutter/material.dart';

import '../utilities/styles.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.failureMessage,
    required this.buttonTap,
  });

  final String failureMessage;
  final Function() buttonTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(failureMessage, style: AppStyles.kTextStyle18Primary),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: buttonTap,
            child: Text("Retry", style: AppStyles.kTextStyle14Black80),
          ),
        ],
      ),
    );
  }
}
