import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:invtrack/features/handovers/domain/repositories/handover_repository.dart';
import 'package:invtrack/features/handovers/domain/usecases/return_asset_usecase.dart';

class MockHandoverRepository extends Mock implements HandoverRepository {}

void main() {
  late MockHandoverRepository mockRepository;
  late ReturnAssetUseCase useCase;

  setUp(() {
    mockRepository = MockHandoverRepository();
    useCase = ReturnAssetUseCase(mockRepository);
  });

  test('ReturnAssetUseCase delegates returnAsset call to HandoverRepository', () async {
    final returnDate = DateTime.now();
    when(() => mockRepository.returnAsset('h_1', returnDate, notes: 'Returned safely'))
        .thenAnswer((_) async => Future.value());

    await useCase.execute('h_1', returnDate, notes: 'Returned safely');

    verify(() => mockRepository.returnAsset('h_1', returnDate, notes: 'Returned safely')).called(1);
  });
}
