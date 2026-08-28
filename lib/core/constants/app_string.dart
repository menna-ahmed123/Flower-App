abstract class AppString {
  // ==================== Login ====================

  static const String rememberMe = 'Remember me';
  static const String dontHaveAccount = "Don't have an account?";
  static const String enterYourEmail = 'Enter your email';
  static const String enterYourPassword = 'Enter your password';
  static const String forgetPassword = 'Forget password?';

  // ==================== Validation ====================

  static const String pleaseEnterYourEmail = 'Please enter your email';
  static const String pleaseEnterValidEmail = 'This Email is not valid';
  static const String passwordIsRequired = 'Password is required';
  static const String passwordRequirement =
      'Password must be 8+ chars and 1 uppercase letter';
  static const String registrationPasswordRequirement =
      'Password must contain at least 6 characters, one uppercase letter and one number';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String confirmPasswordIsRequired =
      'Confirm password is required';
  static const String phoneNumberIsRequired = 'Phone number is required';
  static const String validEgyptianPhone =
      'Enter a valid Egyptian phone number';
  static const String resetPasswordRequirement =
      registrationPasswordRequirement;
  static const String onlyLettersNumbersUnderscore =
      'Only letters, numbers and _ are allowed';

  // ==================== Sign Up ====================

  static const String signUp = 'Sign up';
  static const String firstName = 'First name';
  static const String lastName = 'Last name';
  static const String enterFirstName = 'Enter first name';
  static const String enterLastName = 'Enter last name';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String enterPassword = 'Enter password';
  static const String confirmPassword = 'Confirm password';
  static const String phoneNumber = 'Phone number';
  static const String enterPhoneNumber = 'Enter phone number';
  static const String gender = 'Gender';
  static const String female = 'Female';
  static const String male = 'Male';
  static const String creatingAccountAgreePrefix =
      'Creating an account, you agree to our ';
  static const String termsAndConditions = 'Terms&Conditions';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String login = 'Login';
  static const String genderIsRequired = 'Gender is required';
  static const String signupSuccess = 'Account created successfully';
  static const String signupFailed = 'Sign up failed. Please try again.';
  static const String loginToContinue =
      'Please login or create an account to continue';

  // ==================== Forgot Password ====================

  static const String forgotPassword = 'Forgot Password';
  static const String forgotPasswordDescription =
      'Enter your email address and we will send you a verification code.';
  static const String sendCode = 'Send Code';

  // ==================== Verification ====================

  static const String verificationCode = 'Verification Code';
  static const String verificationCodeDescription =
      'Enter the verification code sent to';
  static const String verify = 'Verify';
  static const String otpRequired = 'Please enter the verification code';
  static const String invalidOtp = 'Please enter a valid verification code';

  // ==================== Reset Password ====================

  static const String resetPassword = 'Reset Password';
  static const String newPassword = 'New Password';
  static const String confirm = 'Confirm';
  static const String resetPasswordSuccess = 'Reset Password Successfully';
  static const String resetPasswordDescription =
      'Password must not be empty and must contain 6 characters with upper case letter and one number at least ';

  // ==================== OTP Resend ====================

  static const String invalidCode = 'Invalid code';
  static const String didntReceiveCode = "Didn't receive code? ";
  static const String resend = 'Resend';
  static const String pleaseWaitBeforeResend =
      'Please wait 30 seconds before resending';

  // ==================== Generic Validation ====================

  static String fieldIsRequired(String field) => '$field is required';
  static String fieldMinLength(String field, int length) =>
      '$field must be at least $length characters';
  static String fieldNoSpaces(String field) => '$field cannot contain spaces';

  // ==================== Guest / Common Navigation ====================
  static const String continueAsGuest = 'Continue as guest';
  static const String pageNotFound = 'Page Not Found';

  // ==================== Search ====================
  static const String search = 'Search';
  static const String searchHint = 'Search for flowers, bouquets...';
  static const String noResultsFound = 'No results found';

  // ==================== Home / Dashboard ====================
  static const String home = 'Home';
  static const String flowery = 'Flowery';
  static const String categories = 'Categories';
  static const String occasions = 'Occasions';
  static const String bestSellers = 'Best Sellers';
  static const String viewAll = 'View All';
  static const String specialOffers = 'Special Offers';
  static const String popularFlowers = 'Popular Flowers';
  static const String desSell = 'Bloom with our exquisite best sellers';
  static const String notFound = 'No products found';
  static const String deliverTo = 'Deliver to 2XVP+XC - Sheikh Zayed';

  // ==================== Product Details ====================
  static const String addToCart = 'Add to cart';
  static const String buyNow = 'Buy Now';
  static const String quantity = 'Quantity';
  static const String description = 'Description';
  static const String reviews = 'Reviews';
  static const String relatedProducts = 'Related Products';
  static const String outOfStock = 'Out of Stock';
  static const String allPricesIncludeTax = 'All prices include tax';
  static const String bouquetInclude = 'Bouquet include';
  static const String inStock = 'In stock';
  static const String status = 'Status';
  static const String egp = 'EGP';

  // ==================== Cart ====================
  static const String cart = 'Cart';
  static const String myCart = 'My Cart';
  static const String cartIsEmpty = 'Your cart is empty';
  static const String orderSummary = 'Order Summary';
  static const String subtotal = 'Subtotal';
  static const String deliveryFee = 'Delivery Fee';
  static const String total = 'Total';
  static const String checkout = 'Checkout';
  static const String promoCode = 'Promo Code';
  static const String apply = 'Apply';
  static const String applyPromoCodeHint = 'Enter promo code';

  // ==================== Address & Checkout ====================
  static const String shippingAddress = 'Shipping Address';
  static const String addAddress = 'Add Address';
  static const String address = 'Address';
  static const String selectAddress = 'Select Address';
  static const String enterAddress = "Enter the address";
  static const String recipient = "Recipient name";
  static const String enterRecipient = "Enter the recipient name";
  static const String fullName = 'Full Name';
  static const String streetName = 'Street Name';
  static const String buildingNumber = 'Building/Villa Number';
  static const String floorApartment = 'Floor/Apartment';
  static const String city = 'City';
  static const String cairo = 'Cairo';
  static const String area = 'Area';
  static const String october = 'October';
  static const String newAddress = 'Add New Address';

  static const String country = 'Country';
  static const String placeOrder = 'Place Order';
  static const String paymentMethod = 'Payment Method';
  static const String cashOnDelivery = 'Cash on Delivery';
  static const String creditCard = 'Credit Card';
  static const String orderPlacedSuccess = 'Order placed successfully!';
  static const String orderFailed = 'Order failed. Please try again.';
  // ==================== Orders ====================
  static const String myOrders = 'My Orders';
  static const String orderDetails = 'Order Details';
  static const String orderDate = 'Order Date: ';
  static const String orderStatus = 'Order Status: ';
  static const String trackOrder = 'Track Order';
  static const String statusPending = 'Pending';
  static const String statusDelivered = 'Delivered';
  static const String statusCancelled = 'Cancelled';

  // ==================== Profile & Settings ====================
  static const String profile = 'Profile';
  static const String myProfile = 'My Profile';
  static const String editProfile = 'Edit Profile';
  static const String savedAddresses = 'Saved Addresses';
  static const String settings = 'Settings';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String logout = 'Logout';
  static const String appVersion = 'Version 1.0.0';
  static const String helpSupport = 'Help & Support';

  static const String somethingWrong = 'Something went wrong';
  static const String retry = 'Retry';
  static const String noData = 'No data found';

  static const String couldNotGetAddress = 'Could not get address from your location.';
  static const String couldNotGetLocation = 'Could not get your current location. Please check your location settings.';
}
