import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'ui/router/connect_route.dart';

class XposeDevApp extends StatelessWidget {
  const XposeDevApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "XposeDev",
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.material,
        swapColors: true,
        subThemesData: const FlexSubThemesData(
          blendTextTheme: true,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          adaptiveRadius: FlexAdaptive.desktop(),
          switchThumbSchemeColor: SchemeColor.onPrimary,
          inputDecoratorIsFilled: false,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedHasBorder: false,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.material,
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 13,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          adaptiveRadius: FlexAdaptive.desktop(),
          switchThumbSchemeColor: SchemeColor.onPrimary,
          inputDecoratorIsFilled: false,
          inputDecoratorBorderType: FlexInputBorderType.underline,
          inputDecoratorUnfocusedHasBorder: false,
        ),
        keyColors: const FlexKeyColors(
          useSecondary: true,
          useTertiary: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
        // To use the Playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: const ConnectRoute(),
    );
  }
}
