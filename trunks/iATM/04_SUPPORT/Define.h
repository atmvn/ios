/*
 * $Author: kidbaw $
 * $Revision: 59 $
 * $Date: 2012-03-23 22:44:48 +0700 (Fri, 23 Mar 2012) $
 */

#import "SupportFunction.h"

#define TIMER_DISPLAY_TITLE_SCREEN                                          3.5
#define TIMER_MAIN_LOOP                                                     0.5
#define TIMER_COUNT_DOWN_UNIT                                               1
#define TIMER_SEC_PER_MINUTE                                                60
#define TIMER_CHANGING_VIEW                                                 0.3
#define TIMER_KARDS_VIEW_CONTROLLER_CHECKING_FOR_TIP                        5
#define TIMER_KARDS_VIEW_CONTROLLER_HIDDING_TIP                             5
#define TIMER_DECK_KARDS_VIEW_CONTROLLER_SHOWING_SIMI_DELAY_VIEW            3.5
#define TIMER_FOR_INIT_INTERFACE                                            0.5
#define TIMER_SPLASH_SCREEN_ANIMATION                                       (0.1 * 30)

#define TIMER_MAIN_LOOP_BACKGROUND                                          10

#define DOUBLE_DISTANCE_GET_USER_LOCATION_METERS                            5.00
#define DOUBLE_DISTANCE_UNIT_MAX                                            10000.00
#define DOUBLE_DISTANCE_UNIT_MIN                                            100.00

#define FLOAT_DECELERATION_RATE_DEFAULT                                     0.7

#define MAXIMUM_SCALEABLE_RADIUS_METERS                                     5000000

#define RGBCOLOR(r, g, b)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0f]

#define RELEASE_SAFE(p)                                 { if (p) { [(p) release]; (p) = nil;  } }

#define LOG_RETAIN_COUNT(a)                             NSLog(@"LOG_RETAIN_COUNT: %i", [a retainCount]);
#define LOG(a)                                          NSLog(@"LOG: %@", a);
#define FONT_APP_REGULAR                                @"Comfortaa"
#define FONT_APP_BOLD                                   @"Comfortaa-Bold"
#define FONT_APP_THIN                                   @"Comfortaa-Thin"

#define IS_IPAD                                         [SupportFunction deviceIsIPad]

#define STRING_USER_DEFAULT_USER_LOGIN_REMEBER_ME               @"user_default_remember_me"
#define STRING_USER_DEFAULT_USER_DATA_MANAGER                   @"user_default_user_data_manager"
#define STRING_USER_DEFAULT_FACEBOOK_DATA_MANAGER				@"user_default_facebook_data_manager"
#define STRING_USER_DEFAULT_TWITTER_DATA_MANAGER				@"user_default_twitter_data_manager"
#define STRING_USER_DEFAULT_VERSION_ID                          [NSString stringWithFormat:@"user_default_version_id_%@", STRING_REQUEST_ROOT]
#define STRING_USER_DEFAULT_VERSION_DATE                        @"user_default_version_date"

#define STRING_USER_DEFAULT_ORIENTATION                         @"user_default_orientation"

#define INT_DEFAULT_FIRST_PAGE                                              1
#define INT_DEFAULT_PAGE_SIZE                                               100
#define INT_DEFAULT_COUNTING_DOWN                                           5*60

// Do not use these constant have prefix _. Use the other have same name below.
#define _HEIGHT_IPHONE                                                       480
#define _WIDTH_IPHONE                                                        320
#define _HEIGHT_IPHONE_5                                                     568
#define _WIDTH_IPHONE_5                                                      320
#define _HEIGHT_IPAD                                                         1024
#define _WIDTH_IPAD                                                          768

#define HEIGHT_IPHONE                                                       [SupportFunction getDeviceHeight]
#define WIDTH_IPHONE                                                        [SupportFunction getDeviceWidth]
#define HEIGHT_IPHONE_5                                                     [SupportFunction getDeviceHeight]
#define WIDTH_IPHONE_5                                                      [SupportFunction getDeviceWidth]
#define HEIGHT_IPAD                                                         [SupportFunction getDeviceHeight]
#define WIDTH_IPAD                                                          [SupportFunction getDeviceWidth]
#define HEIGHT_STATUS_BAR                                                   20
#define HEIGHT_TOOL_BAR                                                     44
#define HEIGHT_AD_BANNER                                                    50
#define HEIGHT_TAB_BAR                                                      49

