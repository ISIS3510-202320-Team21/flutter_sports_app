import 'package:flutter/material.dart';

class SquareIconButton extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  SquareIconButton({
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 75, // Establece la altura que desees aquí
      width: 75,  // Asegúrate de que sea cuadrado estableciendo el mismo valor para el ancho
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(1),
          borderRadius: BorderRadius.circular(11),
        ),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: IconButton(
            icon: Icon(
              iconData,
              color: colorScheme.onBackground,
              size: 30,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
