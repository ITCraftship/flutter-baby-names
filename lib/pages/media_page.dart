import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPage extends StatelessWidget {
  Future getImage(BuildContext context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        'Image added ${image.uri}!',
        style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
      ),
      backgroundColor: Theme.of(context).dialogBackgroundColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Media'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getImage(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
