import 'package:flutter/material.dart';

import '../../etc/utils.dart';
import '../../models/poll.dart';
import '../../models/response_body.dart';
import '../../services/api.dart';
import '../my_scaffold.dart';
import '../poll_results/poll_results_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Poll>? _polls;
  var _isLoading = false;
  List<ResponseBody>? _pollResult;


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // todo: Load list of polls here
    setState(() {
      _isLoading = true;
    });


    await Future.delayed(const Duration(seconds: 3), () {});

    try {
      var result = await ApiClient().getPolls();
      List<ResponseBody> pollResult = [];
      for(int i = 1 ; i<=3 ; i++){
        pollResult.addAll(await ApiClient().getPollsResult(i));
      }
      setState(() {
        _polls = result;
        _pollResult!.addAll(pollResult);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Image.network('https://cpsu-test-api.herokuapp.com/images/election.jpg'),
          Expanded(
            child: Stack(
              children: [
                if (_polls != null) _buildList(),
                if (_isLoading) _buildProgress(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: _polls!.length,
      itemBuilder: (BuildContext context, int index) {
        var poll = _polls![index];
        var id = poll.id.toString();
        // todo: Create your poll item by replacing this Container()
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), //color of shadow
                  spreadRadius: 2, //spread radius
                  blurRadius: 2, // blur radius
                  offset: Offset(0, 0), // changes position of shadow

                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0 ,right: 6.0),
                        child: Text('$id.'),
                      ),
                      Expanded(child: Text(poll.question)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60.0,bottom: 6.0),
                  child: Column(
                    children: [
                      for(int i = 0 ; i < poll.choices.length ; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildChoice(poll.choices[i],index),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              _handleClickProjectItem(_pollResult!);
                            },
                            child: Text('ดูผลโหวต')),
                      ),
                    ],
                  ),
                )

              ]
            ),
          ),
        );
      },
    );
  }

  void _handleClickProjectItem(List<ResponseBody> pollResult) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PollResultsPage()),
    );
  }

  Padding _buildChoice(String choice,int index){
    var n = "'$choice'";
    var id_q = index+1;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: OutlinedButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          _buildProgress();

          try{
            var vote = await ApiClient().VotePolls(index+1,choice);
            if(vote){
              showOkDialog(context,'SUCCESS',"โหวตตัวเลือก '$choice' ของโพลคำถามข้อ $id_q สำเร็จ");
            }
          }
          finally {
          setState(() {
          _isLoading = false;
          });
          }
        },
        child: Text(choice),
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: Colors.white),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('รอสักครู่', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
