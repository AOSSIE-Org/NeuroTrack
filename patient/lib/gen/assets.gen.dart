/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_calendar.svg
  SvgGenImage get icCalendar =>
      const SvgGenImage('assets/icons/ic_calendar.svg');

  /// File path: assets/icons/ic_completed.svg
  SvgGenImage get icCompleted =>
      const SvgGenImage('assets/icons/ic_completed.svg');

  /// File path: assets/icons/ic_home.svg
  SvgGenImage get icHome => const SvgGenImage('assets/icons/ic_home.svg');

  /// File path: assets/icons/ic_missed.svg
  SvgGenImage get icMissed => const SvgGenImage('assets/icons/ic_missed.svg');

  /// File path: assets/icons/ic_notifications.svg
  SvgGenImage get icNotifications =>
      const SvgGenImage('assets/icons/ic_notifications.svg');

  /// File path: assets/icons/ic_profile.svg
  SvgGenImage get icProfile => const SvgGenImage('assets/icons/ic_profile.svg');

  /// File path: assets/icons/ic_regressed.svg
  SvgGenImage get icRegressed =>
      const SvgGenImage('assets/icons/ic_regressed.svg');

  /// File path: assets/icons/ic_report.svg
  SvgGenImage get icReport => const SvgGenImage('assets/icons/ic_report.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    icCalendar,
    icCompleted,
    icHome,
    icMissed,
    icNotifications,
    icProfile,
    icRegressed,
    icReport,
  ];
}

class $AssetsIllustrationsGen {
  const $AssetsIllustrationsGen();

  /// File path: assets/illustrations/i9n_activities.svg
  SvgGenImage get i9nActivities =>
      const SvgGenImage('assets/illustrations/i9n_activities.svg');

  /// File path: assets/illustrations/i9n_adhd.svg
  SvgGenImage get i9nAdhd =>
      const SvgGenImage('assets/illustrations/i9n_adhd.svg');

  /// File path: assets/illustrations/i9n_aq10.svg
  SvgGenImage get i9nAq10 =>
      const SvgGenImage('assets/illustrations/i9n_aq10.svg');

  /// File path: assets/illustrations/i9n_autism.svg
  SvgGenImage get i9nAutism =>
      const SvgGenImage('assets/illustrations/i9n_autism.svg');

  /// File path: assets/illustrations/i9n_goals.svg
  SvgGenImage get i9nGoals =>
      const SvgGenImage('assets/illustrations/i9n_goals.svg');

  /// File path: assets/illustrations/i9n_heartbeat.svg
  SvgGenImage get i9nHeartbeat =>
      const SvgGenImage('assets/illustrations/i9n_heartbeat.svg');

  /// File path: assets/illustrations/i9n_milestones.svg
  SvgGenImage get i9nMilestones =>
      const SvgGenImage('assets/illustrations/i9n_milestones.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
    i9nActivities,
    i9nAdhd,
    i9nAq10,
    i9nAutism,
    i9nGoals,
    i9nHeartbeat,
    i9nMilestones,
  ];
}

class $AssetsLogosGen {
  const $AssetsLogosGen();

  /// File path: assets/logos/lg_google.svg
  SvgGenImage get lgGoogle => const SvgGenImage('assets/logos/lg_google.svg');

  /// File path: assets/logos/lg_neurotrack.svg
  SvgGenImage get lgNeurotrack =>
      const SvgGenImage('assets/logos/lg_neurotrack.svg');

  /// List of all assets
  List<SvgGenImage> get values => [lgGoogle, lgNeurotrack];
}

class $AssetsPlaceholdersGen {
  const $AssetsPlaceholdersGen();

  /// File path: assets/placeholders/therapist_img.png
  AssetGenImage get therapistImg =>
      const AssetGenImage('assets/placeholders/therapist_img.png');

  /// File path: assets/placeholders/thumbnail_1.png
  AssetGenImage get thumbnail1 =>
      const AssetGenImage('assets/placeholders/thumbnail_1.png');

  /// List of all assets
  List<AssetGenImage> get values => [therapistImg, thumbnail1];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsIllustrationsGen illustrations =
      $AssetsIllustrationsGen();
  static const $AssetsLogosGen logos = $AssetsLogosGen();
  static const $AssetsPlaceholdersGen placeholders = $AssetsPlaceholdersGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(this._assetName, {this.size, this.flavors = const {}});

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
