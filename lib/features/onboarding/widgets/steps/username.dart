import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/widgets/input/input.dart';
import '../../../../core/providers/user.dart';
import '../base_step.dart';

// ignore: must_be_immutable
class UsernameStep extends BaseOnboardingStep {
  TextEditingController? _usernameController;
  ValueNotifier<String?>? _errorNotifier;

  UsernameStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Choose your username",
         subtitle: 'Pick a unique username for your profile',
       );

  @override
  Future<bool?> handleNext(WidgetRef ref) async {
    if (_usernameController == null || _usernameController!.text.isEmpty) {
      return false;
    }

    // Clear any previous errors
    _errorNotifier?.value = null;

    final result = await ref.read(userProvider.notifier).updateUser({
      'username': _usernameController!.text,
    });

    // If there's an error, set it and return false
    if (result != null) {
      _errorNotifier?.value = "This username is already taken :(";
      return false;
    }

    return true;
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final user = ref.watch(userProvider);
    final usernameController = useTextEditingController(
      text: user.value?.user?.username ?? '',
    );
    final isNextEnabled = useState(usernameController.text.isNotEmpty);
    final errorText = useState<String?>(null);

    _usernameController = usernameController;
    _errorNotifier = errorText;

    return (
      Column(
        spacing: 14,
        children: [
          Input(
            label: 'Username',
            hint: 'Enter your username',
            controller: usernameController,
            errorText: errorText.value,
            suffixText: ".sociocube.me",
            onChanged: (value) {
              // Clear error when user types
              if (errorText.value != null) {
                errorText.value = null;
              }
              isNextEnabled.value = value?.isNotEmpty ?? false;
            },
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
