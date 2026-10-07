import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/core/platform/web_image_element.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholderIcon = Icons.image_outlined,
    this.iconSize = 28.0,
    this.borderRadius,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final Alignment alignment;
  final IconData placeholderIcon;
  final double iconSize;
  final BorderRadius? borderRadius;

  String get _objectFit => switch (fit) {
    BoxFit.contain => 'contain',
    BoxFit.fill => 'fill',
    BoxFit.fitWidth => 'cover',
    BoxFit.fitHeight => 'contain',
    BoxFit.none => 'none',
    _ => 'cover',
  };

  @override
  Widget build(BuildContext context) {
    Widget child;
    final usePlaceholder = AppNetworkImagePlaceholderScope.maybeOf(context);

    if (url.isEmpty || usePlaceholder) {
      child = _Placeholder(icon: placeholderIcon, iconSize: iconSize);
    } else if (kIsWeb) {
      // HtmlElementView로 <img> 태그 직접 렌더링 → 외부 CDN 이미지 CORS 우회
      child = _WebImage(
        url: url,
        objectFit: _objectFit,
        placeholder: _Placeholder(icon: placeholderIcon, iconSize: iconSize),
      );
    } else {
      child = Image.network(
        url,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (context, widget, loadingProgress) {
          if (loadingProgress == null) return widget;
          return const _Shimmer();
        },
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(icon: placeholderIcon, iconSize: iconSize),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

/// 웹 `<img>` 렌더링. 받는 동안에는 배경색을 깔고, 실패하면 [placeholder]로 바꾼다.
class _WebImage extends StatefulWidget {
  const _WebImage({
    required this.url,
    required this.objectFit,
    required this.placeholder,
  });

  final String url;
  final String objectFit;
  final Widget placeholder;

  @override
  State<_WebImage> createState() => _WebImageState();
}

class _WebImageState extends State<_WebImage> {
  bool _failed = false;

  @override
  void didUpdateWidget(_WebImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _failed = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.placeholder;
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: HtmlElementView.fromTagName(
        // Images are display content; the surrounding Flutter button owns input.
        hitTestBehavior: PlatformViewHitTestBehavior.transparent,
        // url이 바뀌면 새 <img>를 만들어 이전 오류 리스너가 남지 않게 한다.
        key: ValueKey(widget.url),
        tagName: 'img',
        onElementCreated: (element) => configureWebImageElement(
          element,
          url: widget.url,
          objectFit: widget.objectFit,
          onError: () {
            if (mounted) setState(() => _failed = true);
          },
        ),
      ),
    );
  }
}

class AppNetworkImagePlaceholderScope extends InheritedWidget {
  const AppNetworkImagePlaceholderScope({required super.child, super.key});

  static bool maybeOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<
              AppNetworkImagePlaceholderScope
            >() !=
        null;
  }

  @override
  bool updateShouldNotify(AppNetworkImagePlaceholderScope oldWidget) => false;
}

class _Shimmer extends StatefulWidget {
  const _Shimmer();

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => ColoredBox(
        color: Color.lerp(
          AppColors.surfaceMuted,
          const Color(0xFFE2E8F0),
          _animation.value,
        )!,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.iconSize});

  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Center(
        child: Icon(icon, size: iconSize, color: AppColors.textTertiary),
      ),
    );
  }
}
