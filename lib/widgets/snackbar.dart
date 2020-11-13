import 'package:flutter/material.dart';

SnackBar getSnackBar(String message, Color color) => SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
