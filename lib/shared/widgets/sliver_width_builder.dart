import 'package:flutter/widgets.dart';

/// Rebuild a responsive sliver on width/data changes, not scroll-offset changes.
/// SliverLayoutBuilder receives new constraints at every scroll position; reusing
/// its child avoids rebuilding headers, delegates and image widgets per pixel.
class SliverWidthBuilder extends StatefulWidget {
  const SliverWidthBuilder({super.key, required this.builder});
  final Widget Function(BuildContext context, double width) builder;
  @override
  State<SliverWidthBuilder> createState() => _SliverWidthBuilderState();
}

class _SliverWidthBuilderState extends State<SliverWidthBuilder> {
  double? _width;
  Widget? _child;
  @override
  void didUpdateWidget(covariant SliverWidthBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    _child = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _child = null;
  }

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      if (_child == null || _width != constraints.crossAxisExtent) {
        _width = constraints.crossAxisExtent;
        // Use this State's context so inherited changes invalidate the cache.
        _child = widget.builder(this.context, _width!);
      }
      return _child!;
    },
  );
}
