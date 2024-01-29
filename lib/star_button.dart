import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'queries.dart';

class FavouriteButtonSaveLocally extends StatelessWidget {
  final String valueToSave;
  final String saveKey;
  final VoidCallback? onFavouriteAddition;
  final VoidCallback? onUnFavouriteAddition;

  const FavouriteButtonSaveLocally(
      {required this.valueToSave,
      required this.saveKey,
      this.onFavouriteAddition,
      this.onUnFavouriteAddition});

  void onFavourite() async {
    await QueryLocal.addFavourite(saveKey, valueToSave);
    if (onFavouriteAddition != null) {
      onFavouriteAddition!();
    }
  }

  void onUnFavourite() async {
    await QueryLocal.removeFavourite(saveKey, valueToSave);
    if (onUnFavouriteAddition != null) {
      onUnFavouriteAddition!();
    }
  }

  Future<bool> getBoolFavourite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList(saveKey) ?? [];
    if (saveKey == "favourite_players") {
      print("favourite_players");
    }
    return favourites.contains(valueToSave);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBoolFavourite(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FavouriteButton(
              initialIsFavourite: snapshot.data!,
              onFavourite: onFavourite,
              onUnFavourite: onUnFavourite);
        } else {
          return const SizedBox(height: 10, width: 10);
        }
      },
    );
  }
}

class FavouriteButton extends StatefulWidget {
  final bool initialIsFavourite;
  final VoidCallback onFavourite;
  final VoidCallback onUnFavourite;

  const FavouriteButton({
    required this.initialIsFavourite,
    required this.onFavourite,
    required this.onUnFavourite,
  });

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  late bool isFavourite = widget.initialIsFavourite;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        child: IconButton(
      icon: Icon(
        isFavourite ? Icons.star : Icons.star_border,
        color:
            isFavourite ? Theme.of(context).colorScheme.primary : Colors.grey,
      ),
      onPressed: () {
        if (isFavourite) {
          widget.onUnFavourite();
        } else {
          widget.onFavourite();
        }
        setState(() {
          isFavourite = !isFavourite;
        });
      },
    ));
  }
}
