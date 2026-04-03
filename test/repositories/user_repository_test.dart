import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Required for Timestamp
import 'package:odogo_app/models/user_model.dart';
import 'package:odogo_app/models/enums.dart';
import 'package:odogo_app/repositories/user_repository.dart';

void main() {
  late FakeFirebaseFirestore fakeDb;
  late UserRepository repository;

  // Helper to create a consistent test user with all REQUIRED fields
  UserModel createTestUser({
    String id = 'user_001',
    String email = 'archit@odogo.com',
  }) {
    return UserModel(
      userID: id,
      emailID: email,
      name: 'Archit Agarwal',
      phoneNo: '1234567890', // Added required field
      gender: 'Male', // Added required field
      role: UserRole.driver,
      // FIX: Wrap DateTime in a Timestamp object
      dob: Timestamp.fromDate(DateTime(2000, 1, 1)),
    );
  }

  setUp(() {
    fakeDb = FakeFirebaseFirestore();
    repository = UserRepository(firestore: fakeDb);
  });

  group('UserRepository Tests', () {
    test('createUser successfully adds user to Firestore', () async {
      final user = createTestUser();
      await repository.createUser(user);

      final doc = await fakeDb.collection('users').doc(user.userID).get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['phoneNo'], '1234567890');
    });

    test(
      'getUser returns the correct model with Timestamp conversion',
      () async {
        final user = createTestUser();
        await repository.createUser(user);

        final result = await repository.getUser(user.userID);
        expect(result, isNotNull);
        expect(result?.name, 'Archit Agarwal');
        // Verify the dob was reconstructed correctly
        expect(result?.dob.seconds, user.dob.seconds);
      },
    );

    test('updateUser modifies provided fields', () async {
      final user = createTestUser();
      await repository.createUser(user);

      await repository.updateUser(user.userID, {'name': 'Archit Pro'});

      final updated = await repository.getUser(user.userID);
      expect(updated?.name, 'Archit Pro');
      expect(updated?.gender, 'Male'); // Remains unchanged
    });

    test('deleteUser removes the document', () async {
      final user = createTestUser();
      await repository.createUser(user);
      await repository.deleteUser(user.userID);

      final doc = await fakeDb.collection('users').doc(user.userID).get();
      expect(doc.exists, isFalse);
    });

    test('streamUser emits new data', () async {
      final user = createTestUser();
      await repository.createUser(user);

      final stream = repository.streamUser(user.userID);

      expectLater(
        stream,
        emitsInOrder([
          predicate<UserModel?>((u) => u?.name == 'Archit Agarwal'),
          predicate<UserModel?>((u) => u?.name == 'Archit Updated'),
        ]),
      );

      await repository.updateUser(user.userID, {'name': 'Archit Updated'});
    });
  });
}
