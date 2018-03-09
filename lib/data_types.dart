import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const GRAPHQL_SERVER_URL = "https://pupur.misell.cymru/graphql";
const IMAGE_SERVER_URL = "https://pupur.misell.cymru/";

Set<int> _favoriteRecipes = new Set<int>();

class Recipe {
  const Recipe({
    this.id,
    this.name,
    this.author,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.ingredients,
    this.steps,
  });

  final int id;
  final String name;
  final String author;
  final String description;
  final String imageUrl;
  final String iconUrl;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
}

class RecipeIngredient {
  const RecipeIngredient({this.id, this.amount, this.description});

  final int id;
  final String amount;
  final String description;
}

class RecipeStep {
  const RecipeStep({this.id, this.image, this.description});

  final int id;
  final String image;
  final String description;
}

class GraphQLClient {
  final httpClient = createHttpClient();

  Future<Map> runQuery(String url, String query, Map variables) async {
    String req = JSON.encode({
      "query": query,
      "variables": variables,
    });
    var response = await httpClient.post(
      url,
      body: req,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
    Map resp = JSON.decode(response.body);
    return resp;
  }
}

bool isFavoriteRecipe(Recipe recipe) {
  return _favoriteRecipes.contains(recipe.id);
}

void toggleFavoriteRecipe(Recipe recipe) {
  if (_favoriteRecipes.contains(recipe.id))
    _favoriteRecipes.remove(recipe.id);
  else
    _favoriteRecipes.add(recipe.id);

  saveFavorites();
}

void saveFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("favorites", JSON.encode(_favoriteRecipes.toList()));
}

void loadFavorites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    List<int> favs = JSON.decode(prefs.getString("favorites"));
    _favoriteRecipes = favs.toSet();
  } catch (e) {
    _favoriteRecipes = new Set<int>();
  }
}