#define HEIGHT_IPHONE_KEYBOARD                                              216
#define HEIGHT_IPHONE_KEYBOARD_LANDSCAPE                                    162
#define HEIGHT_IPAD_KEYBOARD                                                264
#define HEIGHT_IPAD_KEYBOARD_LANDSCAPE                                      352

#define HEIGHT_HOME_VIEW_CONTROLLER_TITLE                                   35
#define HEIGHT_SIMPLE_KARD_NAME_BOTTOM                                      40
#define HEIGHT_KARD_BUILDER_BOTTOM_TABBAR                                   50
#define HEIGHT_KONNECT_BOTTOM_TABBAR                                        50

#define HEIGHT_DEAL_ADS                                                     75

#define WIDTH_KARDS_CELL_AVATAR                                                     70
#define HEIGHT_KARDS_CELL_AVATAR                                                    105
#define HEIGHT_KARDS_CELL_NAME                                                      19
#define MARGIN_KARDS_CELL                                                           35
#define MARGIN_KARDS_CELL_LEFT                                                      20
#define MARGIN_KARDS_CELL_TOP                                                       10
#define MARGIN_KARDS_CELL_RIGHT                                                     5
#define MARGIN_KARDS_CELL_BOTTOM                                                    150

#define WIDTH_VIEW_CELL_VIDEO                                                       100
#define HEIGHT_VIEW_CELL_VIDEO                                                      75

#define HEIGHT_DECK_SIMI_DELAY_VIEW                                                 75
#define HEIGHT_DECK_KARD_BUILD_VIEW                                                 40

#define WIDTH_SEARCH_TREE_KARDS_CELL_AVATAR                                         50
#define HEIGHT_SEARCH_TREE_KARDS_CELL_AVATAR                                        70
#define WIDTH_SEARCH_TREE_ARROW_VIEW                                                8
#define HEIGHT_SEARCH_TREE_ARROW_VIEW                                               11
#define MARGIN_SEARCH_TREE_LEFT                                                     5
#define MARGIN_SEARCH_TREE_KARDS_CELL                                               0

#define HEIGHT_SELECT_KARDS_SCROLL_VIEW                                             50
#define WIDTH_SELECT_KARDS_CELL_VIEW                                                30
#define HEIGHT_SELECT_KARDS_CELL_VIEW                                               45
#define MARGIN_SELECT_KARDS_LEFT                                                    24
#define MARGIN_SELECT_KARDS_CELL_VIEW                                               8

#define HEIGHT_SELECT_KARDS_SCROLL_REPLACE_VIEW                                     80
#define WIDTH_SELECT_KARDS_CELL_REPLACE_VIEW                                        67

#define WIDTH_MULTIPLE_SELECT_KARD_CHECK_BTN                                        19
#define HEIGHT_MULTIPLE_SELECT_KARD_CHECK_BTN                                       19

#define WIDTH_TABLE_KARDS_POPUP_VIEW                                                240
#define HEIGHT_TABLE_KARDS_POPUP_VIEW                                               240

#define INT_RADIUS_SELECTED_KARD_AVATAR                                             3
#define INT_WIDTH_BORDER_SELECTED_KARD_AVATAR                                       1
#define INT_RADIUS_SMALL_AVATAR                                                     6
#define INT_WIDTH_BORDER_SMALL_AVATAR                                               1
#define INT_RADIUS_MEDIUM_AVATAR                                                    11
#define INT_WIDTH_BORDER_MEDIUM_AVATAR                                              2
#define INT_RADIUS_LARGE_AVATAR                                                     16
#define INT_WIDTH_BORDER_LARGE_AVATAR                                               3

#define FONT_SIZE_KARD_LABEL_MINIMUM                                                5
#define FONT_SIZE_KARD_LABEL_CURRENT                                                12

