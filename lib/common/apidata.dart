class APIData {
  // Replace with your domain link : http://example.com/public/

  static const String domainLink = "https://ofledn.com";

  static const String domainApiLink = domainLink + "api/";

  // API Links
  static const String getSecretKey = domainApiLink + "apikeys";
  static const String login = domainApiLink + "login";
  static const String fbLoginAPI = domainApiLink + "fblogin";
  static const String googleLoginApi = domainApiLink + "googlelogin";
  static const String register = domainApiLink + "register";
  static const String refresh = domainApiLink + "refresh";
  static const String logOut = domainApiLink + "logout";
  static const String forgotPassword = domainApiLink + "forgotpassword";
  static const String verifyCode = domainApiLink + "verifycode";
  static const String restPassword = domainApiLink + "resetpassword";
  static const String allCourse = domainApiLink + "course?secret=";
  static const String featuredCourses =
      domainApiLink + "featuredcourse?secret=";
  static const String categories = domainApiLink + "categories?secret=";
  static const String subCategories = domainApiLink + "subcategories?secret=";
  static const String childCategories =
      domainApiLink + "childcategories?secret=";
  static const String addToWishList = domainApiLink + "addtowishlist?secret=";
  static const String removeWishList =
      domainApiLink + "remove/wishlist?secret=";
  static const String wishList = domainApiLink + "show/wishlist?secret=";
  static const String featuredCategories =
      domainApiLink + "featured/categories?secret=";
  static const String bundleCourses = domainApiLink + "bundle/courses?secret=";
  static const String recentCourse = domainApiLink + "recent/course?secret=";
  static const String testimonials = domainApiLink + "testimonial?secret=";
  static const String trustedCompany = domainApiLink + "trusted?secret=";
  static const String userFaq = domainApiLink + "user/faq?secret=";
  static const String instructorFaq = domainApiLink + "instructor/faq?secret=";
  static const String blog = domainApiLink + "blog?secret=";
  static const String blogDetail = domainApiLink + "blog/detail?secret=";
  static const String userProfile = domainApiLink + "show/profile?secret=";
  static const String updateUserProfile =
      domainApiLink + "update/profile?secret=";
  static const String addToCart = domainApiLink + "addtocart?secret=";
  static const String removeFromCart = domainApiLink + "remove/cart?secret=";
  static const String showCart = domainApiLink + "show/cart?secret=";
  static const String courseDetail = domainApiLink + "course/detail?secret=";
  static const String allPage = domainApiLink + "all/pages?secret=";
  static const String home = domainApiLink + "home?secret=";
  static const String slider = domainApiLink + "slider?secret=";
  static const String sliderFacts = domainApiLink + "sliderfacts?secret=";
  static const String removeAllCourseFromCart =
      domainApiLink + "remove/all/cart?secret=";
  static const String addBundleToCart =
      domainApiLink + "addtocart/bundle?secret=";
  static const String removeBundleCourseFromCart =
      domainApiLink + "remove/bundle?secret=";
  static const String notifications = domainApiLink + "notifications?secret=";
  static const String readNotification = domainApiLink + "readnotification/";
  static const String readAllNotification =
      domainApiLink + "readall/notification?secret=";
  static const String instructorProfile =
      domainApiLink + "instructor/profile?secret=";
  static const String courseReview = domainApiLink + "course/review?secret=";
  static const String chapterDuration =
      domainApiLink + "chapter/duration?secret=";
  static const String myCourses = domainApiLink + "my/courses?secret=";
  static const String aboutUs = domainApiLink + "aboutus?secret=";
  static const String contactUs = domainApiLink + "contactus?secret=";
  static const String becomeAnInstructor =
      domainApiLink + "instructor/request?secret=";
  static const String purchaseHistory =
      domainApiLink + "purchase/history?secret=";
  static const String coupon = domainApiLink + "all/coupons?secret=";
  static const String flagContent = domainApiLink + "course/report?secret=";
  static const String updateProgress =
      domainApiLink + "course/progress/update?secret=";
  static const String paymentGatewayKeys =
      domainApiLink + "payment/apikeys?secret=";
  static const String payStore = domainApiLink + "pay/store?secret=";
  static const String applyCoupon = domainApiLink + "apply/coupon?secret=";
  static const String removeCoupon = domainApiLink + "remove/coupon?secret=";
  static const String courseProgress =
      domainApiLink + "course/progress?secret=";
  static const String courseContent = domainApiLink + "course/content/";
  static const String requestAppointment =
      domainApiLink + "appointment/request?secret=";
  static const String submitAssignment =
      domainApiLink + "assignment/submit?secret=";
  static const String submitAnswer = domainApiLink + "answer/submit?secret=";
  static const String submitQuestion =
      domainApiLink + "question/submit?secret=";
  static const String deleteAppointment = domainApiLink + "appointment/delete/";
  static const String reviewCourse = domainApiLink + 'review/submit?secret=';
  static const String language = domainApiLink + 'language?secret=';
  static const String quizSubmit = domainApiLink + 'quiz/submit?secret=';
  static const String termsPolicy = domainApiLink + 'terms_policy?secret=';
  static const String addToWatchlist =
      domainApiLink + 'create/watchlist?secret=';
  static const String deleteFromWatchlist =
      domainApiLink + 'delete/watchlist?secret=';
  static const String getAllWatchlist =
      domainApiLink + 'view/watchlist?secret=';
  static const String likeDislikeReview = domainApiLink + 'review/helpful/';
  static const String enrollInFreeCourse =
      domainApiLink + 'free/enroll?secret=';
  static const String checkUser = domainApiLink + 'gift/user/check?secret=';
  static const String giftCheckout = domainApiLink + 'gift/checkout?secret=';
  static const String manualPayments = domainApiLink + 'manual/payment?secret=';
  static const String certificate = domainApiLink + 'certificate/download/';
  static const String livoflednAttendance =
      domainApiLink + 'live/attendance?secret=';
  static const String confirmation = domainLink + 'confirmation';
  static const String purchaseInvoice = domainApiLink + 'invoice/download/';
  static const String quizReport = domainApiLink + 'quiz/reports/';
  static const String shareBundleCourse = domainLink + 'bundle/detail/';
  static const String shareCourse = domainLink + 'course/';
  static const String currencyRates = domainApiLink + 'currency/rates?secret=';

  // Images server path URI
  static const String logo = domainLink + "images/logo/";
  static const String testimonialImages = domainLink + "images/testimonial/";
  static const String trustedImages = domainLink + "images/trusted/";
  static const String loginImageUri = domainLink + "images/login/";
  static const String userImage = domainLink + "images/user_img/";
  static const String courseImages = domainLink + "images/course/";
  static const String bundleImages = domainLink + "images/bundle/";
  static const String sliderImages = domainLink + "images/slider/";
  static const String aboutUsImages = domainLink + "images/about/";
  static const String contactUsImages = domainLink + "images/contact/";
  static const String categoryImages = domainLink + "images/category/";
  static const String userImagePath = domainLink + "images/user_img/";
  static const String blogImage = domainLink + "images/blog/";
  static const String zoomImage = domainLink + "images/zoom/";
  static const String gMeetImage =
      domainLink + "images/googlemeet/profile_image/";
  static const String jitsiMeetImage = domainLink + "images/jitsimeet/";

  // Webview player
  static const String watchCourse = domainLink + "watchcourse/";
  static const String watchClass = domainLink + "watchclass/";

  // Constants
  static const String appName = "OFLEDN";
  static const String secretKey = "8d4d9af1-478a-4edd-acd8-6d3e97dbc397";

  // To play google drive video
  static const String googleDriveApi = 'ENTER_GOOGLE_DRIVE_API_KEY_HERE';

  // Zoom details
  static const String zoomAppKey = "ENTER_ZOOM_APP_KEY_HERE";
  static const String zoomSecretKey = "ENTER_ZOOM_SECRET_KEY_HERE";

  // Upload video link
  static const String videoLink = domainLink + "video/class/";
  static const String previewVideoLink = domainLink + "video/preview/";

  // Upload PDF link
  static const String pdfLink = domainLink + "files/pdf/";
}
