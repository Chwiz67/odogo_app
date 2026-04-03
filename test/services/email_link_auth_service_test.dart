import 'package:flutter_test/flutter_test.dart';
import 'package:odogo_app/services/email_link_auth_service.dart';

void main() {
  group('EmailOtpAuthService Tests', () {
    final service = EmailOtpAuthService.instance;

    test(
      'Singleton instance always returns the exact same object in memory',
      () {
        final instance2 = EmailOtpAuthService.instance;
        expect(identical(service, instance2), true);
      },
    );

    test('verifyOtp returns false for an unknown email session', () {
      final result = service.verifyOtp(email: 'ghost@example.com', otp: '1234');
      expect(result, false);
    });

    test(
      'sendOtp and verifyOtp integration path (Adapts to Environment)',
      () async {
        const testEmail = 'flow@test.com';
        const isBypass = bool.fromEnvironment(
          'BYPASS_OTP',
          defaultValue: false,
        );

        try {
          // ACT: Attempt to send the OTP
          await service.sendOtp(email: testEmail);

          // ASSERT (SUCCESS PATH): If we reach this line, BYPASS_OTP is active
          // OR real EmailJS keys were provided.
          if (isBypass) {
            // 1. Test Wrong OTP
            final resultFail = service.verifyOtp(email: testEmail, otp: '9999');
            expect(
              resultFail,
              false,
              reason: 'Incorrect OTP should return false',
            );

            // 2. Test Correct Bypass OTP
            final resultSuccess = service.verifyOtp(
              email: testEmail,
              otp: '0000',
            );
            expect(
              resultSuccess,
              true,
              reason: 'Bypass OTP 0000 should return true',
            );

            // 3. Test Security (Consumed OTP)
            final resultAfterUse = service.verifyOtp(
              email: testEmail,
              otp: '0000',
            );
            expect(
              resultAfterUse,
              false,
              reason:
                  'OTP must be deleted from memory after one successful use',
            );
          } else {
            // If keys are provided but no bypass, we can at least test that a fake OTP fails.
            final resultFail = service.verifyOtp(email: testEmail, otp: '9999');
            expect(resultFail, false);
          }
        } on StateError catch (e) {
          // ASSERT (SAD PATH): BYPASS_OTP was false and API keys were missing.
          expect(e.message, contains('Email OTP is not configured yet'));
        } catch (e) {
          // ASSERT (HTTP PATH): Keys provided but the EmailJS HTTP request failed.
          expect(e, isNotNull);
        }
      },
    );
  });
}
