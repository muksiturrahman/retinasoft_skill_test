class ApiService {
  static const baseUrl = "https://skill-test.retinasoft.com.bd/api/v1/";

  static String loginUrl = "${baseUrl}login";
  static String loginOtpUrl = "${baseUrl}send-login-otp";
  static String registrationUrl = "${baseUrl}sign-up/store";
  static String registrationOtpUrl = "${baseUrl}sign-up/verify-otp-code";
  static String businessTypeUrl = "${baseUrl}get-business-types";
  static String getProfileUrl = "${baseUrl}admin/profile";
  static String getProfileUpdateUrl = "${baseUrl}admin/profile/update";
}
