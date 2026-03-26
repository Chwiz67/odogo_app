import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/chat_repository.dart';

// 1. Provide the Repository
final chatRepositoryProvider = Provider((ref) => ChatRepository());

// 2. The Controller Provider (Manages the loading/error state of SENDING a message)
final chatControllerProvider = NotifierProvider<ChatController, AsyncValue<void>>(() {
  return ChatController();
});

class ChatController extends Notifier<AsyncValue<void>> {
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null); // Initial state is idle (null)
  }

  /// Sends a text message from a specific user for a specific ride
  Future<void> sendMessage({
    required String rideId,
    required String senderId,
    required String text,
  }) async {
    // Show a loading state (e.g., a tiny spinner next to the send button)
    state = const AsyncValue.loading();
    
    try {
      // Format the message payload
      final messagePayload = {
        'senderId': senderId,
        'text': text,
        // Server timestamp ensures messages order correctly regardless of phone timezones
        'timestamp': FieldValue.serverTimestamp(), 
      };

      await _repository.sendMessage(rideId, messagePayload);
      
      // Reset state to success so the user can type the next message
      state = const AsyncValue.data(null);
    } catch (e, st) {
      // Catch errors (like lost internet) so the UI can show a "Failed to send" icon
      state = AsyncValue.error(e, st);
    }
  }
}