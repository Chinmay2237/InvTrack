import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:invtrack/features/handovers/domain/entities/handover_entity.dart';
import 'package:invtrack/features/handovers/domain/repositories/handover_repository.dart';
import 'package:invtrack/features/handovers/domain/usecases/create_handover_usecase.dart';

class MockHandoverRepository extends Mock implements HandoverRepository {}

void main() {
  late MockHandoverRepository mockRepository;
  late CreateHandoverUseCase useCase;

  setUp(() {
    mockRepository = MockHandoverRepository();
    useCase = CreateHandoverUseCase(mockRepository);
  });

  final testHandover = HandoverEntity(
    id: 'h_1',
    itemId: 'item_1',
    employeeId: 'E1',
    assignmentType: 'permanent',
    assignedDate: DateTime.now(),
  );

  test('CreateHandoverUseCase delegates call to HandoverRepository', () async {
    when(() => mockRepository.createHandover(testHandover))
        .thenAnswer((_) async => Future.value());

    await useCase.execute(testHandover);

    verify(() => mockRepository.createHandover(testHandover)).called(1);
  });
}
