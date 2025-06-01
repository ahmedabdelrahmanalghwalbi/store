import 'package:flutter/material.dart';
import 'package:store/ui/features/favorites/view/favorites.view.dart';
import '../../products/view/products.view.dart';

class MainViewModel extends ChangeNotifier {
  MainViewModel();

  late final List<Widget> _pages = [
    const ProductsView(),
    const FavoritesView(),
  ];

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  Widget get currentPage => _pages[_selectedIndex];

  void changeIndex(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();
  }
}
