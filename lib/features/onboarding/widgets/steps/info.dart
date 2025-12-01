import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sociocube/core/widgets/input/input.dart';
import '../../../../core/providers/user.dart';
import '../../../../core/utils/file_upload.dart';
import '../../../auth/providers/auth_provider.dart';
import '../base_step.dart';

// ignore: must_be_immutable
class InfoStep extends BaseOnboardingStep {
  TextEditingController? _fullNameController;
  TextEditingController? _bioController;
  InfoStep({
    super.key,
    required super.stepIndex,
    required super.updateStep,
    required super.onNext,
  }) : super(
         title: "Let's know you better",
         subtitle: 'Provide information about you so we can help you be found!',
       );

  @override
  Future<void> handleNext(WidgetRef ref) async {
    if (_fullNameController == null || _bioController == null) return;
    ref.read(userProvider.notifier).updateUser({
      'name': _fullNameController?.text,
      'bio': _bioController?.text,
    });
  }

  @override
  (Widget, ValueNotifier<bool>) buildStepContent(
    BuildContext context,
    WidgetRef ref,
  ) {
    final user = ref.watch(userProvider);
    final auth = ref.watch(authStateProvider);
    final fullNameController = useTextEditingController(
      text: user.value?.user?.name ?? '',
    );
    final bioController = useTextEditingController(
      text: user.value?.user?.bio ?? '',
    );
    final isNextEnabled = useState(fullNameController.text.isNotEmpty);
    final selectedImage = useState<XFile?>(null);
    final imagePicker = ImagePicker();

    Future<void> pickImage() async {
      try {
        final XFile? image = await imagePicker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );
        if (image != null) {
          final response = await uploadFile(
            file: image,
            token: auth.value?.accessToken ?? '',
            type: FileUploadType.profilePicture,
          );
          ref.read(userProvider.notifier).updateUser({'photo': response.url});
          selectedImage.value = image;
        }
      } catch (e) {
        // Handle error
        debugPrint('Error picking image: $e');
      }
    }

    return (
      Column(
        spacing: 14,
        children: [
          // Profile Image Selector
          Center(
            child: GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: selectedImage.value != null
                    ? ClipOval(
                        child: Image.file(
                          File(selectedImage.value!.path),
                          fit: BoxFit.cover,
                        ),
                      )
                    : user.value?.user?.photo != null
                    ? ClipOval(
                        child: Image.network(
                          user.value!.user!.photo!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey[600],
                      ),
              ),
            ),
          ),
          Input(
            label: 'Full name',
            hint: 'Enter your name',
            controller: fullNameController,
            onChanged: (value) {
              isNextEnabled.value = value?.isNotEmpty ?? false;
            },
          ),
          Input(
            label: 'Bio',
            hint: 'Enter your bio',
            controller: bioController,
            onChanged: (value) {
              isNextEnabled.value = value?.isNotEmpty ?? false;
            },
            maxLines: 3,
          ),
        ],
      ),
      isNextEnabled,
    );
  }
}