#define REFRESH_HEADER_HEIGHT                                                       60.0
#define REFRESH_FOOTER_HEIGHT                                                       60.0
#define BOTTOM_GRADIENT_HEIGHT                                                      50.0
#define NUMBER_OF_DEALS_PER_SCREEN                                                  3
#define NUMBER_OF_DEALS_PER_LOAD                                                    20
#define CELL_HEIGHT_WITH_DATE_HEADER                                                105
#define CELL_HEIGHT_WITHOUT_DATE_HEADER                                             105
#define MAX_NUMBER_OF_DEALS                                                         100
#define LAST_UPDATE_TIME_FOR_ACTIVE_DEALS                   @"LastUpdateTimeForActiveDeals"
#define LAST_UPDATE_TIME_FOR_ALL_DEALS                      @"LastUpdateTimeForAllDeals"
#define LAST_UPDATE_TIME_FOR_PREVIOUS_DEALS                 @"LastUpdateTimeForPreviousDeals"
#define LOADING_TEXT_PULL                                   @"Pull down to refresh...";
#define LOADING_TEXT_RELEASE                                @"Release to refresh...";
#define LOADING_TEXT_LOADING                                @"Loading...";
#define LOADING_TEXT_OLD_PULL                               @"Pull up to load more...";
#define LOADING_TEXT_OLD_RELEASE                            @"Release to load more...";



#define FRAME(a,b,c,d)                              CGRectMake(a, b, c, d)

#define FRAME_MAIN(view)                     FRAME(0, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_RIGHT(view, dis)               FRAME(dis, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_LEFT(view, dis)                FRAME(-dis, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define FRAME_TOP(view, dis)                 FRAME(view.frame.origin.x, -dis, view.frame.size.width, view.frame.size.height)
#define FRAME_BOTTOM(view, dis)              FRAME(view.frame.origin.x, dis, view.frame.size.width, view.frame.size.height)

#define IMG_DRIVER_01_PIN                   [UIImage imageNamed:@"img_driver_01_pin.png"]
#define IMG_DRIVER_02_PIN                   [UIImage imageNamed:@"img_driver_02_pin.png"]
#define IMG_CLIENT_01_PIN                   [UIImage imageNamed:@"img_client_01_pin.png"]
#define IMG_PIN_DUMMY                       [UIImage imageNamed:@"img_pin_dummy.png"]

#define STRING_ALERT_RETRY                                          @"Retry"
#define STRING_ALERT_CANCEL                                         @"Cancel"
#define STRING_ALERT_OK                                             @"OK"
#define STRING_ALERT_DISMISS                                        @"Dismiss"
#define STRING_ALERT_YES                                            @"Yes"
#define STRING_ALERT_NO                                             @"No"
#define STRING_ALERT_CANCEL                                         @"Cancel"
#define STRING_ALERT_DELETE                                         @"Delete"

#define STRING_ALERT_TITLE_WARNING                                  @"Warning"
#define STRING_ALERT_TITLE_ALERT                                    @"Alert"
#define STRING_ALERT_TITLE_ANNOUNCERMENT                            @"Announcement"
#define STRING_ALERT_TITLE_ERROR                                    @"Error"
#define STRING_ALERT_TITLE_SORRY                                    @"Sorry"
#define STRING_ALERT_TITLE_SUCCESS                                  @"Success"
#define STRING_ALERT_TITLE_FAILURE                                  @"Failure"

#define STRING_CATEGORY_NAME                                        @"name"
#define STRING_CATEGORY_ICON_NAME                                   @"icon"
#define STRING_CATEGORY_ICON_ACTIVE_NAME                            @"iconAct"
#define STRING_CATEGORY_TEMPLATE                                    @"template"
#define STRING_CATEGORY_RED_COLOR                                   @"red"
#define STRING_CATEGORY_GREEN_COLOR                                 @"green"
#define STRING_CATEGORY_BLUE_COLOR                                  @"blue"

