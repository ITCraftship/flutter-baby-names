import 'package:flutter/material.dart';
import 'package:name_voter/pages/media_page.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/pages/name_list_page.dart';
import 'package:name_voter/services/auth/auth.dart';

class TabBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabBarPageState();
  }
}

class TabContainer {
  final BottomNavigationBarItem navigationItem;
  final Widget content;

  TabContainer(this.navigationItem, this.content);
}

final List<TabContainer> tabs = <TabContainer>[
  TabContainer(
      const BottomNavigationBarItem(
        icon: Icon(Icons.toc),
        title: Text('Names'),
      ),
      NameListPage()),
  TabContainer(
    const BottomNavigationBarItem(
      icon: Icon(Icons.perm_media),
      title: Text('Media'),
    ),
    const MediaPage(),
  )
];

class _TabBarPageState extends State<TabBarPage> {
  int _currentTabIndex = 0;

  void _changeTab(int value) {
    setState(() {
      _currentTabIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baby Name Votes'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                try {
                  final auth = Provider.of<BaseAuth>(context, listen: false);
                  await auth.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Sign out'))
        ],
      ),
      body: tabs[_currentTabIndex].content,
      bottomNavigationBar: BottomNavigationBar(
        items: tabs.map((tab) => tab.navigationItem).toList(),
        currentIndex: _currentTabIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (value) => _changeTab(value),
      ),
    );
  }
}
