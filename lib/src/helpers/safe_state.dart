import 'dart:async';

import 'package:flutter/material.dart';

mixin SafeState<T extends StatefulWidget> on State<T> {
  FutureOr<void> safeSetState(FutureOr<dynamic> Function() fn) async {
    if (mounted &&
        !context.debugDoingBuild &&
        context.owner?.debugBuilding == false) {
      await fn();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(Duration.zero, () async {
      if (mounted) {
        await contextReady();
      }
    });
  }

  @override
  void setState(Function() fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> contextReady() async {}
}
