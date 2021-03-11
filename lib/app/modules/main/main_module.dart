import 'package:Find/app/pages/search/search_page.dart';

import './../../pages/home/home_page.dart';

import 'package:flutter_modular/flutter_modular.dart';

class Main extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => HomePage()),
        ModularRouter("/search", child: (_, args) => Search()),
      ];

  static Inject get to => Inject<MainModule>.of();
}
