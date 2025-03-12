// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:mynotes/screens/create_note_screen.dart' as _i1;
import 'package:mynotes/screens/home_screen.dart' as _i2;
import 'package:mynotes/screens/view_note_screen.dart' as _i3;

/// generated route for
/// [_i1.CreateNoteScreen]
class CreateNoteRoute extends _i4.PageRouteInfo<void> {
  const CreateNoteRoute({List<_i4.PageRouteInfo>? children})
    : super(CreateNoteRoute.name, initialChildren: children);

  static const String name = 'CreateNoteRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.CreateNoteScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.ViewNoteScreen]
class ViewNoteRoute extends _i4.PageRouteInfo<void> {
  const ViewNoteRoute({List<_i4.PageRouteInfo>? children})
    : super(ViewNoteRoute.name, initialChildren: children);

  static const String name = 'ViewNoteRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.ViewNoteScreen();
    },
  );
}
