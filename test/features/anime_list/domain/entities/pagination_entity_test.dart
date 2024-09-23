import 'package:flutter_test/flutter_test.dart';
import 'package:mikrogrup/features/anime_list/domain/entities/pagination.dart';

void main() {
  group('Pagination Entity', () {
    // Sayfalama detaylarını temsil eden örnek JSON verisi
    // Example JSON data representing pagination details

    final jsonData = {
      'current_page': 1,
      'last_visible_page': 10,
      'has_next_page': true,
      'items': {
        'count': 25,
        'total': 250,
        'per_page': 25,
      },
    };

    // Test: Pagination entity, JSON verisinden doğru şekilde oluşturulmalıdır.
    // Test: Pagination entity should be correctly created from JSON data.
    test('Pagination entity JSON verisinden doğru şekilde oluşturulmalı', () {
      final pagination = Pagination(
        currentPage: jsonData['current_page'] as int,
        lastVisiblePage: jsonData['last_visible_page'] as int,
        hasNextPage: jsonData['has_next_page'] as bool,
        itemCount:
            ((jsonData['items'] as Map<String, dynamic>?)?['count'] as int?) ??
                0,
        totalItems:
            ((jsonData['items'] as Map<String, dynamic>?)?['total'] as int?) ??
                0,
        itemsPerPage: ((jsonData['items'] as Map<String, dynamic>?)?['per_page']
                as int?) ??
            0,
      );

      // Pagination nesnesinin doğru oluşturulduğunu doğrulamak için doğrulamalar
      // Assertions to verify the correctness of the Pagination object creation

      expect(pagination.currentPage, 1);
      expect(pagination.lastVisiblePage, 10);
      expect(pagination.hasNextPage, true);
      expect(pagination.itemCount, 25);
      expect(pagination.totalItems, 250);
      expect(pagination.itemsPerPage, 25);
    });
  });
}
