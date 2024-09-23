class Pagination {
  final int currentPage;
  final int lastVisiblePage;
  final bool hasNextPage;
  final int itemCount;
  final int totalItems;
  final int itemsPerPage;

  Pagination({
    required this.currentPage,
    required this.lastVisiblePage,
    required this.hasNextPage,
    required this.itemCount,
    required this.totalItems,
    required this.itemsPerPage,
  }) {
    assert(currentPage >= 0, 'Current page cannot be negative');
    assert(lastVisiblePage >= 0, 'Last visible page cannot be negative');
    assert(itemCount >= 0, 'Item count cannot be negative');
    assert(totalItems >= 0, 'Total items cannot be negative');
    assert(itemsPerPage > 0, 'Items per page must be greater than zero');
  }

  @override
  String toString() {
    return 'Pagination(currentPage: $currentPage, lastVisiblePage: $lastVisiblePage, '
        'hasNextPage: $hasNextPage, itemCount: $itemCount, totalItems: $totalItems, '
        'itemsPerPage: $itemsPerPage)';
  }
}
