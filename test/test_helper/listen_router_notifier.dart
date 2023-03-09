import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable_gorouter_with_riverpod/router/router_notifier.dart';

void listenRouterNotifier(ProviderContainer container) {
  container.listen(routerNotifierProvider, (previous, next) {
    container.read(routerNotifierProvider.notifier).routerListener?.call();
  });
}
