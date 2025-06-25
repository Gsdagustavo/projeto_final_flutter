import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/pages/fab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FabPage(body: Center(child: Text('Home Page')), pageIndex: 0,);
  }
}
