import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/route/app_navigator.service.dart';
import '../../../../data/repositories/users.repository.dart';
import '../../../../utils/constants_utils/app_strings.constants.dart';
import '../../../../utils/validation_utils.dart';
import '../../../core/shared_widgets/custom_elevated_button.widget.dart';
import '../../../core/shared_widgets/custom_textfield_with_label.widget.dart';
import '../../../core/shared_widgets/language_switcher_button.widget.dart';
import '../../../core/shared_widgets/logo.widget.dart';
import '../../../core/shared_widgets/powered_by_store.widget.dart';
import '../../../core/themes/app_theme.dart';
import '../view_model/registeration.viewmodel.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final locale = context.locale;
        final usersRepo = context.read<UsersRepository>();
        return RegistrationViewModel(usersRepo: usersRepo, locale: locale);
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
              top: (MediaQuery.of(context).padding.top),
            ),
            child: Consumer<RegistrationViewModel>(
              builder: (context, viewModel, child) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: FocusManager.instance.primaryFocus?.unfocus,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CHANGE LANGUAGE BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: AppNavigator.goBack,
                            icon: Icon(
                              Icons.arrow_back_sharp,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          LanguageSwitcher(),
                        ],
                      ),
                      // APP LOGO
                      AppLogoWidget(),
                      // LOGIN FORM
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 40.0,
                          children: [
                            // FORM [USERNAME & PASSWORD]
                            Form(
                              key: viewModel.formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 18.0,
                                children: [
                                  // Username field
                                  CustomTextFieldColumn(
                                    label: 'username',
                                    controller: viewModel.usernameController,
                                    validator: ValidationUtils.validateUsername,
                                    hintText: 'username',
                                  ),

                                  // Email field
                                  CustomTextFieldColumn(
                                    label: AppStrings.email.tr(),
                                    controller: viewModel.emailController,
                                    validator: ValidationUtils.validateEmail,
                                    hintText: AppStrings.email.tr(),
                                  ),

                                  // Password field
                                  CustomTextFieldColumn(
                                    label: AppStrings.password.tr(),
                                    controller: viewModel.passwordController,
                                    validator: ValidationUtils.validatePassword,
                                    hintText: AppStrings.password.tr(),
                                    isPassword: true,
                                  ),

                                  // Confirm password field
                                  CustomTextFieldColumn(
                                    label: 'Confirm Password',
                                    controller:
                                        viewModel.confirmPasswordController,
                                    validator: viewModel.validatePasswordMatch,
                                    hintText: 'Confirm Password',
                                    isPassword: true,
                                  ),
                                ],
                              ),
                            ),
                            // Register button
                            CustomElevatedButton(
                              isPrimaryBackground: false,
                              title: 'Register',
                              width: MediaQuery.sizeOf(context).width,
                              height: 48.0,
                              radius: AppTheme.inputBorderRadius,
                              onPressed: viewModel.register,
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
