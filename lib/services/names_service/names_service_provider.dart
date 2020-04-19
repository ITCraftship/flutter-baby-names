import 'package:flutter/material.dart';

import 'package:name_voter/services/names_service/names_service.dart';

class NamesServiceProvider extends InheritedWidget {
  final NamesServiceBase namesService;

  NamesServiceProvider({Key key, Widget child, this.namesService})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static NamesServiceProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NamesServiceProvider>();
}
