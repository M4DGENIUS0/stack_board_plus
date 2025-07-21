/// * StackItemStatus
/// * [editing] editing
/// * [moving] moving
/// * [scaling] scaling
/// * [roating] roating
/// * [selected] selected
/// * [idle] idle
enum StackItemStatus {
  /// * Editing
  editing,

  /// * Moving
  moving,

  /// * Scaling
  scaling,

  /// * Resizing (compressing or streching)
  resizing,

  /// * Rotating
  roating,

  /// * Selected
  selected,

  /// * Idle
  idle,

  /// * Locked
  locked,
}
