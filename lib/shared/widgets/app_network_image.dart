import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:re_view_front/app/theme/app_colors.dart';
import 'package:re_view_front/core/platform/web_image_element.dart';
import 'package:re_view_front/core/utils/product_image_urls.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholderIcon = Icons.image_outlined,
    this.iconSize = 28.0,
    this.borderRadius,
    this.thumbnailWidth,
    super.key,
  });

  final String url;

  /// 목록 카드처럼 작게 보이는 곳에서 받을 이미지 가로 픽셀. 지정하면 쇼핑몰 CDN의
  /// 축소 주소를 먼저 받고, 실패하면 원본 [url]로 다시 시도한다.
  final int? thumbnailWidth;
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

  String? get _cssBorderRadius {
    final radius = borderRadius;
    if (radius == null) return null;
    return '${radius.topLeft.x}px ${radius.topRight.x}px '
        '${radius.bottomRight.x}px ${radius.bottomLeft.x}px';
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    final usePlaceholder = AppNetworkImagePlaceholderScope.maybeOf(context);

    if (url.isEmpty || usePlaceholder) {
      child = _Placeholder(icon: placeholderIcon, iconSize: iconSize);
    } else if (kIsWeb) {
      // HtmlElementView로 <img> 태그 직접 렌더링 → 외부 CDN 이미지 CORS 우회
      final width = thumbnailWidth;
      child = _WebImage(
        url: url,
        thumbnailUrl: width == null
            ? null
            : productThumbnailUrl(url, width: width),
        objectFit: _objectFit,
        cssBorderRadius: _cssBorderRadius,
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
    this.thumbnailUrl,
    this.cssBorderRadius,
  });

  final String url;
  final String? thumbnailUrl;
  final String objectFit;
  final String? cssBorderRadius;
  final Widget placeholder;

  @override
  State<_WebImage> createState() => _WebImageState();
}

class _WebImageState extends State<_WebImage> {
  bool _failed = false;
  bool _thumbnailFailed = false;

  @override
  void didUpdateWidget(_WebImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url ||
        oldWidget.thumbnailUrl != widget.thumbnailUrl) {
      _failed = false;
      _thumbnailFailed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) return widget.placeholder;
    final thumbnailUrl = widget.thumbnailUrl;
    final useThumbnail =
        thumbnailUrl != null && thumbnailUrl != widget.url && !_thumbnailFailed;
    final loadedUrl = useThumbnail ? thumbnailUrl : widget.url;
    return ClipRect(
      child: ColoredBox(
        color: AppColors.surfaceMuted,
        child: HtmlElementView.fromTagName(
          // Images are display content; Flutter owns card/chat/zoom input.
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          // Keep a DOM viewport separate from the image's intrinsic dimensions.
          key: ValueKey(loadedUrl),
          tagName: 'div',
          onElementCreated: (element) => configureWebImageElement(
            element,
            url: loadedUrl,
            objectFit: widget.objectFit,
            borderRadius: widget.cssBorderRadius,
            onError: () {
              if (!mounted) return;
              setState(() {
                // 축소 주소가 실패하면 원본으로 한 번 더 받는다.
                if (useThumbnail) {
                  _thumbnailFailed = true;
                } else {
                  _failed = true;
                }
              });
            },
          ),
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
