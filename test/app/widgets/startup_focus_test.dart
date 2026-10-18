import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:re_view_front/app/widgets/startup_focus_scope.dart';

void main() {
  Widget subject(FocusNode outside) => StartupFocusScope(
    child: MaterialApp(
      // Like the assistant launcher, this control is outside the Navigator.
      builder: (_, child) => Row(
        children: [
          Expanded(child: child!),
          FocusTraversalGroup(
            child: TextButton(
              focusNode: outside,
              onPressed: () {},
              child: const Text('outside action'),
            ),
          ),
        ],
      ),
      home: Scaffold(
        body: TextButton(onPressed: () {}, child: const Text('content action')),
      ),
    ),
  );

  void mountBeforeLayout(WidgetTester tester, Widget child) {
    // Build the focus tree without laying out its Navigator, as during web startup.
    tester.binding.attachRootWidget(tester.binding.wrapWithDefaultView(child));
    tester.binding.buildOwner!.buildScope(tester.binding.rootElement!);
    FocusManager.instance.applyFocusChangesIfNeeded();
  }

  void sendFocus(
    WidgetTester tester,
    ui.ViewFocusDirection direction, {
    ui.ViewFocusState state = ui.ViewFocusState.focused,
  }) => tester.binding.handleViewFocusChanged(
    ui.ViewFocusEvent(
      viewId: tester.view.viewId,
      state: state,
      direction: direction,
    ),
  );

  for (final direction in [
    ui.ViewFocusDirection.forward,
    ui.ViewFocusDirection.backward,
  ]) {
    testWidgets('early $direction window focus waits for Navigator layout', (
      tester,
    ) async {
      final outside = FocusNode();
      addTearDown(outside.dispose);
      mountBeforeLayout(tester, subject(outside));
      sendFocus(tester, direction);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (direction == ui.ViewFocusDirection.backward) {
        expect(outside.hasFocus, isTrue);
      }
      // Normal focus traversal must still work after the startup boundary opens.
      outside.requestFocus();
      await tester.pump();
      expect(outside.hasFocus, isTrue);
      sendFocus(tester, ui.ViewFocusDirection.forward);
      await tester.pumpAndSettle();
      expect(outside.hasFocus, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('losing window focus cancels the queued startup focus', (
    tester,
  ) async {
    final outside = FocusNode();
    addTearDown(outside.dispose);
    mountBeforeLayout(tester, subject(outside));
    sendFocus(tester, ui.ViewFocusDirection.backward);
    sendFocus(
      tester,
      ui.ViewFocusDirection.undefined,
      state: ui.ViewFocusState.unfocused,
    );
    await tester.pumpAndSettle();
    expect(outside.hasFocus, isFalse);
    expect(tester.takeException(), isNull);
  });
}
