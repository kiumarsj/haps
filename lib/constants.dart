import 'package:flutter/material.dart';

const color_57 = Color(0xFF8E3C56);

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF006D44),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFF51FFAE),
  onPrimaryContainer: Color(0xFF002111),
  secondary: Color(0xFF456551),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFC7EBD2),
  onSecondaryContainer: Color(0xFF002111),
  tertiary: Color(0xFF1C667A),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFB3EBFF),
  onTertiaryContainer: Color(0xFF001F27),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFBFDF8),
  onBackground: Color(0xFF191C1A),
  surface: Color(0xFFFBFDF8),
  onSurface: Color(0xFF191C1A),
  surfaceVariant: Color(0xFFDCE5DC),
  onSurfaceVariant: Color(0xFF404942),
  outline: Color(0xFF717972),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF2E312E),
  onInverseSurface: Color(0xFFF0F1ED),
  inversePrimary: Color(0xFF1EE294),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1EE294),
  onPrimary: Color(0xFF003921),
  primaryContainer: Color(0xFF005232),
  onPrimaryContainer: Color(0xFF51FFAE),
  secondary: Color(0xFFABCFB6),
  onSecondary: Color(0xFF163625),
  secondaryContainer: Color(0xFF2D4D3B),
  onSecondaryContainer: Color(0xFFC7EBD2),
  tertiary: Color(0xFF8ED0E7),
  onTertiary: Color(0xFF003642),
  tertiaryContainer: Color(0xFF004E5F),
  onTertiaryContainer: Color(0xFFB3EBFF),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  errorContainer: Color(0xFF93000A),
  onErrorContainer: Color(0xFFFFB4AB),
  background: Color(0xFF191C1A),
  onBackground: Color(0xFFE1E3DF),
  surface: Color(0xFF191C1A),
  onSurface: Color(0xFFE1E3DF),
  surfaceVariant: Color(0xFF404942),
  onSurfaceVariant: Color(0xFFC0C9C0),
  outline: Color(0xFF8A938B),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE1E3DF),
  onInverseSurface: Color(0xFF2E312E),
  inversePrimary: Color(0xFF006D44),
);

class MyDimentions {
  static width(context) => MediaQuery.of(context).size.width;
  static height(context) => MediaQuery.of(context).size.width;
}
