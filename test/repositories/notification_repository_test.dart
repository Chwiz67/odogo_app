import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odogo_app/repositories/notification_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late NotificationRepository notificationRepository;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    notificationRepository = NotificationRepository(firestore: fakeFirestore);
  });

  test(
    'streamUserNotifications filters by recipient and isRead status',
    () async {
      // Add one unread and one read notification
      await fakeFirestore.collection('notifications').add({
        'recipientID': 'archit_1',
        'isRead': false,
        'timestamp': DateTime.now(),
        'title': 'Unread',
      });
      await fakeFirestore.collection('notifications').add({
        'recipientID': 'archit_1',
        'isRead': true,
        'timestamp': DateTime.now(),
        'title': 'Read',
      });

      final notifications = await notificationRepository
          .streamUserNotifications('archit_1')
          .first;
      expect(notifications.length, 1);
      expect(notifications.first.isRead, isFalse);
    },
  );

  test('markAsRead updates the document correctly', () async {
    final docRef = await fakeFirestore.collection('notifications').add({
      'isRead': false,
    });
    await notificationRepository.markAsRead(docRef.id);

    final doc = await docRef.get();
    expect(doc.data()?['isRead'], isTrue);
  });
}
