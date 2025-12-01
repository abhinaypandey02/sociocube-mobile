import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../input/input.dart';

class SelectorOption {
  final String id;
  final String value;

  const SelectorOption({required this.id, required this.value});
}

class Selector extends StatelessWidget {
  final String? hint;
  final String? label;
  final List<SelectorOption> options;
  final void Function(SelectorOption)? onSelected;
  final void Function(String?)? onChanged;
  final Color variantColor;

  const Selector({
    super.key,
    this.hint,
    this.label,
    required this.options,
    this.onSelected,
    this.onChanged,
    this.variantColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<SelectorOption>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return options.take(20);
        }
        return options.where((SelectorOption option) {
          return option.value.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          );
        });
      },
      displayStringForOption: (SelectorOption option) => option.value,
      onSelected: (SelectorOption selection) {
        if (onSelected != null) {
          onSelected!(selection);
        }
        if (onChanged != null) {
          onChanged!(selection.value);
        }
      },
      optionsViewBuilder:
          (
            BuildContext context,
            AutocompleteOnSelected<SelectorOption> onSelected,
            Iterable<SelectorOption> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 210),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final SelectorOption option = options.elementAt(index);
                        final bool isHighlighted =
                            AutocompleteHighlightedOption.of(context) == index;
                        final bool isLast = index == options.length - 1;
                        return InkWell(
                          onTap: () {
                            onSelected(option);
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isHighlighted
                                  ? Colors.grey[100]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: isLast
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                            ),
                            child: Text(
                              option.value,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 16,
                                fontWeight: isHighlighted
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            return Input(
              label: label,
              hint: hint,
              controller: textEditingController,
              focusNode: focusNode,
              variantColor: variantColor,
              onChanged: onChanged,
            );
          },
    );
  }
}
