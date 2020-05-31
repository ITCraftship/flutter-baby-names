import 'package:flutter/material.dart';

class NewNameDialog extends StatefulWidget {
  final Function(String) onNamePropose;
  final Function onCancel;

  const NewNameDialog({Key key, this.onNamePropose, this.onCancel})
      : super(key: key);

  @override
  _NewNameDialogState createState() =>
      _NewNameDialogState(onCancel: onCancel, onNamePropose: onNamePropose);
}

class _NewNameDialogState extends State<NewNameDialog> {
  final Function(String) onNamePropose;
  final Function onCancel;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final newNameTextController = TextEditingController();

  _NewNameDialogState({this.onNamePropose, this.onCancel});

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newNameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Propose new name'),
      content: TextField(
        controller: newNameTextController,
      ),
      actions: [
        FlatButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        RaisedButton(
          onPressed: () {
            onNamePropose?.call(newNameTextController.text);
            Navigator.of(context).pop();
          },
          child: Text('Propose'),
        )
      ],
    );
  }
}
