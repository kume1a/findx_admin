import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'palette.dart';

abstract final class AppTheme {
  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.bg,
    textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: Colors.white),
    canvasColor: Palette.secondary,
  );
}
