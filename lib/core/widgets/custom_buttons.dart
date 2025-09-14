import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../animations/custom_animations.dart';

class AppButtons {
  // Primary button
  static Widget primary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    double? height,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsetsGeometry? padding,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.blue,
          foregroundColor: textColor ?? Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: isLoading
            ? AppAnimations.loadingAnimation(
                color: textColor ?? Colors.white,
                size: 20,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  // Secondary button
  static Widget secondary({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? textColor,
    double? width,
    double? height,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsetsGeometry? padding,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: OutlinedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? Colors.blue,
          side: BorderSide(color: textColor ?? Colors.blue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: isLoading
            ? AppAnimations.loadingAnimation(
                color: textColor ?? Colors.blue,
                size: 20,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  // Text button
  static Widget text({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Color? textColor,
    double? width,
    double? height,
    IconData? icon,
    EdgeInsetsGeometry? padding,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: TextButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: textColor ?? Colors.blue,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: isLoading
            ? AppAnimations.loadingAnimation(
                color: textColor ?? Colors.blue,
                size: 20,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  // Icon button
  static Widget icon({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? iconColor,
    double? size,
    double? width,
    double? height,
    double borderRadius = 8,
    EdgeInsetsGeometry? padding,
  }) {
    return SizedBox(
      width: width ?? 48,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.blue,
          foregroundColor: iconColor ?? Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding ?? const EdgeInsets.all(12),
        ),
        child: isLoading
            ? AppAnimations.loadingAnimation(
                color: iconColor ?? Colors.white,
                size: 20,
              )
            : Icon(icon, size: size ?? 20),
      ),
    );
  }
  
  // Floating action button
  static Widget floating({
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    Color? backgroundColor,
    Color? iconColor,
    double? size,
    String? tooltip,
  }) {
    return FloatingActionButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      backgroundColor: backgroundColor ?? Colors.blue,
      foregroundColor: iconColor ?? Colors.white,
      tooltip: tooltip,
      child: isLoading
          ? AppAnimations.loadingAnimation(
              color: iconColor ?? Colors.white,
              size: 20,
            )
          : Icon(icon, size: size ?? 24),
    );
  }
  
  // Google sign in button
  static Widget googleSignIn({
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height ?? 48,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        child: isLoading
            ? AppAnimations.loadingAnimation(
                color: Colors.black,
                size: 20,
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.google,
                    size: 18,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Sign in with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  
  // Delete button
  static Widget delete({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      width: width,
      height: height,
      icon: icon ?? Icons.delete,
    );
  }
  
  // Success button
  static Widget success({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      width: width,
      height: height,
      icon: icon ?? Icons.check,
    );
  }
  
  // Warning button
  static Widget warning({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      width: width,
      height: height,
      icon: icon ?? Icons.warning,
    );
  }
  
  // Info button
  static Widget info({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    double? width,
    double? height,
    IconData? icon,
  }) {
    return primary(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      isEnabled: isEnabled,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      width: width,
      height: height,
      icon: icon ?? Icons.info,
    );
  }
}
