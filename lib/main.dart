import 'package:flutter/material.dart';
import 'package:Find/app/app_module.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ModularApp(module: AppModule()));
  });
}
