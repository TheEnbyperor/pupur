import 'package:flutter/material.dart';
import 'package:pupur/data_types.dart';
import 'package:pupur/logo.dart';
import 'package:pupur/recipe_page.dart';

const double _kAppBarHeight = 128.0;
const double _kRecipePageMaxWidth = 500.0;

class RecipeGrid extends StatefulWidget {
  @override
  RecipeGridState createState() => new RecipeGridState();
}

class RecipeGridState extends State<RecipeGrid> {
  final _graphqlClient = new GraphQLClient();

  List<Recipe> _recipes = [];
  bool _loaded = false;
  bool _showFavorites = false;

  _getRecipes() async {
    String query = "query {\n"
        "  recipes {\n"
        "    ID\n"
        "    name\n"
        "    author\n"
        "    description\n"
        "    image\n"
        "    icon\n"
        "    ingredients {\n"
        "      ID\n"
        "      description\n"
        "      amount\n"
        "    }\n"
        "    steps {\n"
        "      ID\n"
        "      description\n"
        "      image\n"
        "    }\n"
        "  }\n"
        "}";
    return _graphqlClient.runQuery(GRAPHQL_SERVER_URL, query, {}).then((resp) {
      setState(() {
        _recipes = [];
        List<Map<String, Object>> recipes = resp["data"]["recipes"];
        recipes.forEach((v) {
          List<RecipeIngredient> ingredients = [];
          List<RecipeStep> steps = [];
          List<Map<String, Object>> ingredientsJson = v["ingredients"];
          List<Map<String, Object>> stepsJson = v["steps"];
          ingredientsJson.forEach((i) {
            ingredients.add(new RecipeIngredient(
              id: i["ID"],
              description: i["description"],
              amount: i["amount"],
            ));
          });
          stepsJson.forEach((i) {
            steps.add(new RecipeStep(
              id: i["ID"],
              description: i["description"],
              image: IMAGE_SERVER_URL + i["image"],
            ));
          });
          _recipes.add(new Recipe(
            id: v["ID"],
            name: v["name"],
            imageUrl: IMAGE_SERVER_URL + v["image"],
            iconUrl: IMAGE_SERVER_URL + v["icon"],
            author: v["author"],
            description: "",
            ingredients: ingredients,
            steps: steps,
          ));
        });
        _loaded = true;
        return true;
      });
    });
  }

  @override
  initState() {
    super.initState();

    _getRecipes();
    loadFavorites();
  }

  List<Recipe> _getFavorites() {
    return _recipes.where((r) {
      return isFavoriteRecipe(r);
    }).toList();
  }

  Widget _buildAppBar(double statusBarHeight) {
    return new SliverAppBar(
      pinned: true,
      expandedHeight: _kAppBarHeight,
      flexibleSpace: new LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        final double appBarHeight = size.height - statusBarHeight;
        final double t =
            (appBarHeight - kToolbarHeight) / (_kAppBarHeight - kToolbarHeight);
        final double extraPadding =
            new Tween<double>(begin: 10.0, end: 24.0).lerp(t);
        final double logoHeight = appBarHeight - 1.5 * extraPadding;
        return new Padding(
          padding: new EdgeInsets.only(
            top: statusBarHeight + 0.5 * extraPadding,
            bottom: extraPadding,
          ),
          child: new PupurLogo(height: logoHeight, t: t.clamp(0.0, 1.0)),
        );
      }),
    );
  }

  Widget _buildBody(BuildContext context, double statusBarHeight) {
    final EdgeInsets mediaPadding = MediaQuery.of(context).padding;
    final EdgeInsets padding = new EdgeInsets.only(
        top: 8.0,
        left: 8.0 + mediaPadding.left,
        right: 8.0 + mediaPadding.right,
        bottom: 8.0);
    final List<Recipe> recipes = _showFavorites ? _getFavorites() : _recipes;
    return new SliverPadding(
      padding: padding,
      sliver: new SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _kRecipePageMaxWidth,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        delegate: _loaded
            ? new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final Recipe recipe = recipes[index];
                  return new RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      showRecipePage(context, recipe);
                    },
                  );
                },
                childCount: recipes.length,
              )
            : new SliverChildListDelegate(
                <Widget>[
                  new Center(
                    child: new CircularProgressIndicator(),
                  )
                ],
              ),
      ),
    );
  }

  void showRecipePage(BuildContext context, Recipe recipe) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new RecipePage(recipe: recipe);
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return new Scaffold(
      body: new RefreshIndicator(
        child: new CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(statusBarHeight),
            _buildBody(context, statusBarHeight)
          ],
        ),
        onRefresh: () {
          return _getRecipes();
        },
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.book),
              title: new Text("Pop rysaint"),
              onTap: () {
                setState(() {
                  _showFavorites = false;
                  Navigator.pop(context);
                });
              },
            ),
            new ListTile(
              leading: new Icon(Icons.favorite),
              title: new Text("Ffefrynnau"),
              onTap: () {
                setState(() {
                  _showFavorites = true;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final TextStyle titleStyle =
      const TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600);
  final TextStyle authorStyle =
      const TextStyle(fontWeight: FontWeight.w500, color: Colors.black54);

  const RecipeCard({this.recipe, this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: onTap,
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Hero(
              tag: recipe.imageUrl,
              child: new FadeInImage(
                fit: BoxFit.contain,
                placeholder: new AssetImage("imgs/loading.png"),
                image: new NetworkImage(recipe.imageUrl),
              ),
            ),
            new Expanded(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: new FadeInImage(
                      width: 48.0,
                      height: 48.0,
                      placeholder: new AssetImage("imgs/loading.png"),
                      image: new NetworkImage(recipe.iconUrl),
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(recipe.name,
                            style: titleStyle,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis),
                        new Text(recipe.author, style: authorStyle),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
