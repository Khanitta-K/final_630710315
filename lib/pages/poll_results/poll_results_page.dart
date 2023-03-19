import 'package:election_2566_poll/pages/my_scaffold.dart';
import 'package:flutter/material.dart';

import '../../models/response_body.dart';

class PollResultsPage extends StatelessWidget {
  const PollResultsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(title: const Text('ผลโหวต')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // todo: Add your UI by replacing this Container()
        child: Container(

        ),
      ),
    );
  }
}