#define STRING_ALERT_MESSAGE_CAMERA_PHOTO_NOT_SUPPORTED             @"This device is not supported for Camera or Photo"
#define STRING_ALERT_MESSAGE_CHOOSED_KARD                           @"You have already chosen a Kard"
#define STRING_ALERT_MESSAGE_TURN_ON_LOCATION_SERVICE               @"Please turn on Location Service\n to use this app"
#define STRING_ALERT_MESSAGE_SAVE_SUCCESSFULLY                      @"Save Successful"
#define STRING_ALERT_MESSAGE_TRADE_UNSUCCESSFULLY                   @"Trade Unsuccessful"
#define STRING_ALERT_MESSAGE_APPROVE_UNSUCCESSFULLY                 @"Approve Unsuccessful"
#define STRING_ALERT_MESSAGE_DISAPPROVE_UNSUCCESSFULLY              @"Disapprove Unsuccessful"
#define STRING_ALERT_MESSAGE_CANCEL_UNSUCCESSFULLY                  @"Cancel Unsuccessful"
#define STRING_ALERT_MESSAGE_DELETE_UNSUCCESSFULLY                  @"Delete Unsuccessful"
#define STRING_ALERT_MESSAGE_HIDE_UNSUCCESSFULLY                    @"Hide Unsuccessful"
#define STRING_ALERT_MESSAGE_UNHIDE_UNSUCCESSFULLY                  @"Unhide Unsuccessful"
#define STRING_ALERT_MESSAGE_MAKE_DEFAULT_UNSUCCESSFULLY            @"Make Default Unsuccessful"
#define STRING_ALERT_MESSAGE_DELETE_IS_MY_DEFAULT_KARD              @"This Kard can not be deleted,\n because it is your default Kard.\n  Please select another default Kard prior to delete this Kard"
#define STRING_ALERT_MESSAGE_DELETE_IS_MY_DEFAULT_PROFILE           @"This Profile can not be deleted,\n because it is your default Profile.\n  Please select another default Profile prior to delete this Profile"
#define STRING_ALERT_MESSAGE_UNCHECK_IS_MY_DEFAULT_PROFILE          @"This Profile can not be unchecked,\n because it is your default Profile.\n  Please select another default Profile prior to uncheck this Profile"
#define STRING_ALERT_MESSAGE_EXISTED_KARD_NAME                      @"Sorry, that Kard name is already in use.  Please try again"
#define STRING_ALERT_MESSAGE_KARD_TYPE_ERROR                        @"Sorry, this Kard type is not supported"
#define STRING_ALERT_MESSAGE_KARD_SHARE_SUCCESS                     @"The was share successful"
#define STRING_ALERT_MESSAGE_KARD_SHARE_UNSUCCESS                   @"The share was unsuccessful"

#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_PENDING                @"No Pending Kards"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_ALL             @"No Kards in the Proximity"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_PERSONAL        @"No Kards in Personal"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_BUSINESSES      @"No Kards in Businesses"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_EVENTS          @"No Kards in Events"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_PLACES          @"No Kards in Places"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_FILTER_CUSTOM          @"No Kards in Custom"
#define STRING_ALERT_MESSAGE_KONNECT_NO_KARD_SEARCH                 @"No Kards in Search"

#define STRING_ALERT_MESSAGE_KARD_BUILDER_TOUCH_BACK_BUTTON         @"All data will be lost!\nDo you want to exit"
#define STRING_ALERT_MESSAGE_KARD_BUILDER_IMAGE_AND_PROFILE_MUST_BE_AVAILABLE   @"Kard's image and Kard's profile must be available"
#define STRING_ALERT_MESSAGE_KARD_BUILDER_IMAGE_MUST_BE_AVAILABLE   @"Kard's image must be your avatar"
#define STRING_ALERT_MESSAGE_KARD_BUILDER_PROFILE_MUST_BE_AVAILABLE @"Kard's profile must be available"
#define STRING_ALERT_MESSAGE_KARDS_VIEW_CONTROLLER_DELETE_PENDING_KARD      @"This Kard is Pending approval from the owner.  Do you wish to delete this Kard from Your My Kards Deck?"
#define STRING_ALERT_EMAIL_CAN_NOT_SEND                             @"Your device doesn't support the composer sheet, or devide don't have any account email"
#define STRING_ALERT_SMS_CAN_NOT_SEND                               @"Your device doesn't support sent SMS"
#define STRING_SMS_SHARE_KARD                                       @"ABCCCNCC"
#define STRING_SUBJECT_SHARE_KARD                                   @"SHARE KARD"
#define STRING_SHARE_KARD_MESSAGE_BODY                              @"STRING_MESSAGE_BODY"

