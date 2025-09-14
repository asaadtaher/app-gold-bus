import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppPageTransitions {
  // Slide transition from right
  static PageTransition slideFromRight(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Slide transition from left
  static PageTransition slideFromLeft(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.leftToRight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Slide transition from bottom
  static PageTransition slideFromBottom(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.bottomToTop,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Fade transition
  static PageTransition fadeTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
  
  // Scale transition
  static PageTransition scaleTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.scale,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Rotate transition
  static PageTransition rotateTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.rotate,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  
  // Size transition
  static PageTransition sizeTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.size,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }
  
  // Right to left with fade
  static PageTransition rightToLeftWithFade(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.rightToLeftWithFade,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Left to right with fade
  static PageTransition leftToRightWithFade(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.leftToRightWithFade,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Custom transition for map screen
  static PageTransition mapTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.scale,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
  
  // Custom transition for forms
  static PageTransition formTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.rightToLeft,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
  
  // Custom transition for dialogs
  static PageTransition dialogTransition(Widget page) {
    return PageTransition(
      child: page,
      type: PageTransitionType.scale,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
