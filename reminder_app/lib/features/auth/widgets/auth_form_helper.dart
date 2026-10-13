import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';


class AuthValidators {
  AuthValidators._();

  static final RegExp _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email tidak boleh kosong';
    if (!_emailRegex.hasMatch(text)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final text = value ?? '';
    if (text.isEmpty) return 'Kata sandi tidak boleh kosong';
    if (text.length < minLength) {
      return 'Kata sandi minimal $minLength karakter';
    }
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final text = value ?? '';
    if (text.isEmpty) return 'Konfirmasi kata sandi tidak boleh kosong';
    if (text != original) return 'Kata sandi tidak sama';
    return null;
  }

  static int passwordStrength(String value) {
    if (value.isEmpty) return 0;
    var score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(value) && RegExp(r'[A-Z]').hasMatch(value)) {
      score++;
    }
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[^\w\s]').hasMatch(value)) score++;
    return score;
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBrand;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBrand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            'assets/logo_taskzilla.jpeg',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 64,
              height: 64,
              color: const Color(0xFFD1FAF4),
              child: const Icon(
                Icons.task_alt_rounded,
                color: AppColors.primaryTeal, //  AppColors.primaryTeal
                size: 34,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (showBrand) ...[
          const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Task ',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                  ), //  AppColors.textPrimary
                ),
                TextSpan(
                  text: 'Zilla',
                  style: TextStyle(
                    color: AppColors.primaryTeal,
                  ), //  AppColors.primaryTeal
                ),
              ],
            ),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary, //  AppColors.textPrimary
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.textSecondary, //  AppColors.textSecondary
          ),
        ),
      ],
    );
  }
}

class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool isPassword;
  final bool enabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? labelAction;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.labelAction,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(
      AppSizes.radiusDefault,
    ), //  AppSizes.radiusDefault
    borderSide: BorderSide(color: color),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary, // AppColors.textPrimary
                ),
              ),
            ),
            if (widget.labelAction != null) widget.labelAction!,
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ), //  AppColors.textPrimary
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ), //  AppColors.textSecondary
            filled: true,
            fillColor: AppColors.surface, //  AppColors.surface
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              size: 18,
              color: AppColors.textSecondary,
            ), // AppColors.textSecondary
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                      color: AppColors.textSecondary, // AppColors.textSecondary
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
            enabledBorder: _border(
              AppColors.borderLight,
            ), //  AppColors.borderLight
            disabledBorder: _border(
              AppColors.borderLight,
            ), //  AppColors.borderLight
            focusedBorder: _border(
              AppColors.primaryTeal,
            ), // AppColors.primaryTeal
            errorBorder: _border(AppColors.error), //  AppColors.error
            focusedErrorBorder: _border(
              AppColors.error,
            ), // [REFACTOR] AppColors.error
            errorStyle: const TextStyle(
              fontSize: 11,
              color: AppColors.error,
            ), // AppColors.error
          ),
        ),
      ],
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal, //  AppColors.primaryTeal
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              AppColors.primaryTeal, // AppColors.primaryTeal
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusDefault,
            ), //  AppSizes.radiusDefault
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}

class PasswordStrengthBar extends StatelessWidget {
  final String password;
  final int minLength;

  const PasswordStrengthBar({
    super.key,
    required this.password,
    this.minLength = 8,
  });

  @override
  Widget build(BuildContext context) {
    final score = AuthValidators.passwordStrength(password);
    final tooShort = password.length < minLength;

    final Color color;
    final String label;
    if (tooShort) {
      color = AppColors.error; // AppColors.error
      label = 'Minimal $minLength karakter';
    } else if (score <= 2) {
      color = AppColors.priorityHigh; // AppColors.priorityHigh
      label = 'Cukup';
    } else {
      color = AppColors.primaryTeal; //  AppColors.primaryTeal
      label = 'Kuat';
    }

    final progress = password.isEmpty ? 0.0 : (score.clamp(1, 4)) / 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: AppColors.borderLight, // -> AppColors.borderLight
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: password.isEmpty
                ? AppColors.textSecondary
                : color, // AppColors.textSecondary
          ),
        ),
      ],
    );
  }
}
