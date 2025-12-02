import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/services/graphql/graphql_service.dart';
import 'package:sociocube/core/services/graphql/queries/schema.graphql.dart';
import 'package:sociocube/core/services/graphql/queries/user.graphql.dart';
import 'package:sociocube/core/widgets/input/input.dart';
import '../base_step.dart';
import '../../providers/currency_provider.dart';

// ignore: must_be_immutable
class PricingStep extends BaseOnboardingStep {
  TextEditingController? _pricingController;

  PricingStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Set your pricing",
         subtitle: 'Let others know how much you charge for your services.',
       );

  @override
  Future<bool?> handleNext(WidgetRef ref) async {
    if (_pricingController == null || _pricingController!.text.isEmpty) {
      return false;
    }
    await ref
        .read(graphqlServiceProvider)
        .mutate(
          MutationOptions(
            document: documentNodeMutationUpdateUser,
            variables: Variables$Mutation$UpdateUser(
              updatedUser: Input$UpdateUserInput(
                pricing: Input$PricingInput(
                  starting: double.parse(_pricingController!.text),
                ),
              ),
            ).toJson(),
          ),
        );
    return true;
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final pricingController = useTextEditingController();
    final isNextEnabled = useState(false);
    final currency = ref.watch(onboardingCurrencyProvider);

    // Sync controller for handleNext
    _pricingController = pricingController;

    return (
      Column(
        children: [
          Input(
            prefixText: currency,
            label: 'Pricing',
            hint: 'Enter your pricing in $currency',
            controller: pricingController,
            onChanged: (value) {
              isNextEnabled.value = value?.isNotEmpty ?? false;
            },
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