#define STRING_ALERT_REGISTRATION_UNSUCCESS                         @"Sorry! Account registration is unsuccessful,  Please try again."
#define STRING_ALERT_REGISTRATION_USER_NAME_ALREADY                 @"Sorry, that username is already registered,  Please try again."
#define STRING_ALERT_REGISTRATION_EMAIL_ALREADY                     @"Sorry, the email address you are using is already registered,  Please try again."
#define STRING_ALERT_RECOVERY_PASSWORD_EMAIL_INVALID                @"Invalid Email"
#define STRING_ALERT_RECOVERY_PASSWORD_SUCCESS                      @"OK, we've sent the password to your email.  Please check your email, then try logging in."
#define STRING_ALERT_LOGIN_USER_NAME_INVALID                        @"Invalid Username"
#define STRING_ALERT_LOGIN_RECOVERY_PASSWORD_SCREEN_REQUIRED        @"Do you want to enter a valid email?"
#define STRING_ALERT_ENTER_EMAIL                                    @"Please enter an email"
#define STRING_ALERT_REPLACE_SUCCESSFULLY                           @"Replace kard successful"
#define STRING_ALERT_REPLACE_UNSUCESSFULLY                          @"Replace kard unsucessful"
#define STRING_ALERT_CHECK_INVATION_CODE_INVALID                    @"Sorry, that code is either invalid or expired"
#define STRING_ALERT_SEND_GIFT_SUCCESS                              @"Deal gift successfully"
#define STRING_ALERT_SEND_GIFT_UNSUCESS                             @"Deal gift unsuccessfully"
#define STRING_EMPTY                                                @""

#define STRING_POPUP_CREATE_NEW_DECK                                @"Create New Deck"
#define STRING_POPUP_PASTE                                          @"Paste"
#define STRING_POPUP_CREATE_NEW_DECK_AND_PASTE                      @"Create New Deck and Paste"
#define STRING_POPUP_REMOVE_FROM_DECK                               @"Remove from Deck"
#define STRING_POPUP_DELETE_THIS_KARD_ENTIRELY                      @"Delete this Kard Entirely"
#define STRING_POPUP_COPY                                           @"Copy"
#define STRING_POPUP_EDIT                                           @"Edit"
#define STRING_POPUP_CANCEL                                         @"Cancel"

#define STRING_COMPARED_NSARRAY_M                                           @"__NSArrayM"
#define STRING_COMPARED_NSCFSTRING                                          @"__NSCFString"
#define STRING_COMPARED_NSCFCONSTANTSTRING                                  @"__NSCFConstantString"
#define STRING_COMPARED_NSCONCRTEMUTABLEDATA                                @"NSConcreteMutableData"
#define STRING_COMPARED_HOME_VIEW_CONTROLLER                                @"HomeViewController"
#define STRING_COMPARED_KARDS_VIEW_CONTROLLER                               @"KardsViewController"
#define STRING_COMPARED_DECK_KARDS_VIEW_CONTROLLER                          @"DeckKardsViewController"
#define STRING_COMPARED_KARDS_NODE_DATA                                     @"KardsNodeData"
#define STRING_COMPARED_KARDS_CATEGORY_DATA                                 @"KardsCategoryData"

