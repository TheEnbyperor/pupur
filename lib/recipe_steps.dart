import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pupur/data_types.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    @required builder,
    RouteSettings settings: const RouteSettings(),
    maintainState: true,
    bool fullscreenDialog: false,
  })
      : assert(builder != null),
        super(
            builder: builder,
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            maintainState: maintainState);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var opacityAnimation = new CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    return new FadeTransition(
        opacity: opacityAnimation,
      child: child,
    );
  }
}

class RecipeSteps extends StatelessWidget {
  RecipeSteps({@required this.recipe, @required this.step});

  final Recipe recipe;
  final int step;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new BottomNavigationBar(
          iconSize: 32.0,
          items: <BottomNavigationBarItem>[
            (step != 0)
                ? new BottomNavigationBarItem(
                    icon: new Icon(Icons.arrow_back),
                    title: new Text("Cam diwethaf"),
                  )
                : new BottomNavigationBarItem(
                    icon: new Icon(null), title: new Text("")),
            (step != (recipe.steps.length - 1))
                ? new BottomNavigationBarItem(
                    icon: new Icon(Icons.arrow_forward),
                    title: new Text("Cam nesaf"),
                  )
                : new BottomNavigationBarItem(
                    icon: new Icon(null), title: new Text(""))
          ],
          currentIndex: 1,
          onTap: (i) {
            switch (i) {
              case 0:
                if (step != 0) {
                  Navigator.of(context).pushReplacement(
                    new CustomRoute(
                      builder: (BuildContext context) {
                        return new RecipeSteps(
                          recipe: recipe,
                          step: step - 1,
                        );
                      },
                    ),
                  );
                }
                break;
              case 1:
                if (step != (recipe.steps.length - 1)) {
                  Navigator.of(context).pushReplacement(
                    new CustomRoute(
                      builder: (BuildContext context) {
                        return new RecipeSteps(
                          recipe: recipe,
                          step: step + 1,
                        );
                      },
                    ),
                  );
                }
                break;
            }
          }),
      body: new RecipeStepWidget(
        step: recipe.steps[step],
        stepNum: step + 1,
      ),
    );
  }
}

class RecipeStepWidget extends StatelessWidget {
  const RecipeStepWidget({this.step, this.stepNum});

  final RecipeStep step;
  final int stepNum;

  double _getAppBarHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.4;

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = _getAppBarHeight(context);
    return new Stack(
      children: <Widget>[
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          height: appBarHeight,
          child: new FadeInImage(
            fit: BoxFit.cover,
            placeholder: const AssetImage("imgs/loading.png"),
            image: new NetworkImage(step.image),
          ),
        ),
        new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              expandedHeight: appBarHeight - 25,
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
              child: new Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 16.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    new Text(
                      "Cam $stepNum",
                      style: const TextStyle(fontSize: 34.0),
                      textAlign: TextAlign.center,
                    ),
                    new Divider(),
                    new MarkdownBody(
                      data: step.description,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
