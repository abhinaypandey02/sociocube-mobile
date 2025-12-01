import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sociocube/core/widgets/input/input.dart';
import 'package:sociocube/core/widgets/selector/selector.dart';
import '../../../../core/constants/options.dart';
import '../../../../core/providers/user.dart';
import '../base_step.dart';

// ignore: must_be_immutable
class NicheStep extends BaseOnboardingStep {
  String? _gender;
  List<String>? _categories;
  DateTime? _dateOfBirth;
  NicheStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "What's your niche?",
         subtitle:
             'Provide information about your niche to reach the right brands!',
       );

  @override
  Future<bool?> handleNext(WidgetRef ref) async {
    if (_gender == null || _categories == null || _categories!.isEmpty) return false;
    ref.read(userProvider.notifier).updateUser({
      'gender': _gender,
      'categories': _categories,
      if (_dateOfBirth != null) 'dob': _dateOfBirth!.toIso8601String(),
    });
    return true;
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final selectedGender = useState<String?>(null);
    final selectedCategories = useState<List<String>?>(null);
    final selectedDate = useState<DateTime?>(null);
    final dateOfBirthController = useTextEditingController();
    final isNextEnabled = useState(
      selectedGender.value != null &&
          selectedCategories.value != null &&
          selectedCategories.value!.isNotEmpty,
    );

    Future<void> selectDate() async {
      final DateTime eighteenYearsAgo = DateTime.now().subtract(
        const Duration(days: 365 * 18),
      );

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime(2000),
        firstDate: DateTime(1900),
        lastDate: eighteenYearsAgo,
      );

      if (picked != null) {
        selectedDate.value = picked;
        _dateOfBirth = picked;
        dateOfBirthController.text = DateFormat('MMM dd, yyyy').format(picked);
      }
    }

    useEffect(() {
      isNextEnabled.value =
          selectedDate.value != null &&
          selectedGender.value != null &&
          selectedCategories.value != null &&
          selectedCategories.value!.isNotEmpty;
      return null;
    }, [selectedGender.value, selectedCategories.value, selectedDate.value]);

    return (
      Column(
        spacing: 14,
        children: [
          Selector(
            label: 'Gender',
            hint: 'Select your gender',
            options: genders
                .map((e) => SelectorOption(id: e, value: e))
                .toList(),
            onSelected: (value) {
              selectedGender.value = value.value;
              _gender = value.value;
            },
          ),
          Selector(
            label: 'Categories',
            hint: 'Select your categories',
            options: categories
                .map((e) => SelectorOption(id: e, value: e))
                .toList(),
            onSelected: (value) {
              selectedCategories.value = [value.value];
              _categories = [value.value];
            },
          ),
          Input(
            label: 'Date of birth',
            hint: 'Select your date of birth',
            controller: dateOfBirthController,
            readOnly: true,
            onTap: selectDate,
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
