import 'dart:async';

import 'package:flower_app/app/router/app_router.dart';
import 'package:flower_app/app/router/app_routes.dart';
import 'package:flower_app/core/constants/app_string.dart';
import 'package:flower_app/features/order/presentation/my_orders/view/widgets/my_orders_body.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_ui_event.dart';
import 'package:flower_app/features/order/presentation/my_orders/view_model/my_orders_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyOrdersListPage extends StatefulWidget {
  const MyOrdersListPage({super.key});

  @override
  State<MyOrdersListPage> createState() => _MyOrdersListPageState();
}

class _MyOrdersListPageState extends State<MyOrdersListPage>
    with RouteAware {
  StreamSubscription<MyOrdersUiEvent>? _uiEvents;
  Route? _route;

  @override
  void initState() {
    super.initState();
    _uiEvents = context
        .read<MyOrdersViewModel>()
        .uiEvents
        .listen(_onUiEvent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null && route != _route) {
      AppRouter.routeObserver.unsubscribe(this);
      _route = route;
      AppRouter.routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    context.read<MyOrdersViewModel>().onEvent(LoadMyOrders());
  }

  @override
  void dispose() {
    AppRouter.routeObserver.unsubscribe(this);
    _uiEvents?.cancel();
    super.dispose();
  }

  void _onUiEvent(MyOrdersUiEvent event) {
    switch (event) {
      case TrackMyOrder(:final orderId):
        if (!mounted) return;
        context.push(AppRoutesName.trackOrder, extra: orderId);
      case ShowErrorMessage(:final message):
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case Reorder():
      case RetryRequest():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppString.myOrders)),
      body: SafeArea(child: const MyOrdersBody()),
    );
  }
}
