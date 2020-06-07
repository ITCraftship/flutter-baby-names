import 'package:flutter/material.dart';

class NewNameDialog extends StatefulWidget {
  final Function(String) onNamePropose;
  final Function onCancel;

  const NewNameDialog({Key key, this.onNamePropose, this.onCancel})
      : super(key: key);

  @override
  _NewNameDialogState createState() => _NewNameDialogState();
}

class _NewNameDialogState extends State<NewNameDialog> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController newNameTextController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Propose new name'),
      content: TextField(
        controller: newNameTextController,
      ),
      actions: [
        FlatButton(
          onPressed: () {
            widget.onCancel?.call();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        RaisedButton(
          onPressed: () {
            widget.onNamePropose?.call(newNameTextController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Propose'),
        )
      ],
    );
  }
}
