import 'package:flutter/material.dart';
import 'package:re_view_front/shared/widgets/error_view.dart';
import 'package:re_view_front/shared/widgets/loading_view.dart';

/// 화면 라이브러리를 한 번 불러온 뒤에만 진입 위젯을 만든다.
class DeferredPage extends StatefulWidget {
  const DeferredPage({
    required this.loadLibrary,
    required this.builder,
    super.key,
  });

  final Future<void> Function() loadLibrary;
  final WidgetBuilder builder;

  @override
  State<DeferredPage> createState() => _DeferredPageState();
}

class _DeferredPageState extends State<DeferredPage> {
  late Future<void> _loading = Future<void>.sync(widget.loadLibrary);

  @override
  void didUpdateWidget(DeferredPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadLibrary != widget.loadLibrary) {
      _loading = Future<void>.sync(widget.loadLibrary);
    }
  }

  void _retry() {
    setState(() => _loading = Future<void>.sync(widget.loadLibrary));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loading,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const AppLoadingView();
        }
        if (snapshot.hasError) {
          return AppErrorView(
            message: '화면을 불러오지 못했습니다. 다시 시도해 주세요.',
            onRetry: _retry,
          );
        }
        return widget.builder(context);
      },
    );
  }
}