//#define STRING_IMG_DECK_DUMMY                                               @"bg_kard_grid_9_deck.png"
#define STRING_IMG_DECK_DUMMY                                               @"bg_deck_dummy.png"
#define STRING_IMG_KARD_DUMMY                                               @"bg_kard_thumb.png"
//#define STRING_IMG_KARD_DUMMY_SMALL                                         @"img_kard_dummy_84x115.png"
//#define STRING_IMG_KARD_DUMMY_MEDIUM                                        @"img_kard_dummy_224x381.png"
//#define STRING_IMG_KARD_DUMMY_LARGE                                         @"img_kard_dummy_320x460.png"
#define STRING_IMG_KARD_DUMMY_SMALL                                         @"kard-default.png"
#define STRING_IMG_KARD_DUMMY_MEDIUM                                        @"kard-default.png"
#define STRING_IMG_KARD_DUMMY_LARGE                                         @"kard-default.png"
#define STRING_IMG_KARDS_VIEW_CONTROLLER                                    @"btn_home_kard.png"
#define STRING_IMG_SEARCH_TREE_ARROW                                        @"img_arrow_right_white.png"
#define STRING_IMG_SELECT_KARDS_ARROW_LEFT                                  @"icon_konnect_arrow_back_kard.png"
#define STRING_IMG_SELECT_KARDS_ARROW_RIGHT                                 @"icon_konnect_arrow_next_kard.png"
#define STRING_IMG_HOME_VIEW_CONTROLLER                                     @"Default.png"
#define STRING_IMG_SIMI_DELAY_VIEW_BG_DARK                                  @"pg_pixel_transparent.png"
#define STRING_IMG_SIMI_DELAY_VIEW_BG                                       @"pixel_transparent.png"
#define STRING_IMG_POPUP_VIEW_BTN_BLACK_BACKGROUND                          @"bg_button_black_tap_popup.png"
#define STRING_IMG_POPUP_VIEW_BTN_GREEN_BACKGROUND                          @"bg_button_green_tap_popup.png"
#define STRING_IMG_UNSELECTED_BTN_BACKGROUND                                @"head_bg_bar.png"
#define STRING_IMG_SELECTED_BTN_BACKGROUND                                  @"bg_bar_btn_select.png"
#define STRING_IMG_TOP_BACKGROUND                                           @"bg_top_background.png"
#define STRING_IMG_BOTTOM_BACKGROUND                                        @"bg_bottom_background.png"
#define STRING_IMG_MID_BACKGROUND                                           @"bg_mid_background.png"
#define STRING_IMG_TOP_BACKGROUND_NEW                                       @"bg_top_new.png"
#define STRING_IMG_BOT_BACKGROUND_NEW                                       @"bg_bot_new.png"
#define STRING_IMG_MID_BACKGROUND_NEW                                       @"bg_mid_new.png"
#define STRING_IMG_NONE                                                     @"bg_main_background.png"
#define STRING_IMG_CAMERA                                                   @"comment_cam.png"

#define STRING_ID_FB_FORMATTER(id)                      [NSString stringWithFormat:@"fb_%@", id]
#define STRING_ID_TW_FORMATTER(id)                      [NSString stringWithFormat:@"tw_%@", id]

#define STRING_DEALS_TITLE                                      @"Deals"
#define STRING_MYKARDS_TITLE                                    @"My Kards"
#define STRING_KONNECT_TITLE                                    @"Konnect"
#define STRING_PROFILE_MANAGER_TITLE                            @"Profile Manager"
#define STRING_MY_DEALS_TITLE                                   @"My Deals"

#define STRING_MSS_KARD_BUILDER_TIP                                         @"Click here to \nbuild a Kard"

#define STRING_LOCATION_LATITUDE_DEFAULT                        @"+10.773000"
#define STRING_LOCATION_LONGTITUDE_DEFAULT                      @"106.677700"
//#define STRING_LOCATION_LATITUDE_DEFAULT                        @"+10.805476" // real for test
//#define STRING_LOCATION_LONGTITUDE_DEFAULT                      @"106.645678" // real for test

#define STRING_TRADE_NOTIFICATION_TIP                           @"SWIPE TO APPROVE"

#define FLAG_INIT                                                               1

#define kthumbnailWidth                                                         80
#define kthumbnailHeight                                                        80
#define kImagesPerRow                                                           3

#define STRING_PERSONAL_KARD                                                1
#define STRING_BUSINESS_KARD                                                2
#define STRING_EVENT_KARD                                                   3
#define STRING_DEAL_KARD                                                    4
#define STRING_PLACE_KARD                                                   6


