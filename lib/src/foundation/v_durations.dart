/// Motion durations shared by Vistality UI components.
class VDurations {
  const VDurations._();

  /// Quick feedback such as presses and toggles.
  static const Duration fast = Duration(milliseconds: 120);

  /// Default transition for most components.
  static const Duration normal = Duration(milliseconds: 200);

  /// Slower transition for larger surfaces.
  static const Duration slow = Duration(milliseconds: 320);
}
