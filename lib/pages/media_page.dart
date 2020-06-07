import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({Key key}) : super(key: key);

  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  Future getImage(BuildContext context) async {
    final image = await picker.getImage(source: ImageSource.gallery);
    String message = 'No image selected';
    if (image != null) {
      message = 'Image added ${image.path}!';
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          'https://assets4.lottiefiles.com/packages/lf20_PREjqN.json',
          width: 350,
          height: 350,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getImage(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
