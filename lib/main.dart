import 'package:flutter/material.dart';
import 'package:pupur/recipe_grid.dart';

void main() => runApp(new PupurApp());

class PupurApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pupur',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: new RecipeGrid(),
    );
  }
}