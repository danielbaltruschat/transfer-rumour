import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextStyle? style;

  const IconLabel({required this.icon, required this.label, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        Text(label, style: style ?? const TextStyle()),
      ],
    );
  }
}

class DecoratedContainer extends StatelessWidget {
  final Widget child;

  const DecoratedContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 0.5),
      ),
      child: child,
    );
  }
}

class DecoratedContainerItem extends StatelessWidget {
  final Widget child;
  final double aspectRatio;

  const DecoratedContainerItem({required this.child, this.aspectRatio = 4});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 5, right: 5),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: DecoratedContainer(
            child: Padding(padding: const EdgeInsets.all(5), child: child)),
      ),
    );
  }
}