#define STRING_MAP_PANE                                                     @"map_pane"
#define STRING_DATE_TIME_PANE                                               @"date_pane"
#define STRING_PROMOTED_PANE                                                @"promoted_pane"

#define STRING_MAP_ICON                                                     @"map_icon"
#define STRING_DATE_TIME_ICON                                               @"date_icon"
#define STRING_PROMOTED_ICON                                                @"promoted_icon"

#define UIColorFromRGB(rgbValue)                    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define SOUND_PAGING_ANIMATION_CURL_UP                                      @"paging_animation_curl_up.mp3"

typedef enum
{
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_INVALID,
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_HOME_SCREEN,
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_KARDS_VIEW_CONTROLLER,
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_DECK_VIEW_CONTROLLER,
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_SIMPLE_KARD_VIEW_CONTROLLER,
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_KARD_BUILDER_VIEW_CONTROLLER,
    
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_KONNECT_VIEW_CONTROLLER,
    
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_DEALS_VIEW_CONTROLLER,
    
    ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE_NEWS_VIEW_CONTROLLER
}ENUM_APP_VIEW_CONTROLLER_SCREEN_TYPE;

typedef enum
{
    ENUM_APP_VIEW_CONTROLLER_STEP_INVALID,
    ENUM_APP_VIEW_CONTROLLER_STEP_UPDATE_USER_LOCATION,
    ENUM_APP_VIEW_CONTROLLER_STEP_GET_USER_PROFILE,
    ENUM_APP_VIEW_CONTROLLER_STEP_UPDATE_USER_ONLINE_STATUS,
    ENUM_APP_VIEW_CONTROLLER_STEP_END
}ENUM_APP_VIEW_CONTROLLER_STEP;

typedef enum
{
    ENUM_API_REQUESTER_STEP_INVALID,
    ENUM_API_REQUESTER_STEP_REQUEST,
    ENUM_API_REQUESTER_STEP_REQUEST_WAITING,
    ENUM_API_REQUESTER_STEP_FAILED,
    ENUM_API_REQUESTER_STEP_FINISHED,
    ENUM_API_REQUESTER_STEP_TIMEOUT,
    ENUM_API_REQUESTER_STEP_ALERT_SHOWING,
    ENUM_API_REQUESTER_STEP_END
}ENUM_API_REQUESTER_STEP;

typedef enum
{
    ENUM_API_REQUEST_TYPE_INVALID,
    ENUM_API_REQUEST_TYPE_FB_GET_PROFILE,
    ENUM_API_REQUEST_TYPE_TW_GET_PROFILE,
    ENUM_API_REQUEST_TYPE_USER_GET_ALL,
    ENUM_API_REQUEST_TYPE_USER_REGISTER,
    ENUM_API_REQUEST_TYPE_USER_LOGIN,
    ENUM_API_REQUEST_TYPE_USER_LOGOUT,
	ENUM_API_REQUEST_TYPE_USER_LOGIN_WITH_FB_TW,
    ENUM_API_REQUEST_TYPE_USER_UPDATE_LOCATION,
    ENUM_API_REQUEST_TYPE_USER_GET_PROFILE,
    ENUM_API_REQUEST_TYPE_USER_GET_BANNER_ADS,
    ENUM_API_REQUEST_TYPE_USER_UPDATE_ONLINE_STATUS,
    ENUM_API_REQUEST_TYPE_USER_FULL_NAME,
    ENUM_API_REQUEST_TYPE_USER_RECOVER_PASSWORD,
    ENUM_API_REQUEST_TYPE_CHECK_INVATION_CODE,
    ENUM_API_REQUEST_TYPE_USER_FORGET_PASSWORD,
    
    // push notification
    ENUM_API_REQUEST_TYPE_NOTIFICATION_UPDATE_DEVICE_TOKEN,
    
    // CLIENT
    ENUM_API_REQUEST_TYPE_CLIENT_GET_CLOSEST_DRIVER,
    ENUM_API_REQUEST_TYPE_CLIENT_REQUEST_CLOSEST_DRIVER,
    ENUM_API_REQUEST_TYPE_CLIENT_REQUEST_DRIVER,
    ENUM_API_REQUEST_TYPE_CLIENT_CANCEL_DRIVER,
    ENUM_API_REQUEST_TYPE_CLIENT_REQUEST_THIS_DRIVER,
    ENUM_API_REQUEST_TYPE_CLIENT_CANCEL_THE_REQUEST,
    ENUM_API_REQUEST_TYPE_CLIENT_CANCEL_THIS_TRANSACTION,
    ENUM_API_REQUEST_TYPE_CLIENT_CHARGE_BILL,
    
    // DRIVER
    ENUM_API_REQUEST_TYPE_DRIVER_GET_CLOSEST_CLIENT,
    ENUM_API_REQUEST_TYPE_DRIVER_ACCEPT_THIS_TRANSACTION,
    ENUM_API_REQUEST_TYPE_DRIVER_CANCEL_THIS_TRANSACTION,
    ENUM_API_REQUEST_TYPE_DRIVER_NOTIFY_YOUR_ARRIVAL,
    ENUM_API_REQUEST_TYPE_DRIVER_BEGIN_TRIP,
    ENUM_API_REQUEST_TYPE_DRIVER_SEND_BILL,
    
    // NUM
    ENUM_API_REQUEST_TYPE_FEEDS_CHECK_TOTAL_NUMBER
}ENUM_API_REQUEST_TYPE;

