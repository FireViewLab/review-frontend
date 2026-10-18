import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

/// Keeps window focus traversal outside the app until its first layout is ready.
class StartupFocusScope extends StatefulWidget {
  const StartupFocusScope({super.key, required this.child});

  final Widget child;

  @override
  State<StartupFocusScope> createState() => _StartupFocusScopeState();
}

class _StartupFocusScopeState extends State<StartupFocusScope>
    with WidgetsBindingObserver {
  final _scope = FocusScopeNode(canRequestFocus: false);
  bool _laidOut = false;
  ui.ViewFocusDirection? _pendingDirection;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _laidOut = true;
      _scope.canRequestFocus = true;
      _restoreDirectionalFocus();
    });
  }

  void _restoreDirectionalFocus() {
    final direction = _pendingDirection;
    _pendingDirection = null;
    final policy = ReadingOrderTraversalPolicy();
    switch (direction) {
      case ui.ViewFocusDirection.forward:
        policy.findFirstFocus(_scope, ignoreCurrentFocus: true)?.requestFocus();
      case ui.ViewFocusDirection.backward:
        policy.findLastFocus(_scope, ignoreCurrentFocus: true).requestFocus();
      case ui.ViewFocusDirection.undefined:
      case null:
        break;
    }
  }

  @override
  void didChangeViewFocus(ui.ViewFocusEvent event) {
    if (event.viewId != View.of(context).viewId) return;
    _pendingDirection = event.state == ui.ViewFocusState.focused
        ? event.direction
        : null;
    if (!_laidOut || _pendingDirection == null) return;
    // The outer View sees one scope. Enter this scope in the requested direction
    // after layout, including when the browser returns to an already open tab.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _restoreDirectionalFocus();
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scope.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FocusScope.withExternalFocusNode(
    focusScopeNode: _scope,
    includeSemantics: false,
    child: widget.child,
  );
}
