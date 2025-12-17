// Copyright 2019 The Fuchsia Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

const screenHeight = 400.0;
const screenWidth = 400.0;
const itemHeight = screenHeight / 10.0;
const defaultItemCount = 500;

void main() {
  Future<void> setUpWidgetTest(
    WidgetTester tester, {
    ItemScrollController? itemScrollController,
    ItemPositionsListener? itemPositionsListener,
    int initialIndex = 0,
    double initialAlignment = 0.0,
    int itemCount = defaultItemCount,
  }) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(screenWidth, screenHeight);

    await tester.pumpWidget(
      MaterialApp(
        home: ScrollablePositionedList.builder(
          itemCount: itemCount,
          itemScrollController: itemScrollController,
          itemBuilder: (context, index) {
            return SizedBox(
              height: itemHeight,
              child: Text('Item $index'),
            );
          },
          itemPositionsListener: itemPositionsListener,
          initialScrollIndex: initialIndex,
          initialAlignment: initialAlignment,
        ),
      ),
    );
  }

  testWidgets('jumpTo with offset', (WidgetTester tester) async {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();
    await setUpWidgetTest(
      tester,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );

    // Jump to index 10 with 0 offset (default)
    itemScrollController.jumpTo(index: 10);
    await tester.pump();

    // Item 10 should be at the top (leading edge 0)
    expect(tester.getTopLeft(find.text('Item 10')).dy, 0);

    // Jump to index 10 with 20 offset (shifts content up, so item starts at -20px)
    // -20px in a 400px screen is -0.05 alignment
    itemScrollController.jumpTo(index: 10, offset: 20);
    await tester.pump();

    expect(tester.getTopLeft(find.text('Item 10')).dy, -20);

    // Jump to index 10 with -20 offset (shifts content down, so item starts at 20px)
    // 20px in a 400px screen is 0.05 alignment
    itemScrollController.jumpTo(index: 10, offset: -20);
    await tester.pump();

    expect(tester.getTopLeft(find.text('Item 10')).dy, 20);
  });

  testWidgets('scrollTo with offset (short scroll)',
      (WidgetTester tester) async {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();
    await setUpWidgetTest(
      tester,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );

    // Scroll to index 5 with 20 offset
    unawaited(itemScrollController.scrollTo(
      index: 5,
      duration: const Duration(milliseconds: 100),
      offset: 20,
    ));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Item 5')).dy, -20);
  });

  testWidgets('scrollTo with offset (long scroll)',
      (WidgetTester tester) async {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();
    await setUpWidgetTest(
      tester,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );

    // Scroll to index 100 (far away) with 30 offset
    unawaited(itemScrollController.scrollTo(
      index: 100,
      duration: const Duration(milliseconds: 500),
      offset: 30,
    ));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.text('Item 100')).dy, -30);
  });

  testWidgets('jumpToFirst with offset', (WidgetTester tester) async {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();
    await setUpWidgetTest(
      tester,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      initialIndex: 10,
    );

    itemScrollController.jumpToFirst(offset: 20);
    await tester.pump();

    expect(tester.getTopLeft(find.text('Item 0')).dy, -20);
  });

  testWidgets('jumpToLast with offset', (WidgetTester tester) async {
    final itemScrollController = ItemScrollController();
    final itemPositionsListener = ItemPositionsListener.create();
    await setUpWidgetTest(
      tester,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
    );

    itemScrollController.jumpToLast(offset: -20);
    await tester.pump();

    expect(tester.getTopLeft(find.text('Item ${defaultItemCount - 1}')).dy, 20);
  });
}
