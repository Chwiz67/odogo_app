import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/controllers/driver_controller.dart';
import 'package:odogo_app/repositories/driver_repository.dart';

// Create a fake database muscle
class MockDriverRepository extends Mock implements DriverRepository {}

void main() {
  late MockDriverRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockDriverRepository();
    container = ProviderContainer(
      overrides: [
        // 1. Force the app to use our fake repository
        driverRepositoryProvider.overrideWithValue(mockRepo),
        // 2. Initialize our modern Notifier for testing
        driverStatusProvider.overrideWith(() => DriverStatusController()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('toggleStatus switches from Offline to Online and saves to database', () async {
    const testUid = 'driver_123';
    const wasOnline = false; // Starting state

    // 1. Program the fake database to succeed when asked to go online
    when(() => mockRepo.updateOnlineStatus(testUid, true))
        .thenAnswer((_) async {});

    final controller = container.read(driverStatusProvider.notifier);

    // 2. ACT: Press the toggle button
    await controller.toggleStatus(testUid, wasOnline);

    // 3. ASSERT: Did it tell the database to save `true`?
    verify(() => mockRepo.updateOnlineStatus(testUid, true)).called(1);
    
    // 4. ASSERT: Did the UI state update to `true`?
    expect(container.read(driverStatusProvider), const AsyncValue.data(true));
  });
}