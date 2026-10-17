import 'package:equatable/equatable.dart';

import '../view/models/my_orders_tab.dart';

class MyOrdersState extends Equatable {
  const MyOrdersState({this.selectedTab = MyOrdersTab.active});

  final MyOrdersTab selectedTab;

  MyOrdersState copyWith({MyOrdersTab? selectedTab}) {
    return MyOrdersState(selectedTab: selectedTab ?? this.selectedTab);
  }

  @override
  List<Object?> get props => [selectedTab];
}
