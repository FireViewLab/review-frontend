import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Route-scoped clearance for floating overlays outside the route's Scaffold.
final bottomActionBarHeightProvider = NotifierProvider.autoDispose
    .family<BottomActionBarHeight, double, String>(BottomActionBarHeight.new);

class BottomActionBarHeight extends Notifier<double> {
  BottomActionBarHeight(this.routePath);
  final String routePath;

  @override
  double build() => 0;

  void update(double height) {
    if (ref.mounted && state != height) state = height;
  }
}
