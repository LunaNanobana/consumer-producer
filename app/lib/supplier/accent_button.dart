
import 'package:flutter/material.dart';

class AccentButton extends StatelessWidget{
  final String title;
  final Function() onTap;

  const AccentButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
      onPressed: onTap,
      child: Text(title,
      )
    );
  }

}