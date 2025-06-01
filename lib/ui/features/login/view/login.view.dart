import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/users.repository.dart';
import '../../../../utils/constants_utils/app_strings.constants.dart';
import '../../../../utils/validation_utils.dart';
import '../../../core/shared_widgets/custom_elevated_button.widget.dart';
import '../../../core/shared_widgets/custom_textfield_with_label.widget.dart';
import '../../../core/shared_widgets/language_switcher_button.widget.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/login.viewmodel.dart';
import '../../../core/shared_widgets/logo.widget.dart';
import '../../../core/shared_widgets/powered_by_store.widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final locale = context.locale;
        final usersRepo = context.read<UsersRepository>();
        return LoginViewModel(usersRepo: usersRepo, locale: locale);
      },
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.only(
              left: AppTheme.pagePadding,
              right: AppTheme.pagePadding,
              bottom: AppTheme.pagePadding,
              top: (MediaQuery.of(context).padding.top + AppTheme.pagePadding),
            ),
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: FocusManager.instance.primaryFocus?.unfocus,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CHANGE LANGUAGE BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [LanguageSwitcher()],
                      ),
                      // LOGIN FORM
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 40.0,
                          children: [
                            // APP LOGO
                            AppLogoWidget(),
                            // FORM [USERNAME & PASSWORD]
                            Form(
                              key: viewModel.formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 18.0,
                                children: [
                                  CustomTextFieldColumn(
                                    label: AppStrings.username.tr(),
                                    controller: viewModel.usernameController,
                                    validator:
                                        (val) =>
                                            ValidationUtils.validateUsername(
                                              val?.trim(),
                                            ),
                                    hintText: AppStrings.enterUsername.tr(),
                                  ),
                                  CustomTextFieldColumn(
                                    label: AppStrings.password.tr(),
                                    controller: viewModel.passwordController,
                                    validator: ValidationUtils.validatePassword,
                                    hintText: AppStrings.password.tr(),
                                    isPassword: true,
                                  ),
                                ],
                              ),
                            ),
                            // LOGIN BUTTON
                            CustomElevatedButton(
                              isPrimaryBackground: false,
                              title: AppStrings.login.tr(),
                              width: MediaQuery.sizeOf(context).width,
                              height: 48.0,
                              radius: AppTheme.inputBorderRadius,
                              onPressed: () async => viewModel.login(),
                            ),
                          ],
                        ),
                      ),
                      // Powered by Store.
                      PoweredByStoreWidget(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
