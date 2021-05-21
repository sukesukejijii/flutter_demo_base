import 'package:flutter/material.dart';

const dialogBody =
    'A simple dialog offers the user a choice between several options. This widget is commonly used to represent each of the options. If the user selects this option, the widget will call the onPressed callback, which typically uses Navigator.pop to close the dialog.';

class Popup extends StatelessWidget {
  const Popup();

  @override
  Widget build(BuildContext context) {
    void _showDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 3, color: Colors.pink),
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text('SimpleDialog'),
            insetPadding: EdgeInsets.all(100),
            contentPadding: EdgeInsets.all(27),
            children: [
              Text(dialogBody),
              SizedBox(height: 25),
              SimpleDialogOption(
                child: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }

    return Center(
      child: OutlinedButton(
        onPressed: _showDialog,
        style: OutlinedButton.styleFrom(
          side: BorderSide(width: 2, color: Colors.pink),
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        ),
        child: const Text('OPEN'),
      ),
    );
  }
}
