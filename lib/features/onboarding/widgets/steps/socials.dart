import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sociocube/core/services/graphql/queries/user.graphql.dart';
import 'package:sociocube/core/widgets/input/input.dart';
import '../../../../core/providers/user.dart';
import '../../../../core/services/graphql/graphql_service.dart';
import '../base_step.dart';

// ignore: must_be_immutable
class SocialsStep extends BaseOnboardingStep {
  TextEditingController? _instagramUsername;
  SocialsStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Let's connect your socials",
         subtitle: 'Connect your instagram account to verify your identity.',
       );

  @override
  Future<bool?> handleNext(WidgetRef ref) async {
    final user = ref.watch(userProvider);
    if (user.value?.user?.instagramStats?.username ==
        _instagramUsername?.text) {
      return false;
    }
    final client = ref.read(graphqlServiceProvider.notifier);
    if (_instagramUsername == null) return false;

    final result = await client.mutate(
      MutationOptions(
        document: documentNodeMutationUpdateInstagramUsername,
        variables: Variables$Mutation$UpdateInstagramUsername(
          username: _instagramUsername!.text,
        ).toJson(),
      ),
    );
    if (result.data != null) {
      final response = Mutation$UpdateInstagramUsername.fromJson(result.data!);
      ref.read(userProvider.notifier).updateUser({
        ...response.updateInstagramUsername.toJson(),
        'instagramStats': Query$GetCurrentUser$user$instagramStats(
          username: _instagramUsername!.text,
          isVerified: true,
        ).toJson(),
      }, skipMutation: true);
    }
    return true;
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final instagramUsernameController = useTextEditingController(
      text: user.value?.user?.instagramStats?.username ?? '',
    );
    final isNextEnabled = useState(instagramUsernameController.text.isNotEmpty);
    _instagramUsername = instagramUsernameController;

    return (
      Column(
        spacing: 14,
        children: [
          Input(
            label: 'Instagram Username',
            hint: 'Enter your instagram username',
            controller: instagramUsernameController,
            onChanged: (value) {
              isNextEnabled.value = value?.isNotEmpty ?? false;
            },
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
