import 'dart:async';

import 'package:cinema_tickets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CountdownIndicator extends HookWidget {
  final DateTime startTime;

  CountdownIndicator({Key? key, required this.startTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final remainingTime = useState<int?>(null);

    useEffect(() {
      final timer = Timer.periodic(Duration(seconds: 1), (t) {
        remainingTime.value =
            300 - DateTime.now().difference(startTime).inSeconds;
      });

      return timer.cancel;
    }, [startTime]);

    return remainingTime.value != null
        ? Container(
            alignment: Alignment.center,
            color: kGoldenColor.withOpacity(0.7),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
                "Payment time remaining: ${remainingTime.value} seconds",
                style: TextStyle(color: Colors.white)))
        : Container();
  }
}
