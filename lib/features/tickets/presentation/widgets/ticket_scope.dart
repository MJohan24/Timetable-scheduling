import 'package:flutter/widgets.dart';

import '../controllers/ticket_controller.dart';

class TicketScope extends InheritedNotifier<TicketController> {
  const TicketScope({
    super.key,
    required TicketController controller,
    required super.child,
  }) : super(notifier: controller);

  static TicketController of(BuildContext context, {bool listen = true}) {
    final scope = listen
        ? context.dependOnInheritedWidgetOfExactType<TicketScope>()
        : context.getInheritedWidgetOfExactType<TicketScope>();
    assert(scope != null, 'TicketScope is missing above this context.');
    return scope!.notifier!;
  }
}
