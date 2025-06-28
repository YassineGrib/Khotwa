import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Performance optimization utilities for the Khatwa app
class PerformanceUtils {
  /// Optimized image loading with caching and error handling
  static Widget buildOptimizedImage({
    required String assetPath,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: width?.round(),
      cacheHeight: height?.round(),
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },
    );
  }

  /// Optimized CircleAvatar with better performance
  static Widget buildOptimizedAvatar({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    double radius = 20,
    TextStyle? textStyle,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        text.isNotEmpty ? text.substring(0, 1).toUpperCase() : '?',
        style:
            textStyle?.copyWith(color: textColor) ??
            TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: radius * 0.6,
            ),
      ),
    );
  }

  /// Debounced function execution to prevent excessive calls
  static void debounce(
    String key,
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    _debounceTimers[key]?.cancel();
    _debounceTimers[key] = Timer(delay, callback);
  }

  static final Map<String, Timer> _debounceTimers = {};

  /// Optimized list builder with better performance
  static Widget buildOptimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      padding: padding,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      // Optimize for performance
      cacheExtent: 250.0, // Cache items outside viewport
      addAutomaticKeepAlives: false, // Don't keep items alive unnecessarily
      addRepaintBoundaries: true, // Isolate repaints
    );
  }

  /// Optimized grid builder with better performance
  static Widget buildOptimizedGridView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    required SliverGridDelegate gridDelegate,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return GridView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      gridDelegate: gridDelegate,
      padding: padding,
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      // Optimize for performance
      cacheExtent: 250.0,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
    );
  }

  /// Memory-efficient container with optimized decorations
  static Widget buildOptimizedContainer({
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    Decoration? decoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    AlignmentGeometry? alignment,
  }) {
    return RepaintBoundary(
      child: Container(
        padding: padding,
        margin: margin,
        color: color,
        decoration: decoration,
        width: width,
        height: height,
        constraints: constraints,
        alignment: alignment,
        child: child,
      ),
    );
  }

  /// Optimized card widget with better performance
  static Widget buildOptimizedCard({
    required Widget child,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    VoidCallback? onTap,
  }) {
    Widget card = Card(
      margin: margin,
      color: color,
      elevation: elevation ?? 2,
      shape: shape,
      child: padding != null ? Padding(padding: padding, child: child) : child,
    );

    if (onTap != null) {
      return RepaintBoundary(
        child: InkWell(
          onTap: onTap,
          borderRadius: shape is RoundedRectangleBorder
              ? shape.borderRadius as BorderRadius?
              : BorderRadius.circular(4),
          child: card,
        ),
      );
    }

    return RepaintBoundary(child: card);
  }

  /// Reduce widget rebuilds by using const constructors where possible
  static const Widget optimizedSizedBox = SizedBox.shrink();

  static Widget optimizedSpacer({double? width, double? height}) {
    if (width != null && height != null) {
      return SizedBox(width: width, height: height);
    } else if (width != null) {
      return SizedBox(width: width);
    } else if (height != null) {
      return SizedBox(height: height);
    }
    return const SizedBox.shrink();
  }

  /// Dispose resources properly
  static void dispose() {
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  /// Haptic feedback optimization
  static void optimizedHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  /// Memory usage optimization for large lists
  static const int defaultCacheExtent = 250;
  static const int maxCacheExtent = 500;

  /// Check if device has sufficient memory for heavy operations
  static bool get canHandleHeavyOperations {
    // Simple heuristic - in a real app, you might check actual memory
    return true; // For now, assume all devices can handle operations
  }
}
