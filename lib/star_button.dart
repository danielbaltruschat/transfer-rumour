import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'queries.dart';

class FavouriteButtonSaveLocally extends StatelessWidget {
  final String _valueToSave;
  final String _saveKey;
  final VoidCallback? _onFavouriteAddition;
  final VoidCallback? _onUnFavouriteAddition;

  const FavouriteButtonSaveLocally(
      {required String valueToSave,
      required String saveKey,
      void Function()? onFavouriteAddition,
      void Function()? onUnFavouriteAddition})
      : _onUnFavouriteAddition = onUnFavouriteAddition,
        _onFavouriteAddition = onFavouriteAddition,
        _saveKey = saveKey,
        _valueToSave = valueToSave;

  void _onFavourite() async {
    await QueryLocal.addFavourite(_saveKey, _valueToSave);
    if (_onFavouriteAddition != null) {
      _onFavouriteAddition!();
    }
  }

  void _onUnFavourite() async {
    await QueryLocal.removeFavourite(_saveKey, _valueToSave);
    if (_onUnFavouriteAddition != null) {
      _onUnFavouriteAddition!();
    }
  }

  Future<bool> _getBoolFavourite() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favourites = prefs.getStringList(_saveKey) ?? [];
    if (_saveKey == "favourite_players") {
      print("favourite_players");
    }
    return favourites.contains(_valueToSave);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getBoolFavourite(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FavouriteButton(
              initialIsFavourite: snapshot.data!,
              onFavourite: _onFavourite,
              onUnFavourite: _onUnFavourite);
        } else {
          return const SizedBox(height: 10, width: 10);
        }
      },
    );
  }
}

class FavouriteButton extends StatefulWidget {
  final bool _initialIsFavourite;
  final VoidCallback _onFavourite;
  final VoidCallback _onUnFavourite;

  const FavouriteButton({
    required bool initialIsFavourite,
    required void Function() onFavourite,
    required void Function() onUnFavourite,
  })  : _onUnFavourite = onUnFavourite,
        _onFavourite = onFavourite,
        _initialIsFavourite = initialIsFavourite;

  @override
  _FavouriteButtonState createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  late bool isFavourite = widget._initialIsFavourite;

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
          widget._onUnFavourite();
        } else {
          widget._onFavourite();
        }
        setState(() {
          isFavourite = !isFavourite;
        });
      },
    ));
  }
}
