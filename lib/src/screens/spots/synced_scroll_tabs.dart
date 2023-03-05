import 'package:flutter/material.dart';

class SyncedScroll extends StatefulWidget {
  const SyncedScroll({Key? key}) : super(key: key);

  @override
  _SyncedScrollState createState() => _SyncedScrollState();
}

class _SyncedScrollState extends State<SyncedScroll> {
  final _scrollController1 = ScrollController();
  final _scrollController2 = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController1.addListener(() {
      _scrollController2.jumpTo(_scrollController1.offset);
    });

    _scrollController2.addListener(() {
      _scrollController1.jumpTo(_scrollController2.offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController1,
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('List 1 Item $index'),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController2,
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('List 2 Item $index'),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    super.dispose();
  }
}
