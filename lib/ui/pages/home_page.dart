import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/ui/util/enums_util.dart';

import '../../entities/enums.dart';
import 'fab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TransportTypes> items = TransportTypes.values;

    return FabPage(
      title: 'Home',
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index].getIntlTransportType(context));
        },
      ),

      pageIndex: 0,
    );
  }
}
