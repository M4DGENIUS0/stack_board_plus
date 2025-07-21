import 'package:flutter/material.dart';
import 'package:stack_board_plus/helpers.dart';

/// * case style
@immutable
class CaseStyle {
  const CaseStyle({
    this.buttonBgColor = Colors.white,
    this.buttonBorderColor = Colors.grey,
    this.buttonBorderWidth = 1,
    this.buttonIconColor = Colors.grey,
    this.buttonSize = 24,
    this.boxAspectRatio,
    this.frameBorderColor = Colors.purple,
    this.frameBorderWidth = 2,
  });

  factory CaseStyle.fromJson(final Map<String, dynamic> json) {
    final Color? buttonBgColor = asNullT<Color>(json['buttonBgColor']);
    final Color? buttonBorderColor = asNullT<Color>(json['buttonBorderColor']);
    final double? buttonBorderWidth =
        asNullT<double>(json['buttonBorderWidth']);
    final Color? buttonIconColor = asNullT<Color>(json['buttonIconColor']);
    final double? buttonSize = asNullT<double>(json['buttonSize']);
    final double? boxAspectRatio = asNullT<double>(json['boxAspectRatio']);
    final Color? frameBorderColor = asNullT<Color>(json['frameBorderColor']);
    final double? frameBorderWidth = asNullT<double>(json['frameBorderWidth']);

    return CaseStyle(
      buttonBgColor: buttonBgColor ?? Colors.white,
      buttonBorderColor: buttonBorderColor ?? Colors.grey,
      buttonBorderWidth: buttonBorderWidth ?? 1,
      buttonIconColor: buttonIconColor ?? Colors.grey,
      buttonSize: buttonSize ?? 24,
      boxAspectRatio: boxAspectRatio,
      frameBorderColor: frameBorderColor ?? Colors.purple,
      frameBorderWidth: frameBorderWidth ?? 2,
    );
  }

  /// * Background color
  final Color buttonBgColor;

  /// * Border color
  final Color buttonBorderColor;

  /// * Border thickness
  final double buttonBorderWidth;

  /// * Icon color
  final Color buttonIconColor;

  /// * Button size
  final double buttonSize;

  /// * Frame border color
  final Color frameBorderColor;

  /// * Frame border thickness
  final double frameBorderWidth;

  /// * if(boxAspectRatio!=null) 
  /// * Border ratio
  /// * if(boxAspectRatio!=null) Scaling transformation will fix the ratio
  // * `TODO`: transform this parameter to a boolean disabling the resizeX and resizeY handles
  final double? boxAspectRatio;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bgColor': buttonBgColor,
        'buttonBorderColor': buttonBorderColor,
        'buttonBorderWidth': buttonBorderWidth,
        'buttonIconColor': buttonIconColor,
        'buttonSize': buttonSize,
        'boxAspectRatio': boxAspectRatio,
        'frameBorderColor': frameBorderColor,
        'frameBorderWidth': frameBorderWidth,
      };

  @override
  int get hashCode => Object.hash(
      buttonBgColor,
      buttonBorderColor,
      buttonBorderWidth,
      buttonIconColor,
      buttonSize,
      boxAspectRatio,
      frameBorderColor,
      frameBorderWidth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseStyle &&
          runtimeType == other.runtimeType &&
          buttonBgColor == other.buttonBgColor &&
          buttonBorderColor == other.buttonBorderColor &&
          buttonBorderWidth == other.buttonBorderWidth &&
          buttonIconColor == other.buttonIconColor &&
          buttonSize == other.buttonSize &&
          boxAspectRatio == other.boxAspectRatio &&
          frameBorderColor == other.frameBorderColor &&
          frameBorderWidth == other.frameBorderWidth;
}
