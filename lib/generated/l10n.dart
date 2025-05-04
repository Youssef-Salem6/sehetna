// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Get Professional Medical Care at Home`
  String get onBoarding1Title {
    return Intl.message(
      'Get Professional Medical Care at Home',
      name: 'onBoarding1Title',
      desc: '',
      args: [],
    );
  }

  /// `From physiotherapy and rehabilitation to post-surgery care, our expert team ensures the best treatment in the comfort of your home`
  String get onBoarding1description {
    return Intl.message(
      'From physiotherapy and rehabilitation to post-surgery care, our expert team ensures the best treatment in the comfort of your home',
      name: 'onBoarding1description',
      desc: '',
      args: [],
    );
  }

  /// `Easy Doctor Consultations & Lab Tests`
  String get onBoarding2Title {
    return Intl.message(
      'Easy Doctor Consultations & Lab Tests',
      name: 'onBoarding2Title',
      desc: '',
      args: [],
    );
  }

  /// `Book appointments with top doctors and perform lab tests without stepping out of your home.`
  String get onBoarding2description {
    return Intl.message(
      'Book appointments with top doctors and perform lab tests without stepping out of your home.',
      name: 'onBoarding2description',
      desc: '',
      args: [],
    );
  }

  /// `24/7 Nursing & Emergency Support`
  String get onBoarding3Title {
    return Intl.message(
      '24/7 Nursing & Emergency Support',
      name: 'onBoarding3Title',
      desc: '',
      args: [],
    );
  }

  /// `From medication administration to wound care and ambulance transport, we provide fast and reliable medical support.`
  String get onBoarding3description {
    return Intl.message(
      'From medication administration to wound care and ambulance transport, we provide fast and reliable medical support.',
      name: 'onBoarding3description',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Welcome Back`
  String get loginTitle {
    return Intl.message('Welcome Back', name: 'loginTitle', desc: '', args: []);
  }

  /// `UserName`
  String get userName {
    return Intl.message('UserName', name: 'userName', desc: '', args: []);
  }

  /// `Please enter your email`
  String get embtyEmailWarning {
    return Intl.message(
      'Please enter your email',
      name: 'embtyEmailWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get inValidMailWarning {
    return Intl.message(
      'Please enter a valid email',
      name: 'inValidMailWarning',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Please enter your Password`
  String get embtyPasswordWarning {
    return Intl.message(
      'Please enter your Password',
      name: 'embtyPasswordWarning',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long`
  String get shortPasswordWarning {
    return Intl.message(
      'Password must be at least 6 characters long',
      name: 'shortPasswordWarning',
      desc: '',
      args: [],
    );
  }

  /// `Forget Password`
  String get ForgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'ForgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `or login with`
  String get orLoginWith {
    return Intl.message(
      'or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Join to us now!`
  String get joinUs {
    return Intl.message('Join to us now!', name: 'joinUs', desc: '', args: []);
  }

  /// `Please enter your first name`
  String get embtyFirstnameWarning {
    return Intl.message(
      'Please enter your first name',
      name: 'embtyFirstnameWarning',
      desc: '',
      args: [],
    );
  }

  /// `First name must be at least 3 characters long`
  String get shortFirstnameWarning {
    return Intl.message(
      'First name must be at least 3 characters long',
      name: 'shortFirstnameWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Last name`
  String get embtyLastnameWarning {
    return Intl.message(
      'Please enter your Last name',
      name: 'embtyLastnameWarning',
      desc: '',
      args: [],
    );
  }

  /// `Last name must be at least 3 characters long`
  String get shortLastnameWarning {
    return Intl.message(
      'Last name must be at least 3 characters long',
      name: 'shortLastnameWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your address`
  String get embtyAddressWarning {
    return Intl.message(
      'Please enter your address',
      name: 'embtyAddressWarning',
      desc: '',
      args: [],
    );
  }

  /// `Address must be at least 12 characters long`
  String get shortAddressWarning {
    return Intl.message(
      'Address must be at least 12 characters long',
      name: 'shortAddressWarning',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your Phone number`
  String get embtyPhoneWarning {
    return Intl.message(
      'Please enter your Phone number',
      name: 'embtyPhoneWarning',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number must be at least 11 Numbers long`
  String get shortPhoneWarning {
    return Intl.message(
      'Phone Number must be at least 11 Numbers long',
      name: 'shortPhoneWarning',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `or signup with`
  String get signUpWith {
    return Intl.message(
      'or signup with',
      name: 'signUpWith',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get haveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'haveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to reset your password.`
  String get forgetPasswordInfo {
    return Intl.message(
      'Enter your email to reset your password.',
      name: 'forgetPasswordInfo',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendCode {
    return Intl.message(
      'Send Reset Link',
      name: 'sendCode',
      desc: '',
      args: [],
    );
  }

  /// `Reset link has been sent, please enter the OTP Numbers here to continue.`
  String get otpInfo {
    return Intl.message(
      'Reset link has been sent, please enter the OTP Numbers here to continue.',
      name: 'otpInfo',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get conttinue {
    return Intl.message('Continue', name: 'conttinue', desc: '', args: []);
  }

  /// `Didn’t receive an email? `
  String get didnotReciveEmail {
    return Intl.message(
      'Didn’t receive an email? ',
      name: 'didnotReciveEmail',
      desc: '',
      args: [],
    );
  }

  /// `Resend Code`
  String get resendCode {
    return Intl.message('Resend Code', name: 'resendCode', desc: '', args: []);
  }

  /// `Create a new password`
  String get newPasswordInfo {
    return Intl.message(
      'Create a new password',
      name: 'newPasswordInfo',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confermation Password`
  String get confermationPassword {
    return Intl.message(
      'Confermation Password',
      name: 'confermationPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be like Confermation Password`
  String get confermationPasswordError {
    return Intl.message(
      'Password must be like Confermation Password',
      name: 'confermationPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Hello, `
  String get hello {
    return Intl.message('Hello, ', name: 'hello', desc: '', args: []);
  }

  /// `Let’s check your health`
  String get checkYourHealth {
    return Intl.message(
      'Let’s check your health',
      name: 'checkYourHealth',
      desc: '',
      args: [],
    );
  }

  /// `Let’s check your health`
  String get searchBySpiciality {
    return Intl.message(
      'Let’s check your health',
      name: 'searchBySpiciality',
      desc: '',
      args: [],
    );
  }

  /// `Immediate medical assistance for critical situations. Our emergency team will reach within 30 minutes.`
  String get emergencyCardInfo {
    return Intl.message(
      'Immediate medical assistance for critical situations. Our emergency team will reach within 30 minutes.',
      name: 'emergencyCardInfo',
      desc: '',
      args: [],
    );
  }

  /// `EMERGENCY SERVICE`
  String get emergencyMedicalService {
    return Intl.message(
      'EMERGENCY SERVICE',
      name: 'emergencyMedicalService',
      desc: '',
      args: [],
    );
  }

  /// `Emergency`
  String get emergency {
    return Intl.message('Emergency', name: 'emergency', desc: '', args: []);
  }

  /// `Ongoing Appointments & Requests`
  String get ongoingRequests {
    return Intl.message(
      'Ongoing Appointments & Requests',
      name: 'ongoingRequests',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Last Name`
  String get lastName {
    return Intl.message('Last Name', name: 'lastName', desc: '', args: []);
  }

  /// `Phone Number`
  String get phone {
    return Intl.message('Phone Number', name: 'phone', desc: '', args: []);
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Details`
  String get appointmentDetails {
    return Intl.message(
      'Appointment Details',
      name: 'appointmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `Fees`
  String get fees {
    return Intl.message('Fees', name: 'fees', desc: '', args: []);
  }

  /// `Call Doctor`
  String get callDoctor {
    return Intl.message('Call Doctor', name: 'callDoctor', desc: '', args: []);
  }

  /// `Reschedule`
  String get reschedule {
    return Intl.message('Reschedule', name: 'reschedule', desc: '', args: []);
  }

  /// `Cancel Appointment`
  String get cancelAppointment {
    return Intl.message(
      'Cancel Appointment',
      name: 'cancelAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Appointment`
  String get appointment {
    return Intl.message('Appointment', name: 'appointment', desc: '', args: []);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Insurance`
  String get insurance {
    return Intl.message('Insurance', name: 'insurance', desc: '', args: []);
  }

  /// `Manage Cards`
  String get manageCards {
    return Intl.message(
      'Manage Cards',
      name: 'manageCards',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get helpAndSupport {
    return Intl.message(
      'Help & Support',
      name: 'helpAndSupport',
      desc: '',
      args: [],
    );
  }

  /// `Email Us`
  String get emailUs {
    return Intl.message('Email Us', name: 'emailUs', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Additional Settings`
  String get additionalSettings {
    return Intl.message(
      'Additional Settings',
      name: 'additionalSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message('Rate Us', name: 'rateUs', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Birth Date`
  String get dateOfBirth {
    return Intl.message('Birth Date', name: 'dateOfBirth', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Password changed failed please try again`
  String get passwordChangedFailed {
    return Intl.message(
      'Password changed failed please try again',
      name: 'passwordChangedFailed',
      desc: '',
      args: [],
    );
  }

  /// `Language changed successfully`
  String get languageChangedSuccessfully {
    return Intl.message(
      'Language changed successfully',
      name: 'languageChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Language changed failed please try again`
  String get languageChangedFailed {
    return Intl.message(
      'Language changed failed please try again',
      name: 'languageChangedFailed',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedBack {
    return Intl.message('Feedback', name: 'feedBack', desc: '', args: []);
  }

  /// `How would you rate your experience?`
  String get howWouldYouRateYourExperience {
    return Intl.message(
      'How would you rate your experience?',
      name: 'howWouldYouRateYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `Share your feedback`
  String get shareYourFeedback {
    return Intl.message(
      'Share your feedback',
      name: 'shareYourFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Tell us what you think...`
  String get tellUsWhatYouThink {
    return Intl.message(
      'Tell us what you think...',
      name: 'tellUsWhatYouThink',
      desc: '',
      args: [],
    );
  }

  /// `Please provide your feedback`
  String get feedbackRequired {
    return Intl.message(
      'Please provide your feedback',
      name: 'feedbackRequired',
      desc: '',
      args: [],
    );
  }

  /// `Submit Feedback`
  String get submitFeedback {
    return Intl.message(
      'Submit Feedback',
      name: 'submitFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Excellent`
  String get excellent {
    return Intl.message('Excellent', name: 'excellent', desc: '', args: []);
  }

  /// `Good`
  String get good {
    return Intl.message('Good', name: 'good', desc: '', args: []);
  }

  /// `Average`
  String get average {
    return Intl.message('Average', name: 'average', desc: '', args: []);
  }

  /// `Poor`
  String get poor {
    return Intl.message('Poor', name: 'poor', desc: '', args: []);
  }

  /// `Very Poor`
  String get veryPoor {
    return Intl.message('Very Poor', name: 'veryPoor', desc: '', args: []);
  }

  /// `Thank You!`
  String get thankYou {
    return Intl.message('Thank You!', name: 'thankYou', desc: '', args: []);
  }

  /// `Your feedback has been submitted successfully.`
  String get feedbackSubmittedSuccessfully {
    return Intl.message(
      'Your feedback has been submitted successfully.',
      name: 'feedbackSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Complain`
  String get complain {
    return Intl.message('Complain', name: 'complain', desc: '', args: []);
  }

  /// `Subject`
  String get subject {
    return Intl.message('Subject', name: 'subject', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Please enter a subject`
  String get pleaseEnterSubject {
    return Intl.message(
      'Please enter a subject',
      name: 'pleaseEnterSubject',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a description`
  String get pleaseEnterDescription {
    return Intl.message(
      'Please enter a description',
      name: 'pleaseEnterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Description should be at least 10 characters`
  String get descriptionTooShort {
    return Intl.message(
      'Description should be at least 10 characters',
      name: 'descriptionTooShort',
      desc: '',
      args: [],
    );
  }

  /// `Submit Complaint`
  String get submitComplaint {
    return Intl.message(
      'Submit Complaint',
      name: 'submitComplaint',
      desc: '',
      args: [],
    );
  }

  /// `Your complaint has been submitted successfully`
  String get complaintSubmittedSuccessfully {
    return Intl.message(
      'Your complaint has been submitted successfully',
      name: 'complaintSubmittedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `My Complains`
  String get myComplains {
    return Intl.message(
      'My Complains',
      name: 'myComplains',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get replay {
    return Intl.message('Reply', name: 'replay', desc: '', args: []);
  }

  /// `My Feedback`
  String get myFeedback {
    return Intl.message('My Feedback', name: 'myFeedback', desc: '', args: []);
  }

  /// `Complaint`
  String get complainTitle {
    return Intl.message('Complaint', name: 'complainTitle', desc: '', args: []);
  }

  /// `Submit Your Complaint`
  String get submitYourComplaint {
    return Intl.message(
      'Submit Your Complaint',
      name: 'submitYourComplaint',
      desc: '',
      args: [],
    );
  }

  /// `We'll review your complaint and get back to you soon`
  String get weWillReviewYourComplaintPrompt {
    return Intl.message(
      'We\'ll review your complaint and get back to you soon',
      name: 'weWillReviewYourComplaintPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subjectFieldLabel {
    return Intl.message(
      'Subject',
      name: 'subjectFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter complaint subject`
  String get subjectFieldHint {
    return Intl.message(
      'Enter complaint subject',
      name: 'subjectFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get descriptionFieldLabel {
    return Intl.message(
      'Description',
      name: 'descriptionFieldLabel',
      desc: '',
      args: [],
    );
  }

  /// `Describe your complaint in detail`
  String get descriptionFieldHint {
    return Intl.message(
      'Describe your complaint in detail',
      name: 'descriptionFieldHint',
      desc: '',
      args: [],
    );
  }

  /// `Submit Complaint`
  String get submitButtonLabel {
    return Intl.message(
      'Submit Complaint',
      name: 'submitButtonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a subject`
  String get subjectValidationError {
    return Intl.message(
      'Please enter a subject',
      name: 'subjectValidationError',
      desc: '',
      args: [],
    );
  }

  /// `Please describe your complaint`
  String get descriptionValidationEmptyError {
    return Intl.message(
      'Please describe your complaint',
      name: 'descriptionValidationEmptyError',
      desc: '',
      args: [],
    );
  }

  /// `Description should be at least 10 characters`
  String get descriptionValidationLengthError {
    return Intl.message(
      'Description should be at least 10 characters',
      name: 'descriptionValidationLengthError',
      desc: '',
      args: [],
    );
  }

  /// `My Complaints`
  String get complaintsTitle {
    return Intl.message(
      'My Complaints',
      name: 'complaintsTitle',
      desc: '',
      args: [],
    );
  }

  /// `No complaints yet`
  String get noComplaintsTitle {
    return Intl.message(
      'No complaints yet',
      name: 'noComplaintsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tap the + button to add a complaint`
  String get addComplaintPrompt {
    return Intl.message(
      'Tap the + button to add a complaint',
      name: 'addComplaintPrompt',
      desc: '',
      args: [],
    );
  }

  /// `No Subject`
  String get noSubjectText {
    return Intl.message(
      'No Subject',
      name: 'noSubjectText',
      desc: '',
      args: [],
    );
  }

  /// `No description provided`
  String get noDescriptionText {
    return Intl.message(
      'No description provided',
      name: 'noDescriptionText',
      desc: '',
      args: [],
    );
  }

  /// `Response`
  String get responseTitle {
    return Intl.message('Response', name: 'responseTitle', desc: '', args: []);
  }

  /// `No response yet`
  String get noResponseText {
    return Intl.message(
      'No response yet',
      name: 'noResponseText',
      desc: '',
      args: [],
    );
  }

  /// `Resolved`
  String get statusResolved {
    return Intl.message('Resolved', name: 'statusResolved', desc: '', args: []);
  }

  /// `Closed`
  String get statusClosed {
    return Intl.message('Closed', name: 'statusClosed', desc: '', args: []);
  }

  /// `Open`
  String get statusOpen {
    return Intl.message('Open', name: 'statusOpen', desc: '', args: []);
  }

  /// `In Progress`
  String get statusInProgress {
    return Intl.message(
      'In Progress',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get statusPending {
    return Intl.message('Pending', name: 'statusPending', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Make a Request`
  String get makeRequest {
    return Intl.message(
      'Make a Request',
      name: 'makeRequest',
      desc: '',
      args: [],
    );
  }

  /// `Information Details`
  String get informationDetails {
    return Intl.message(
      'Information Details',
      name: 'informationDetails',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Enter Your Name`
  String get emptyNameError {
    return Intl.message(
      'Enter Your Name',
      name: 'emptyNameError',
      desc: '',
      args: [],
    );
  }

  /// `this name is too Short`
  String get shortNameError {
    return Intl.message(
      'this name is too Short',
      name: 'shortNameError',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Please enter your age`
  String get emptyAgeError {
    return Intl.message(
      'Please enter your age',
      name: 'emptyAgeError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get invalidAgeError {
    return Intl.message(
      'Please enter a valid number',
      name: 'invalidAgeError',
      desc: '',
      args: [],
    );
  }

  /// `Age must be between 1 and 120`
  String get ageRangeError {
    return Intl.message(
      'Age must be between 1 and 120',
      name: 'ageRangeError',
      desc: '',
      args: [],
    );
  }

  /// `Blood Type`
  String get bloodType {
    return Intl.message('Blood Type', name: 'bloodType', desc: '', args: []);
  }

  /// `Please select your blood type`
  String get emptyBloodTypeError {
    return Intl.message(
      'Please select your blood type',
      name: 'emptyBloodTypeError',
      desc: '',
      args: [],
    );
  }

  /// `Wating A Request`
  String get watingRequest {
    return Intl.message(
      'Wating A Request',
      name: 'watingRequest',
      desc: '',
      args: [],
    );
  }

  /// `please fill all fields`
  String get fillAllFields {
    return Intl.message(
      'please fill all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Cancel Request`
  String get cancelRequestTitle {
    return Intl.message(
      'Cancel Request',
      name: 'cancelRequestTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please provide a reason for cancellation:`
  String get cancelRequestPrompt {
    return Intl.message(
      'Please provide a reason for cancellation:',
      name: 'cancelRequestPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Reason`
  String get reason {
    return Intl.message('Reason', name: 'reason', desc: '', args: []);
  }

  /// `Enter your reason here...`
  String get enterYourReason {
    return Intl.message(
      'Enter your reason here...',
      name: 'enterYourReason',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a reason`
  String get reasonRequired {
    return Intl.message(
      'Please enter a reason',
      name: 'reasonRequired',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Confirm Cancel`
  String get confirmCancel {
    return Intl.message(
      'Confirm Cancel',
      name: 'confirmCancel',
      desc: '',
      args: [],
    );
  }

  /// `Failed to cancel request`
  String get cancelRequestFailed {
    return Intl.message(
      'Failed to cancel request',
      name: 'cancelRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Accept Request`
  String get acceptRequest {
    return Intl.message(
      'Accept Request',
      name: 'acceptRequest',
      desc: '',
      args: [],
    );
  }

  /// `Request Accepted`
  String get requestAccepted {
    return Intl.message(
      'Request Accepted',
      name: 'requestAccepted',
      desc: '',
      args: [],
    );
  }

  /// `Your`
  String get Your {
    return Intl.message('Your', name: 'Your', desc: '', args: []);
  }

  /// `request has been confirmed`
  String get requestConfirmed {
    return Intl.message(
      'request has been confirmed',
      name: 'requestConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Service Details`
  String get serviceDetails {
    return Intl.message(
      'Service Details',
      name: 'serviceDetails',
      desc: '',
      args: [],
    );
  }

  /// `Service Type`
  String get serviceType {
    return Intl.message(
      'Service Type',
      name: 'serviceType',
      desc: '',
      args: [],
    );
  }

  /// `Expected Time`
  String get expextedTime {
    return Intl.message(
      'Expected Time',
      name: 'expextedTime',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Provider Details`
  String get providerDetails {
    return Intl.message(
      'Provider Details',
      name: 'providerDetails',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Contact`
  String get contact {
    return Intl.message('Contact', name: 'contact', desc: '', args: []);
  }

  /// `Rating`
  String get rating {
    return Intl.message('Rating', name: 'rating', desc: '', args: []);
  }

  /// `Distance`
  String get distance {
    return Intl.message('Distance', name: 'distance', desc: '', args: []);
  }

  /// `Back to Home`
  String get backToHome {
    return Intl.message('Back to Home', name: 'backToHome', desc: '', args: []);
  }

  /// `Ongoing Request`
  String get ongoningRequest {
    return Intl.message(
      'Ongoing Request',
      name: 'ongoningRequest',
      desc: '',
      args: [],
    );
  }

  /// `Additional Information`
  String get additionalInfo {
    return Intl.message(
      'Additional Information',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Additional Note`
  String get additionalNote {
    return Intl.message(
      'Additional Note',
      name: 'additionalNote',
      desc: '',
      args: [],
    );
  }

  /// `Add Note (Optional)`
  String get addnote {
    return Intl.message(
      'Add Note (Optional)',
      name: 'addnote',
      desc: '',
      args: [],
    );
  }

  /// `No Requests Yet`
  String get emptyRequests {
    return Intl.message(
      'No Requests Yet',
      name: 'emptyRequests',
      desc: '',
      args: [],
    );
  }

  /// `No Ongoing Requests`
  String get emptyOngoingRequests {
    return Intl.message(
      'No Ongoing Requests',
      name: 'emptyOngoingRequests',
      desc: '',
      args: [],
    );
  }

  /// `Add Service`
  String get addService {
    return Intl.message('Add Service', name: 'addService', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
