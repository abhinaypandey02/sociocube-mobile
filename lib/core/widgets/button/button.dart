import 'package:flutter/material.dart';
import '../../theme/app_gradients.dart';
import '../text.dart';
import 'button_variant.dart';

export 'button_variant.dart';

class Button extends StatelessWidget {
  final Widget child;
  final ButtonVariant variant;
  final bool invert;
  final bool borderless;
  final bool square;
  final bool compact;
  final bool loading;
  final bool disabled;
  final VoidCallback? onPressed;

  const Button({
    super.key,
    required this.child,
    this.variant = ButtonVariant.primary,
    this.invert = false,
    this.borderless = false,
    this.square = false,
    this.compact = false,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final themeGradients = Theme.of(context).extension<AppGradients>()!;
    final variantStyle = getVariantStyle(variant, themeGradients);

    final gradient = variantStyle.gradient;
    final textColor = variantStyle.textColor;
    final bool isDisabled = disabled || loading;

    return Material(
      borderRadius: BorderRadius.circular(compact ? 10 : 14),
      elevation: borderless || loading || disabled ? 0 : 3,
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(compact ? 10 : 14),
        splashColor: (invert ? textColor : Colors.white).withOpacity(0.2),
        child: Opacity(
          opacity: isDisabled ? 0.8 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: square
                ? const EdgeInsets.all(8)
                : compact
                ? const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                : const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(compact ? 10 : 14),
              gradient: !invert && !borderless ? gradient : null,
              color: invert ? Colors.transparent : null,
              border: borderless || !invert
                  ? null
                  : Border.all(color: textColor, width: 1),
            ),
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: invert ? textColor : Colors.white,
                fontWeight: FontWeight.w200,
                fontVariations: getVariations(Size.medium, 600),
                fontSize: 16,
                height: 1,
              ),
              child: Center(
                child: loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            invert ? textColor : Colors.white,
                          ),
                        ),
                      )
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