typedef enum
{
    ENUM_APP_BACKGROUND_STATE_INVALID,
    ENUM_APP_BACKGROUND_STATE_DID_ENTER,
    ENUM_APP_BACKGROUND_STATE_TIMER_ACTIVE_BEFORE_ENTERING_FOREGROUND,
    ENUM_APP_BACKGROUND_STATE_ENTER_FOREGROUND,
    ENUM_APP_BACKGROUND_STATE_TIMER_ACTIVE_AFTER_ENTERING_FOREGROUND
}ENUM_APP_BACKGROUND_STATE;

typedef enum
{
    ENUM_MEDIA_TYPE_VIDEO = 1,
    ENUM_MEDIA_TYPE_AUDIO,
    ENUM_MEDIA_TYPE_PHOTO
}ENUM_MEDIA_TYPE;

typedef enum {
    ENUM_KEYBOARD_STATUS_INVALID,
    ENUM_KEYBOARD_STATUS_FORCE_HIDE,
    ENUM_KEYBOARD_STATUS_RETURN,
    ENUM_KEYBOARD_STATUS_RETURN_AND_DID_BEGIN_EDITING,
    ENUM_KEYBOARD_STATUS_DID_END_EDITING,
    ENUM_KEYBOARD_STATUS_DID_BEGIN_EDITING
}ENUM_KEYBOARD_STATUS;

typedef enum
{
    ENUM_DEAL_LAST_STATUS_INVALID,
    ENUM_DEAL_LAST_STATUS_LOCATION,
    ENUM_DEAL_LAST_STATUS_USER_SELECT,
}ENUM_DEAL_LAST_STATUS;

typedef enum
{
    ENUM_CITY_TABLE_BY_NAME,
    ENUM_CITY_TABLE_BY_DISTANCE,
}ENUM_CITY_TABLE;

@protocol AppViewControllerProtocol <NSObject>
@optional
- (void)update;
- (void)updateOnlyForForeground;
@end

typedef enum {
    enumRemoveNotificationType_Invalid = 0,
    enumRemoveNotificationType_ClientRequestDriver = 1,
    enumRemoveNotificationType_DriverAcceptTheRequest = 2,
    enumRemoveNotificationType_CancelThisTransation = 3,
    enumRemoveNotificationType_DriverNotifyYourArrivalClientPopup = 5,
    enumRemoveNotificationType_DriverSendBill = 6,
    enumRemoveNotificationType_DriverNotifyYourArrivalDriverPopup,
    enumRemoveNotificationType_ClientCountDownPopup,
    enumRemoveNotificationType_DriverCountDownPopup,
    enumRemoveNotificationType_DriverSendBillPopup,
    enumRemoveNotificationType_ClientReceiveBillPopup
}enumRemoveNotificationType;
