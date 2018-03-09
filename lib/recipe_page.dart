import 'package:flutter/material.dart';
import 'package:pupur/data_types.dart';
import 'package:pupur/recipe_sheet.dart';

const double _kRecipePageMaxWidth = 500.0;
const double _kFabHalfSize = 28.0;

class RecipePage extends StatefulWidget {
  RecipePage({this.recipe});

  final Recipe recipe;

  @override
  RecipePageState createState() => new RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextStyle menuItemStyle = const TextStyle(
      fontSize: 15.0, color: Colors.black54, height: 24.0 / 15.0);

  double _getAppBarHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.3;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = _getAppBarHeight(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool fullWidth = screenSize.width < _kRecipePageMaxWidth;
    final bool isFavourite = isFavoriteRecipe(widget.recipe);
    return new Scaffold(
      key: _scaffoldKey,
      body: new Stack(
        children: <Widget>[
          new Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            height: appBarHeight + _kFabHalfSize,
            child: new Hero(
              tag: widget.recipe.imageUrl,
              child: new FadeInImage(
                fit: fullWidth ? BoxFit.fitWidth : BoxFit.cover,
                placeholder: new AssetImage("imgs/loading.png"),
                image: new NetworkImage(widget.recipe.imageUrl),
              ),
            ),
          ),
          new CustomScrollView(
            slivers: <Widget>[
              new SliverAppBar(
                expandedHeight: appBarHeight - _kFabHalfSize,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  background: const DecoratedBox(
                    decoration: const BoxDecoration(
                      gradient: const LinearGradient(
                        begin: const Alignment(0.0, -1.0),
                        end: const Alignment(0.0, -0.2),
                        colors: const <Color>[
                          const Color(0x60000000),
                          const Color(0x00000000)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              new SliverToBoxAdapter(
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      padding: const EdgeInsets.only(top: _kFabHalfSize),
                      width: fullWidth ? null : _kRecipePageMaxWidth,
                      child: new RecipeSheet(recipe: widget.recipe),
                    ),
                    new Positioned(
                      right: 16.0,
                      child: new FloatingActionButton(
                        child: new Icon(isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () {
                          setState(() {
                            toggleFavoriteRecipe(widget.recipe);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
