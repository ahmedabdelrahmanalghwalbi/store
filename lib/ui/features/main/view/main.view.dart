import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/main.viewmodel.dart';
import 'widgets/main_view_appbar.widget.dart';
import 'widgets/main_view_bottom_navigation_bar.widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppTheme.viewBackgroundColor,
            appBar: MainViewAppbarWidget(),
            body: viewModel.currentPage,
            bottomNavigationBar: MainViewBottomnavigationBarWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
