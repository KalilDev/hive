import 'dart:async';

import 'package:hive/hive.dart';
import 'package:hive/src/box/change_notifier.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class StreamControllerMock<T> extends Mock implements StreamController<T> {}

void main() {
  group('ChangeNotifier', () {
    test('.watch()', () async {
      var notifier = ChangeNotifier();

      var allEvents = <BoxEvent>[];
      notifier.watch().listen((e) {
        allEvents.add(e);
      });

      var filteredEvents = <BoxEvent>[];
      notifier.watch(key: 'key1').listen((e) {
        filteredEvents.add(e);
      });

      notifier.notify('key1', null, true);
      notifier.notify('key1', 'newVal', false);
      notifier.notify('key2', 'newVal2', false);

      await Future.delayed(Duration(milliseconds: 1));

      expect(allEvents, [
        BoxEvent('key1', null, true),
        BoxEvent('key1', 'newVal', false),
        BoxEvent('key2', 'newVal2', false),
      ]);

      expect(filteredEvents, [
        BoxEvent('key1', null, true),
        BoxEvent('key1', 'newVal', false),
      ]);
    });

    test('close', () async {
      var controller = StreamControllerMock<BoxEvent>();
      when(controller.close()).thenAnswer((i) => Future.value());
      var notifier = ChangeNotifier.debug(controller);

      await notifier.close();
      verify(controller.close());
    });
  });
}