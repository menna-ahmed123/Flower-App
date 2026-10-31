import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String _s(String key, String english) {
  if (!trExists(key)) return english;
  return key.tr();
}

String _sn(String key, String english, Map<String, String> args) {
  if (!trExists(key)) {
    var value = english;
    for (final entry in args.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }
  return key.tr(namedArgs: args);
}

abstract class AppString {
  // ==================== Login ====================

  static String get rememberMe => _s('rememberMe', 'Remember me');
  static String get dontHaveAccount =>
      _s('dontHaveAccount', 'Don\'t have an account?');
  static String get enterYourEmail => _s('enterYourEmail', 'Enter your email');
  static String get enterYourPassword =>
      _s('enterYourPassword', 'Enter your password');
  static String get forgetPassword => _s('forgetPassword', 'Forget password?');

  // ==================== Validation ====================

  static String get pleaseEnterYourEmail =>
      _s('pleaseEnterYourEmail', 'Please enter your email');
  static String get pleaseEnterValidEmail =>
      _s('pleaseEnterValidEmail', 'This Email is not valid');
  static String get passwordIsRequired =>
      _s('passwordIsRequired', 'Password is required');
  static String get passwordRequirement => _s(
    'passwordRequirement',
    'Password must be 8+ chars and 1 uppercase letter',
  );
  static String get registrationPasswordRequirement => _s(
    'registrationPasswordRequirement',
    'Password must contain at least 6 characters, one uppercase letter and one number',
  );
  static String get passwordsDoNotMatch =>
      _s('passwordsDoNotMatch', 'Passwords do not match');
  static String get confirmPasswordIsRequired =>
      _s('confirmPasswordIsRequired', 'Confirm password is required');
  static String get phoneNumberIsRequired =>
      _s('phoneNumberIsRequired', 'Phone number is required');
  static String get validEgyptianPhone =>
      _s('validEgyptianPhone', 'Enter a valid Egyptian phone number');
  static String get resetPasswordRequirement => registrationPasswordRequirement;
  static String get onlyLettersNumbersUnderscore => _s(
    'onlyLettersNumbersUnderscore',
    'Only letters, numbers and _ are allowed',
  );

  // ==================== Sign Up ====================

  static String get signUp => _s('signUp', 'Sign up');
  static String get firstName => _s('firstName', 'First name');
  static String get lastName => _s('lastName', 'Last name');
  static String get enterFirstName => _s('enterFirstName', 'Enter first name');
  static String get enterLastName => _s('enterLastName', 'Enter last name');
  static String get email => _s('email', 'Email');
  static String get password => _s('password', 'Password');
  static String get enterPassword => _s('enterPassword', 'Enter password');
  static String get confirmPassword =>
      _s('confirmPassword', 'Confirm password');
  static String get phoneNumber => _s('phoneNumber', 'Phone number');
  static String get enterPhoneNumber =>
      _s('enterPhoneNumber', 'Enter phone number');
  static String get gender => _s('gender', 'Gender');
  static String get female => _s('female', 'Female');
  static String get male => _s('male', 'Male');
  static String get creatingAccountAgreePrefix => _s(
    'creatingAccountAgreePrefix',
    'Creating an account, you agree to our ',
  );
  static String get termsAndConditions =>
      _s('termsAndConditions', 'Terms&Conditions');
  static String get alreadyHaveAccount =>
      _s('alreadyHaveAccount', 'Already have an account? ');
  static String get login => _s('login', 'Login');
  static String get genderIsRequired =>
      _s('genderIsRequired', 'Gender is required');
  static String get signupSuccess =>
      _s('signupSuccess', 'Account created successfully');
  static String get signupFailed =>
      _s('signupFailed', 'Sign up failed. Please try again.');
  static String get loginToContinue =>
      _s('loginToContinue', 'Please login or create an account to continue');

  // ==================== Forgot Password ====================

  static String get forgotPassword => _s('forgotPassword', 'Forgot Password');
  static String get forgotPasswordDescription => _s(
    'forgotPasswordDescription',
    'Enter your email address and we will send you a verification code.',
  );
  static String get sendCode => _s('sendCode', 'Send Code');

  // ==================== Verification ====================

  static String get verificationCode =>
      _s('verificationCode', 'Verification Code');
  static String get verificationCodeDescription =>
      _s('verificationCodeDescription', 'Enter the verification code sent to');
  static String get verify => _s('verify', 'Verify');
  static String get otpRequired =>
      _s('otpRequired', 'Please enter the verification code');
  static String get invalidOtp =>
      _s('invalidOtp', 'Please enter a valid verification code');

  // ==================== Reset Password ====================

  static String get resetPassword => _s('resetPassword', 'Reset Password');
  static String get newPassword => _s('newPassword', 'New Password');
  static String get confirm => _s('confirm', 'Confirm');
  static String get resetPasswordSuccess =>
      _s('resetPasswordSuccess', 'Reset Password Successfully');
  static String get resetPasswordDescription => _s(
    'resetPasswordDescription',
    'Password must not be empty and must contain 6 characters with upper case letter and one number at least ',
  );

  // ==================== OTP Resend ====================

  static String get invalidCode => _s('invalidCode', 'Invalid code');
  static String get didntReceiveCode =>
      _s('didntReceiveCode', 'Didn\'t receive code? ');
  static String get resend => _s('resend', 'Resend');
  static String get pleaseWaitBeforeResend =>
      _s('pleaseWaitBeforeResend', 'Please wait 30 seconds before resending');

  // ==================== Generic Validation ====================

  static String fieldIsRequired(String field) =>
      _sn('fieldIsRequired', '{field} is required', {'field': field});

  static String fieldMinLength(String field, int length) => _sn(
    'fieldMinLength',
    '{field} must be at least {length} characters',
    {'field': field, 'length': '$length'},
  );

  static String fieldNoSpaces(String field) =>
      _sn('fieldNoSpaces', '{field} cannot contain spaces', {'field': field});

  // ==================== Guest / Common Navigation ====================
  static String get continueAsGuest =>
      _s('continueAsGuest', 'Continue as guest');
  static String get pageNotFound => _s('pageNotFound', 'Page Not Found');

  // ==================== Search ====================
  static String get search => _s('search', 'Search');
  static String get searchHint =>
      _s('searchHint', 'Search for flowers, bouquets...');
  static String get noResultsFound => _s('noResultsFound', 'No results found');
  static String get searchProducts =>
      _s('searchProducts', 'Search For Any Product You Want');

  // ==================== Home / Dashboard ====================
  static String get home => _s('home', 'Home');
  static String get flowery => _s('flowery', 'Flowery');
  static String get categories => _s('categories', 'Categories');
  static String get occasions => _s('occasions', 'Occasions');
  static String get bestSellers => _s('bestSellers', 'Best Sellers');
  static String get viewAll => _s('viewAll', 'View All');
  static String get specialOffers => _s('specialOffers', 'Special Offers');
  static String get popularFlowers => _s('popularFlowers', 'Popular Flowers');
  static String get desSell =>
      _s('desSell', 'Bloom with our exquisite best sellers');
  static String get notFound => _s('notFound', 'No products found');
  static String get deliverTo =>
      _s('deliverTo', 'Deliver to 2XVP+XC - Sheikh Zayed');
  static String get sortBy => _s('sortBy', 'Sort by');
  static String get lowestPrice => _s('lowestPrice', 'Lowest Price');
  static String get highestPrice => _s('highestPrice', 'Highest Price');
  static String get newest => _s('newest', 'New');
  static String get oldest => _s('oldest', 'Old');
  static String get discount => _s('discount', 'Discount');

  // ==================== Product Details ====================
  static String get addToCart => _s('addToCart', 'Add to cart');
  static String get buyNow => _s('buyNow', 'Buy Now');
  static String get quantity => _s('quantity', 'Quantity');
  static String get description => _s('description', 'Description');
  static String get reviews => _s('reviews', 'Reviews');
  static String get relatedProducts =>
      _s('relatedProducts', 'Related Products');
  static String get outOfStock => _s('outOfStock', 'Out of Stock');
  static String get allPricesIncludeTax =>
      _s('allPricesIncludeTax', 'All prices include tax');
  static String get bouquetInclude => _s('bouquetInclude', 'Bouquet include');
  static String get inStock => _s('inStock', 'In stock');
  static String get status => _s('status', 'Status');
  static String get egp => _s('egp', 'EGP');

  // ==================== Cart ====================
  static String get cart => _s('cart', 'Cart');
  static String get myCart => _s('myCart', 'My Cart');
  static String get cartIsEmpty => _s('cartIsEmpty', 'Your cart is empty');
  static String get cartPricesUpdated => _s(
    'cartPricesUpdated',
    'Some prices or stock changed. Review your cart before checkout.',
  );
  static String get cartPricingUnavailable =>
      _s('cartPricingUnavailable', 'Live prices are temporarily unavailable.');
  static String get priceUpdated => _s('priceUpdated', 'Price updated');
  static String get stockLimit =>
      _s('stockLimit', 'Only the available quantity can be added.');
  static String get orderSummary => _s('orderSummary', 'Order Summary');
  static String get subtotal => _s('subtotal', 'Subtotal');
  static String get deliveryFee => _s('deliveryFee', 'Delivery Fee');
  static String get total => _s('total', 'Total');
  static String get checkout => _s('checkout', 'Checkout');
  static String get promoCode => _s('promoCode', 'Promo Code');
  static String get apply => _s('apply', 'Apply');
  static String get applyPromoCodeHint =>
      _s('applyPromoCodeHint', 'Enter promo code');
  static String get cancel => _s('cancel', 'Cancel');
  static String get remove => _s('remove', 'Remove');
  static String get removeItem => _s('removeItem', 'Remove item');
  static String get removeItemConfirm =>
      _s('removeItemConfirm', 'Remove this item from your cart?');

  // ==================== Address & Checkout ====================
  static String get shippingAddress =>
      _s('shippingAddress', 'Shipping Address');
  static String get deliveryAddress =>
      _s('deliveryAddress', 'Delivery address');
  static String get addAddress => _s('addAddress', 'Add Address');
  static String get addNew => _s('addNew', 'Add new');
  static String get address => _s('address', 'Address');
  static String get selectAddress => _s('selectAddress', 'Select Address');
  static String get enterAddress => _s('enterAddress', 'Enter the address');
  static String get recipient => _s('recipient', 'Recipient name');
  static String get enterRecipient =>
      _s('enterRecipient', 'Enter the recipient name');
  static String get fullName => _s('fullName', 'Full Name');
  static String get streetName => _s('streetName', 'Street Name');
  static String get buildingNumber =>
      _s('buildingNumber', 'Building/Villa Number');
  static String get floorApartment => _s('floorApartment', 'Floor/Apartment');
  static String get city => _s('city', 'City');
  static String get cairo => _s('cairo', 'Cairo');
  static String get area => _s('area', 'Area');
  static String get october => _s('october', 'October');
  static String get newAddress => _s('newAddress', 'Add New Address');

  static String get country => _s('country', 'Country');
  static String get placeOrder => _s('placeOrder', 'Place Order');
  static String get paymentMethod => _s('paymentMethod', 'Payment Method');
  static String get cashOnDelivery => _s('cashOnDelivery', 'Cash on Delivery');
  static String get creditCard => _s('creditCard', 'Credit Card');
  static String get thisIsAGift => _s('thisIsAGift', 'It is a gift');
  static String get name => _s('name', 'Name');
  static String get enterTheName => _s('enterTheName', 'Enter the name');
  static String get payNow => _s('payNow', 'Pay Now');
  static String get payment => _s('payment', 'Payment');
  static String get giftCardOnly =>
      _s('giftCardOnly', 'Gift orders can only be paid by credit card.');
  static String get confirmation => _s('confirmation', 'Confirmation');
  static String get orderPlacedSuccess =>
      _s('orderPlacedSuccess', 'Order placed successfully!');
  static String get orderFailed =>
      _s('orderFailed', 'Order failed. Please try again.');
  static String get paymentFailed =>
      _s('paymentFailed', 'Payment failed. Please try again.');
  static String get paymentCancelled =>
      _s('paymentCancelled', 'Payment was cancelled.');
  static String get deliveryUnavailable => _s(
    'deliveryUnavailable',
    'Delivery is unavailable for the selected address.',
  );
  static String get itemsUnavailable =>
      _s('itemsUnavailable', 'Some items are unavailable.');
  static String get priceChanged => _s(
    'priceChanged',
    'Prices changed. Please review the summary and confirm again.',
  );
  static String get unableToLoadPaymentPage =>
      _s('unableToLoadPaymentPage', 'Unable to load payment page');
  static String get paymentSessionDataUnavailable => _s(
    'paymentSessionDataUnavailable',
    'Payment session data is unavailable',
  );
  // ==================== Orders ====================
  static String get myOrders => _s('myOrders', 'My Orders');
  static String get active => _s('active', 'Active');
  static String get completed => _s('completed', 'Completed');
  static String itemsCount(int count) =>
      _sn('itemsCount', '{count} items', {'count': '$count'});

  static String quantityRequestedAvailable(
    Object name,
    Object requested,
    Object available,
  ) => _sn(
    'quantityRequestedAvailable',
    '{name}: {requested} requested, {available} available',
    {'name': '$name', 'requested': '$requested', 'available': '$available'},
  );

  static String quantityAvailable(Object name, Object available) => _sn(
    'quantityAvailable',
    '{name}: {available} available',
    {'name': '$name', 'available': '$available'},
  );
  static String get orderDetails => _s('orderDetails', 'Order Details');
  static String get orderDate => _s('orderDate', 'Order Date: ');
  static String get orderStatus => _s('orderStatus', 'Order Status: ');
  static String get trackOrder => _s('trackOrder', 'Track Order');
  static String get loadMore => _s('loadMore', 'Load More');
  static String get statusPending => _s('statusPending', 'Pending');
  static String get statusDelivered => _s('statusDelivered', 'Delivered');
  static String get statusCancelled => _s('statusCancelled', 'Cancelled');
  static String get gettingLocation =>
      _s('gettingLocation', 'Getting your location...');

  // ==================== Profile & Settings ====================
  static String get profile => _s('profile', 'Profile');
  static String get myProfile => _s('myProfile', 'My Profile');
  static String get savedAddresses => _s('savedAddresses', 'Saved Addresses');
  static String get settings => _s('settings', 'Settings');
  static String get language => _s('language', 'Language');
  static String get theme => _s('theme', 'Theme');
  static String get logout => _s('logout', 'Logout');
  static String get appVersion => _s('appVersion', 'Version 1.0.0');
  static String get helpSupport => _s('helpSupport', 'Help & Support');

  // ==================== Profile Screen ====================
  static String get notification => _s('notification', 'Notification');
  static String get changeLanguage => _s('changeLanguage', 'Change Language');
  static String get arabicLanguage => _s('arabicLanguage', 'Arabic');
  static String get englishLanguage => _s('englishLanguage', 'English');
  static String get logoutDialogTitle => _s('logoutDialogTitle', 'LOGOUT');
  static String get confirmLogoutMessage =>
      _s('confirmLogoutMessage', 'Confirm logout!!');
  static String get aboutUs => _s('aboutUs', 'About us');
  static String get termsAndConditionsRow =>
      _s('termsAndConditionsRow', 'Terms & conditions');
  static String get changeProfilePicture =>
      _s('changeProfilePicture', 'Change profile picture');
  static String get editProfile => _s('editProfile', 'Edit Profile');

  static String get somethingWrong =>
      _s('somethingWrong', 'Something went wrong');
  static String get retry => _s('retry', 'Retry');
  static String get noData => _s('noData', 'No data found');

  static String get couldNotGetAddress =>
      _s('couldNotGetAddress', 'Could not get address from your location.');
  static String get couldNotGetLocation => _s(
    'couldNotGetLocation',
    'Could not get your current location. Please check your location settings.',
  );

  // ==================== Additional UI ====================
  static String get homeLabel => _s('homeLabel', 'Home');
  static String get office => _s('office', 'Office');
  static String get governorate => _s('governorate', 'Governorate');
  static String get addressLabel => _s('addressLabel', 'Label');
  static String get addressLabelHint => _s('addressLabelHint', 'Home / Office');
  static String get required => _s('required', 'Required');
  static String get pleaseSelectGovernorate =>
      _s('pleaseSelectGovernorate', 'Please select a governorate');
  static String get pleaseSelectCity =>
      _s('pleaseSelectCity', 'Please select a city');
  static String get pleaseEnterAddress =>
      _s('pleaseEnterAddress', 'Please enter the address');
  static String get addressMinLength =>
      _s('addressMinLength', 'Address must be at least 5 characters');
  static String get pleaseEnterRecipientName =>
      _s('pleaseEnterRecipientName', 'Please enter the recipient name');
  static String get nameMinLength =>
      _s('nameMinLength', 'Name must be at least 2 characters');
  static String get pleaseSelectArea =>
      _s('pleaseSelectArea', 'Please select an area');
  static String get notificationsDisabledTitle =>
      _s('notificationsDisabledTitle', 'Notifications are disabled');
  static String get notificationsDisabledBody => _s(
    'notificationsDisabledBody',
    'To receive notifications, enable them from your device settings.',
  );
  static String get notNow => _s('notNow', 'Not now');
  static String get activeSessions => _s('activeSessions', 'Active Sessions');
  static String get noActiveSessions =>
      _s('noActiveSessions', 'No active sessions found');
  static String get revokeSession => _s('revokeSession', 'Revoke Session');
  static String get unknownDevice => _s('unknownDevice', 'Unknown device');
  static String get lastActive => _s('lastActive', 'Last active');
  static String get locationOrIp => _s('locationOrIp', 'Location / IP');
  static String get expires => _s('expires', 'Expires');
  static String get productDetails => _s('productDetails', 'Product details');
  static String get sessionExpired => _s('sessionExpired', 'Session expired');
  static String get routeUnavailable =>
      _s('routeUnavailable', 'Route is unavailable.');
  static String get fcmTokenUnavailable =>
      _s('fcmTokenUnavailable', 'FCM token is unavailable.');
  static String get invalidCertificate =>
      _s('invalidCertificate', 'Invalid certificate, please try again later.');
  static String get cannotReachServer => _s(
    'cannotReachServer',
    'Cannot reach the server. Start the backend with ./setup.sh and retry.',
  );
  static String get httpBadRequest =>
      _s('httpBadRequest', 'Something went wrong, please try again.');
  static String get httpUnauthorized =>
      _s('httpUnauthorized', 'Unauthorized, please login again.');
  static String get httpForbidden =>
      _s('httpForbidden', 'You are not allowed to perform this action.');
  static String get httpNotFound => _s('httpNotFound', 'Resource not found.');
  static String get httpConflict => _s('httpConflict', 'Conflict occurred.');
  static String get httpValidationFailed =>
      _s('httpValidationFailed', 'Validation failed.');
  static String get httpTooManyRequests =>
      _s('httpTooManyRequests', 'Too many requests, please try again later.');
  static String get httpInternalServerError => _s(
    'httpInternalServerError',
    'Internal server error, please try again later.',
  );
  static String get httpBadGateway => _s('httpBadGateway', 'Bad gateway.');
  static String get httpServiceUnavailable =>
      _s('httpServiceUnavailable', 'Service unavailable.');
  static String get httpGatewayTimeout =>
      _s('httpGatewayTimeout', 'Gateway timeout.');
  static String get paymentSessionUnavailable =>
      _s('paymentSessionUnavailable', 'Payment session is unavailable');
  static String get paymentFailedShort =>
      _s('paymentFailedShort', 'Payment failed');
  static String get invalidImageType =>
      _s('invalidImageType', 'Please choose a JPG, JPEG, PNG, or WEBP image.');
  static String get profileImageTooLarge =>
      _s('profileImageTooLarge', 'Profile image must be 5 MB or smaller.');
  static String get unableToSelectProfileImage =>
      _s('unableToSelectProfileImage', 'Unable to select profile image.');
  static String get notificationUpdateFailed =>
      _s('notificationUpdateFailed', 'Something went wrong. Please try again.');

  // ==================== Map ====================

  static final String mapTilerApiKey = dotenv.env['MAPTILER_API_KEY'] ?? '';

  static const String mapTilerUrlTemplate =
      'https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png';

  static const String mapLanguage = 'en';

  static const String userAgentPackageName = 'com.example.flower_app';
  static String get location => _s('location', 'Location');

  static String get locationServicesDisabled =>
      _s('locationServicesDisabled', 'Location services are disabled.');

  static String get locationPermissionDenied =>
      _s('locationPermissionDenied', 'Location permission was denied.');

  static String get locationPermissionPermanentlyDenied => _s(
    'locationPermissionPermanentlyDenied',
    'Location permission is permanently denied.',
  );

  static String get locationPermissionDescription => _s(
    'locationPermissionDescription',
    'We need your location permission to detect your current address.',
  );

  static String get enableLocationDescription => _s(
    'enableLocationDescription',
    'We need your location to detect your current address. Please enable location services from settings.',
  );

  static String get openSettings => _s('openSettings', 'Open Settings');
  static String get addAddressToContinue =>
      _s('addAddressToContinue', 'Add an address to continue');
  static String get noSavedAddresses =>
      _s('noSavedAddresses', 'No saved addresses yet');
  static String get noAddresses => _s('noAddresses', 'No addresses found');
  static String get unknownCity => _s('unknownCity', 'Unknown city');
  static String get defaultAddress => _s('defaultAddress', 'Default Address');
  static String get unknown => _s('unknown', 'Unknown');
  static String get selectDeliveryAddress => _s(
    'selectDeliveryAddress',
    'Select where you want your flowers delivered',
  );
  static String get chooseDeliveryAddress =>
      _s('chooseDeliveryAddress', 'Choose delivery address');
  static String get changePassword => _s('changePassword', 'Change Password');
  static String get save => _s('save', 'save');

  // ==================== Order Tracking ====================
  static String get trackingOrder => _s('trackingOrder', 'Tracking Order');
  static String get showMap => _s('showMap', 'Show Map');
  static String get orderDelivered => _s('orderDelivered', 'Order Delivered');
  static String get confirming => _s('confirming', 'Confirming...');
  static String get noDriverAvailable =>
      _s('noDriverAvailable', 'No delivery driver available yet');
  static String get findingDriver => _s(
    'findingDriver',
    'We\'re finding a driver for your order. You\'ll see them here as soon as one accepts.',
  );
  static String get liveLocation => _s('liveLocation', 'Live');
  static String get waitingForLocation =>
      _s('waitingForLocation', 'Waiting for location…');
  static String get waitingForDriver =>
      _s('waitingForDriver', 'Waiting for a driver');
  static String get waitingForDriverHint => _s(
    'waitingForDriverHint',
    'We\'ll show your delivery hero as soon as one accepts',
  );
  static String get deliveryHeroToday =>
      _s('deliveryHeroToday', 'Is your delivery hero for today');
  static String get trackingOrderDetails =>
      _s('trackingOrderDetails', 'Order details');
  static String get estimatedArrival =>
      _s('estimatedArrival', 'Estimated Arrival');
  static String get apartment => _s('apartment', 'Apartment');

  // Age of the driver's last position. `{value}` is filled in by the widget.
  static String get trackingUpdatedAgo =>
      _s('trackingUpdatedAgo', 'Updated {value}');
  static String get trackingLocationOutdated =>
      _s('trackingLocationOutdated', 'Location outdated · {value}');
  static String get trackingSecondsAgo =>
      _s('trackingSecondsAgo', '{value}s ago');
  static String get trackingMinutesAgo =>
      _s('trackingMinutesAgo', '{value} min ago');
  static String get trackingHoursAgo => _s('trackingHoursAgo', '{value} h ago');

  /// Stands where a value is not known yet (no estimated arrival).
  static String get noDataPlaceholder => _s('noDataPlaceholder', '--');

  // Timeline step titles / status labels (presentation wording).
  static String get trackingStepReceived =>
      _s('trackingStepReceived', 'Received your order');
  static String get trackingStepPreparing =>
      _s('trackingStepPreparing', 'Preparing your order');
  static String get trackingStepOutForDelivery =>
      _s('trackingStepOutForDelivery', 'Out for delivery');
  static String get statusPickedUp => _s('statusPickedUp', 'Picked up');
  static String get statusArrived => _s('statusArrived', 'Arrived');
  static String get statusAwaitingDeliveryConfirmation => _s(
    'statusAwaitingDeliveryConfirmation',
    'Awaiting delivery confirmation',
  );
}
