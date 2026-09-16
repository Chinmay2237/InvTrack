import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScannedItemEntry {
  final String barcode;
  final String? itemId;
  final String name;
  int quantity;

  ScannedItemEntry({
    required this.barcode,
    this.itemId,
    required this.name,
    this.quantity = 1,
  });
}

class ScanningState {
  final bool isBulkMode;
  final List<ScannedItemEntry> bulkQueue;
  final String? activeScannedBarcode;

  ScanningState({
    this.isBulkMode = false,
    this.bulkQueue = const [],
    this.activeScannedBarcode,
  });

  ScanningState copyWith({
    bool? isBulkMode,
    List<ScannedItemEntry>? bulkQueue,
    String? activeScannedBarcode,
  }) {
    return ScanningState(
      isBulkMode: isBulkMode ?? this.isBulkMode,
      bulkQueue: bulkQueue ?? this.bulkQueue,
      activeScannedBarcode: activeScannedBarcode,
    );
  }
}

class ScanningNotifier extends StateNotifier<ScanningState> {
  ScanningNotifier() : super(ScanningState());

  void toggleBulkMode() {
    state = state.copyWith(isBulkMode: !state.isBulkMode);
  }

  void setActiveBarcode(String code) {
    state = state.copyWith(activeScannedBarcode: code);
  }

  void addToBulkQueue(ScannedItemEntry entry) {
    final existingIndex =
        state.bulkQueue.indexWhere((e) => e.barcode == entry.barcode);
    if (existingIndex >= 0) {
      final updated = List<ScannedItemEntry>.from(state.bulkQueue);
      updated[existingIndex].quantity += entry.quantity;
      state = state.copyWith(bulkQueue: updated);
    } else {
      state = state.copyWith(bulkQueue: [...state.bulkQueue, entry]);
    }
  }

  void removeFromBulkQueue(int index) {
    final updated = List<ScannedItemEntry>.from(state.bulkQueue)
      ..removeAt(index);
    state = state.copyWith(bulkQueue: updated);
  }

  void clearBulkQueue() {
    state = state.copyWith(bulkQueue: []);
  }
}

final scanningProvider =
    StateNotifierProvider<ScanningNotifier, ScanningState>((ref) {
  return ScanningNotifier();
});
