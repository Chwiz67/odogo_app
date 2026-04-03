import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SmsOtpAuthService {
  SmsOtpAuthService._();

  static final SmsOtpAuthService instance = SmsOtpAuthService._();

  static const String _smsApiKey = String.fromEnvironment(
    'SMS_API_KEY',
    defaultValue: '',
  );

  static const Duration _otpValidity = Duration(minutes: 5);
  static const bool _bypassOtpFromEnv = bool.fromEnvironment(
    'BYPASS_OTP',
    defaultValue: false,
  );
  static const String _debugBypassCode = '0000';
  final Random _random = Random();

  static final Map<String, _OtpSession> _otpStore = <String, _OtpSession>{};

  bool get _isOtpBypassEnabled => !kReleaseMode && _bypassOtpFromEnv;

  Future<void> sendOtp({required String phoneNumber}) async {
    // Check for bypass mode
    if (_isOtpBypassEnabled) {
      _otpStore[phoneNumber] = _OtpSession(
        code: _debugBypassCode,
        expiresAt: DateTime.now().add(_otpValidity),
      );
      return;
    }

    if (_smsApiKey.isEmpty) {
      throw StateError(
        'SMS API is not configured yet. Please add a valid API key.',
      );
    }

    // Generate and store the OTP locally
    final otp = _generateOtp();
    _otpStore[phoneNumber] = _OtpSession(
      code: otp,
      expiresAt: DateTime.now().add(_otpValidity),
    );

    // Send the HTTP request to the SMS Provider
    final response = await http.post(
      Uri.parse('https://www.fast2sms.com/dev/bulkV2'),
      headers: <String, String>{
        'authorization': _smsApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'route': 'q',
        'message':
            'Your OdoGo verification code is $otp. Do not share this with anyone.',
        'flash': 0,
        'numbers':
            phoneNumber,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = response.body;
      throw Exception('Unable to send SMS. (${response.statusCode}) $body');
    }
  }

  // Verifies the code locally without making any network requests
  bool verifyOtp({required String phoneNumber, required String otp}) {
    if (_isOtpBypassEnabled) {
      return otp == _debugBypassCode;
    }

    final session = _otpStore[phoneNumber];

    if (session == null) {
      return false;
    }

    if (DateTime.now().isAfter(session.expiresAt)) {
      _otpStore.remove(phoneNumber);
      return false;
    }

    if (session.code != otp) {
      return false;
    }

    _otpStore.remove(phoneNumber);
    return true;
  }

  String _generateOtp() {
    // Generates a 4-digit OTP for SMS
    final value = _random.nextInt(10000);
    return value.toString().padLeft(4, '0');
  }
}

class _OtpSession {
  const _OtpSession({required this.code, required this.expiresAt});

  final String code;
  final DateTime expiresAt;
}
