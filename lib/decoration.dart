import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData _icon;
  final String _label;
  final TextStyle? _style;

  const IconLabel(
      {required IconData icon, required String label, TextStyle? style})
      : _style = style,
        _label = label,
        _icon = icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(_icon),
        const SizedBox(width: 5),
        Text(_label, style: _style ?? const TextStyle()),
      ],
    );
  }
}

class DecoratedContainer extends StatelessWidget {
  final Widget _child;
  final Color? _colour;

  const DecoratedContainer({required Widget child, Color? colour})
      : _colour = colour,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: _colour ?? Theme.of(context).colorScheme.primary,
            width: 0.5),
      ),
      child: _child,
    );
  }
}

class DecoratedContainerItem extends StatelessWidget {
  final Widget _child;
  final double _aspectRatio;
  final Color? _colour;

  const DecoratedContainerItem(
      {required Widget child, double aspectRatio = 4, Color? colour})
      : _colour = colour,
        _aspectRatio = aspectRatio,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: DecoratedContainer(
            child: Padding(padding: const EdgeInsets.all(5), child: _child),
            colour: _colour),
      ),
    );
  }
}
