import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';
import '../../../../core/providers/user.dart';
import '../base_step.dart';
import '../role_selector.dart';

// ignore: must_be_immutable
class WelcomeStep extends BaseOnboardingStep {
  ValueNotifier<Enum$Roles?>? _selectedRole;
  WelcomeStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Let's get you onboarded",
         subtitle:
             'With some simple steps you can onboard to become a creator on Sociocube!',
       );

  @override
  Future<void> handleNext(WidgetRef ref) async {
    final user = ref.read(userProvider.notifier);
    user.updateUser({'role': _selectedRole?.value?.name});
  }

  @override
  Widget buildStepContent(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final selectedRole = useState<Enum$Roles?>(user.value?.user?.role);
    _selectedRole = selectedRole;
    useEffect(() {
      super.isNextEnabled = selectedRole.value != null;
      return null;
    }, [selectedRole.value]);

    return Column(
      spacing: 14,
      children: [
        Row(
          children: [
            Expanded(
              child: RoleSelector(
                isSelected: selectedRole.value == Enum$Roles.Creator,
                onSelect: () => selectedRole.value = Enum$Roles.Creator,
                title: 'Creator',
                subtitle: 'Create and share content with your audience',
              ),
            ),
          ],
        ),
        IntrinsicHeight(
          child: Row(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: RoleSelector(
                  isSelected: selectedRole.value == Enum$Roles.Brand,
                  onSelect: () => selectedRole.value = Enum$Roles.Brand,
                  title: 'Brand',
                  subtitle: 'Connect with creators to promote your brand',
                ),
              ),
              Expanded(
                child: RoleSelector(
                  isSelected: selectedRole.value == Enum$Roles.Agency,
                  onSelect: () => selectedRole.value = Enum$Roles.Agency,
                  title: 'Agency',
                  subtitle: 'Manage creators with professional tools',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
