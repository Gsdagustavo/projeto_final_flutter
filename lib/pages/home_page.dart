import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/main.dart';
import 'package:projeto_final_flutter/pages/fab_page.dart';

import '../entities/enums.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransportTypes> items = TransportTypes.values;

    return FabPage(
      body: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Text(items[index].getIntlTransportType(context));
          },
        ),
      ),

      pageIndex: 0,
    );
  }
}
