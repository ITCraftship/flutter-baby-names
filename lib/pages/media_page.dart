import 'package:flutter/material.dart';

class MediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Media'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
              'Image added!',
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
            ),
            backgroundColor: Theme.of(context).dialogBackgroundColor,
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
