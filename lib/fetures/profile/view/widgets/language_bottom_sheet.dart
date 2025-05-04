import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/fetures/profile/manager/language/change_language_cubit.dart';
import 'package:sehetna/generated/l10n.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeLanguageCubit, ChangeLanguageState>(
      listener: (context, state) {
        if (state is ChangeLanguageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).languageChangedFailed)),
          );
        }
      },
      builder: (context, state) {
        final currentLanguage = state is ChangeLanguageInitial
            ? state.currentLanguage
            : (state is ChangeLanguageSuccess ? state.languageCode : 'en');

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageTile(
              context,
              languageCode: 'en',
              languageName: 'English',
              isSelected: currentLanguage == 'en',
              isLoading:
                  state is ChangeLanguageLoading && currentLanguage != 'en',
            ),
            _buildLanguageTile(
              context,
              languageCode: 'ar',
              languageName: 'العربية',
              isSelected: currentLanguage == 'ar',
              isLoading:
                  state is ChangeLanguageLoading && currentLanguage != 'ar',
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required String languageCode,
    required String languageName,
    required bool isSelected,
    required bool isLoading,
  }) {
    return ListTile(
      leading: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.language),
      title: Text(
        languageName,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).primaryColor : Colors.black,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check) : null,
      onTap: isSelected
          ? null
          : () =>
              context.read<ChangeLanguageCubit>().changeLanguage(languageCode),
    );
  }
}
