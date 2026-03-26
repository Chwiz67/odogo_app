import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odogo_app/controllers/chat_controller.dart';
import 'package:odogo_app/repositories/chat_repository.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late MockChatRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockChatRepository();
    container = ProviderContainer(
      overrides: [
        chatRepositoryProvider.overrideWithValue(mockRepo),
        chatControllerProvider.overrideWith(() => ChatController()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('sendMessage formats data correctly and updates state to success', () async {
    const testRideId = 'ride_123';
    const testSenderId = 'driver_456';
    const testText = 'I have arrived at the pickup location.';

    // 1. Program the fake database to succeed
    // We use `any()` here because the FieldValue.serverTimestamp() creates a unique object 
    // that is hard to strictly match in a test.
    when(() => mockRepo.sendMessage(testRideId, any()))
        .thenAnswer((_) async {});

    final controller = container.read(chatControllerProvider.notifier);

    // 2. ACT: Try to send a message
    await controller.sendMessage(
      rideId: testRideId,
      senderId: testSenderId,
      text: testText,
    );

    // 3. ASSERT: Did it tell the repository to send the message?
    verify(() => mockRepo.sendMessage(testRideId, any())).called(1);
    
    // 4. ASSERT: Did the state return to idle/data so the user can send again?
    expect(container.read(chatControllerProvider), const AsyncValue<void>.data(null));
  });

  test('sendMessage handles failure and emits AsyncError', () async {
    // Program the database to fail
    final testError = Exception('No Internet');
    when(() => mockRepo.sendMessage(any(), any())).thenThrow(testError);

    final controller = container.read(chatControllerProvider.notifier);

    // ACT
    await controller.sendMessage(
      rideId: 'ride_123',
      senderId: 'user_1',
      text: 'Hello?',
    );

    // ASSERT
    final state = container.read(chatControllerProvider);
    expect(state is AsyncError, true);
    expect(state.error, testError);
  });
}