import 'package:flutter/material.dart';
import 'package:re_view_front/l10n/generated/app_localizations.dart';
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
          // 화면 파일은 첫 진입 때 받으므로 실패는 대부분 연결 문제다.
          final l10n = AppLocalizations.of(context);
          return AppErrorView(
            title: l10n.failureTitleOffline,
            message: l10n.failureMessageOffline,
            onRetry: _retry,
          );
        }
        return widget.builder(context);
      },
    );
  }
}
