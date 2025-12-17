/// Alignment of the item within the viewport.
///
/// The [ItemAlignment] specifies the desired position for the leading edge of the
/// item. The [ItemAlignment] is expected to be a value in the range \[0.0, 1.0\]
class ItemAlignment {
  /// Aligns the leading edge of the item with the leading edge of the viewport.
  ///
  /// For a vertically scrolling view that is not reversed this means that the
  /// top edge of the item is aligned with the top edge of the view
  ///
  /// For a horizontally scrolling view that is not reversed this means that the
  /// left edge of the item is aligned with the left edge of the view
  static const double start = 0.0;

  /// Aligns the leading edge of the item with the center of the viewport.
  ///
  /// For a vertically scrolling view that is not reversed this means that the
  /// top edge of the item is aligned with the center of the view
  ///
  /// For a horizontally scrolling view that is not reversed this means that the
  /// left edge of the item is aligned with the center of the view
  static const double center = 0.5;

  /// Aligns the leading edge of the item with the trailing edge of the viewport.
  ///
  /// For a vertically scrolling view that is not reversed this means that the
  /// top edge of the item is aligned with the bottom of the view
  ///
  /// For a horizontally scrolling view that is not reversed this means that the
  /// left edge of the item is aligned with the right edge of the view
  static const double end = 1.0;

  // Prevent instantiation
  const ItemAlignment._();
}
