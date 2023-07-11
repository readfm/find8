import 'package:data8/index.dart';
import 'package:data8/providers/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchProvider = StateProvider((ref) => '');

final filteredEventsProvider = Provider<List<Event>>((ref) {
  final events = ref.watch(eventsProvider);
  final search = ref.watch(searchProvider);

  return search.isEmpty
      ? events
      : events.where((event) => event.content.contains(search)).toList();
});
