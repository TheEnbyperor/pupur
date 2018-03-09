import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pupur/recipe_steps.dart';
import 'package:pupur/data_types.dart';

class RecipeSheet extends StatelessWidget {
  final TextStyle titleStyle = const TextStyle(fontSize: 34.0);
  final TextStyle descriptionStyle = const TextStyle(
      fontSize: 15.0, color: Colors.black54, height: 24.0 / 15.0);
  final TextStyle itemStyle =
      const TextStyle(fontSize: 15.0, height: 24.0 / 15.0);
  final TextStyle itemAmountStyle = new TextStyle(
      fontSize: 15.0, color: Colors.blueGrey, height: 24.0 / 15.0);
  final TextStyle headingStyle = const TextStyle(
      fontSize: 16.0, fontWeight: FontWeight.bold, height: 24.0 / 15.0);

  RecipeSheet({Key key, @required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new SafeArea(
        top: false,
        bottom: false,
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Table(
                columnWidths: const <int, TableColumnWidth>{
                  0: const FixedColumnWidth(64.0)
                },
                children: <TableRow>[
                  new TableRow(children: <Widget>[
                    new TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: new FadeInImage(
                        width: 32.0,
                        height: 32.0,
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        placeholder: new AssetImage("imgs/loading.png"),
                        image: new NetworkImage(recipe.iconUrl),
                      ),
                    ),
                    new TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: new Text(recipe.name, style: titleStyle)),
                  ]),
                  new TableRow(children: <Widget>[
                    const SizedBox(),
                    new Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: new Text(recipe.description,
                            style: descriptionStyle)),
                  ]),
                  new TableRow(children: <Widget>[
                    const SizedBox(),
                    new Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 4.0),
                        child: new Text('Cynhwysion', style: headingStyle)),
                  ]),
                ]..addAll(
                    recipe.ingredients.map((RecipeIngredient ingredient) {
                      return _buildItemRow(
                          ingredient.amount, ingredient.description);
                    }),
                  ),
              ),
              new Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: new RaisedButton(
                  child: new Container(
                    padding: const EdgeInsets.all(10.0),
                    child: new Text(
                      "Coginio",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  color: Colors.blueGrey,
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute<Null>(
                        builder: (BuildContext context) {
                          return new RecipeSteps(
                            recipe: recipe,
                            step: 0,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildItemRow(String left, String right) {
    return new TableRow(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(left, style: itemAmountStyle),
        ),
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(right, style: itemStyle),
        ),
      ],
    );
  }
}
