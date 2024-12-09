import 'dart:async';
import 'dart:io';
import 'package:InstiApp/src/api/model/UserTag.dart';
import 'package:InstiApp/src/api/model/achievements.dart';
import 'package:InstiApp/src/api/model/body.dart';
import 'package:InstiApp/src/api/model/buynsellPost.dart';
import 'package:InstiApp/src/api/model/community.dart';
import 'package:InstiApp/src/api/model/communityPost.dart';
import 'package:InstiApp/src/api/model/event.dart';
import 'package:InstiApp/src/api/model/lostandfoundPost.dart';
import 'package:InstiApp/src/api/model/mess.dart';
import 'package:InstiApp/src/api/model/messCalEvent.dart';
import 'package:InstiApp/src/api/model/notification.dart';
import 'package:InstiApp/src/api/model/offeredAchievements.dart';
import 'package:InstiApp/src/api/model/post.dart';
import 'package:InstiApp/src/api/model/user.dart';
import 'package:InstiApp/src/api/model/venter.dart';
import 'package:InstiApp/src/api/model/venue.dart';
import 'package:InstiApp/src/api/request/ach_verify_request.dart';
import 'package:InstiApp/src/api/request/achievement_create_request.dart';
import 'package:InstiApp/src/api/request/achievement_hidden_patch_request.dart';
import 'package:InstiApp/src/api/request/action_community_post_request.dart';
import 'package:InstiApp/src/api/request/chatbotlog_request.dart';
import 'package:InstiApp/src/api/request/comment_create_request.dart';
import 'package:InstiApp/src/api/request/complaint_create_request.dart';
import 'package:InstiApp/src/api/request/event_create_request.dart';
import 'package:InstiApp/src/api/request/postFAQ_request.dart';
import 'package:InstiApp/src/api/request/update_community_post_request.dart';
import 'package:InstiApp/src/api/request/user_fcm_patch_request.dart';
import 'package:InstiApp/src/api/request/user_scn_patch_request.dart';
import 'package:InstiApp/src/api/response/achievement_create_response.dart';
import 'package:InstiApp/src/api/response/alumni_login_response.dart';
import 'package:InstiApp/src/api/response/community_post_list_response.dart';
import 'package:InstiApp/src/api/response/event_create_response.dart';
import 'package:InstiApp/src/api/response/explore_response.dart';
import 'package:InstiApp/src/api/response/getencr_response.dart';
import 'package:InstiApp/src/api/response/image_upload_response.dart';
import 'package:InstiApp/src/api/response/news_feed_response.dart';
import 'package:InstiApp/src/api/response/secret_response.dart';
import 'package:InstiApp/src/api/response/user_tags_reach_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart' as rt;

import 'model/offersecret.dart';

part 'apiclient.g.dart';

@rt.RestApi(baseUrl: "http://127.0.0.1:8000/api")
// @rt.RestApi(baseUrl: "http://10.198.49.150/api")
// @rt.RestApi(baseUrl: "https://gymkhana.iitb.ac.in/instiapp/api")
// @rt.RestApi(baseUrl: "https://dcae-2405-201-5004-30e9-a45d-9897-ea81-3414.ngrok-free.app/api")
abstract class InstiAppApi {
  factory InstiAppApi(Dio dio, {String baseUrl}) = _InstiAppApi;

  @rt.GET("/mess")
  Future<List<Hostel>> getHostelMess();

  @rt.GET("/pass-login")
  Future<Session> passwordLogin(@rt.Query("username") String username,
      @rt.Query("password") String password);

  @rt.GET("/pass-login")
  Future<Session> passwordLoginFcm(@rt.Query("username") String username,
      @rt.Query("password") String password, @rt.Query("fcm_id") String fcmId);

  @rt.GET("/login")
  Future<Session> login(
      @rt.Query('code') String code, @rt.Query('redir') String redir);
  @rt.GET("/alumniLogin")
  Future<AlumniLoginResponse> AlumniLogin(
    @rt.Query("ldap") String ldap,
  );

  @rt.GET("/alumniOTP")
  Future<AlumniLoginResponse> AlumniOTP(
    @rt.Query("ldap") String ldap,
    @rt.Query("otp") String otp,
  );

  @rt.GET("/resendAlumniOTP")
  Future<AlumniLoginResponse> ResendAlumniOTP(
    @rt.Query("ldap") String ldap,
  );

  @rt.GET("/placement-blog")
  Future<List<PlacementBlogPost>> getPlacementBlogFeed(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("from") int from,
      @rt.Query("num") int number,
      @rt.Query("query") String query);

  @rt.GET("/external-blog")
  Future<List<ExternalBlogPost>> getExternalBlogFeed(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("from") int from,
      @rt.Query("num") int number,
      @rt.Query("query") String query);

  @rt.GET("/training-blog")
  Future<List<TrainingBlogPost>> getTrainingBlogFeed(
      @rt.Header("Cookie") String sessionID,
      @rt.Query("from") int from,
      @rt.Query("num") int num,
      @rt.Query("query") String query);

  // Events
  @rt.GET("/events/{uuid}")
  Future<Event> getEvent(
      @rt.Header("Cookie") String sessionId, @rt.Path() String uuid);
  @rt.PUT('/events/{uuid}')
  Future<EventCreateResponse> updateEvent(@rt.Header('Cookie') String sessionId,
      @rt.Body() EventCreateRequest event, @rt.Path() String uuid);
  @rt.POST("/events")
  Future<EventCreateResponse> postEventForm(
      @rt.Header("Cookie") String sessionId,
      @rt.Body() EventCreateRequest eventCreateRequest);
  @rt.DELETE('/events/{uuid}')
  Future<void> deleteEvent(
      @rt.Header('Cookie') String sessionId, @rt.Path() String uuid);
  @rt.POST('/events/{uuid}/approve-mail')
  Future<void> pushMail(
    @rt.Header("Cookie") String sessionId,
    @rt.Path() String uuid,
  );
  @rt.POST('/events/{uuid}/reject-mail')
  Future<void> rejectMail(
    @rt.Header("Cookie") String sessionId,
    @rt.Path() String uuid,
  );

  @rt.GET("/events")
  Future<NewsFeedResponse> getNewsFeed(@rt.Header("Cookie") String sessionId);

  @rt.GET("/events")
  Future<NewsFeedResponse> getEventsBetweenDates(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("start") String start,
      @rt.Query("end") String end);

  @rt.GET("/getUserMess")
  Future<List<MessCalEvent>> getMessEventsBetweenDates(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("start") String start,
      @rt.Query("end") String end);

  @rt.GET("/getEncr")
  Future<GetEncrResponse> getEncr(@rt.Header("Cookie") String sessionId);

  @rt.POST("/events")
  Future<EventCreateResponse> createEvent(@rt.Header("Cookie") String sessionId,
      @rt.Body() EventCreateRequest eventCreateRequest);

  // Venues
  @rt.GET("/locations")
  Future<List<Venue>> getAllVenues();

  @rt.GET("/locations/{id}")
  Future<List<Venue>> getVenue(@rt.Path() String id);

  // Users
  @rt.GET("/users/{uuid}")
  Future<User> getUser(
      @rt.Header("Cookie") String sessionId, @rt.Path() String uuid);

  // Bodies
  @rt.GET("/bodies/{uuid}")
  Future<Body> getBody(
      @rt.Header("Cookie") String sessionId, @rt.Path() String uuid);

  @rt.GET("/bodies")
  Future<List<Body>> getAllBodies(@rt.Header("Cookie") String sessionId);

  @rt.GET("/bodies/{bodyID}/follow")
  Future<void> updateBodyFollowing(@rt.Header("Cookie") String sessionID,
      @rt.Path("bodyID") String eventID, @rt.Query("action") int action);

  // Image upload
  @rt.POST("/upload")
  @rt.MultiPart()
  Future<ImageUploadResponse> uploadImage(
      @rt.Header("Cookie") String sessionID, @rt.Part() File picture);

  // My data
  @rt.GET("/user-me")
  Future<User> getUserMe(@rt.Header("Cookie") String sessionID);

  @rt.GET("/user-me/ues/{eventID}")
  Future<void> updateUserEventStatus(@rt.Header("Cookie") String sessionID,
      @rt.Path() String eventID, @rt.Query("status") int status);

  @rt.GET("/user-me/unr/{postID}")
  Future<void> updateUserNewsReaction(@rt.Header("Cookie") String sessionID,
      @rt.Path() String postID, @rt.Query("reaction") int reaction);

  @rt.POST("/user-me/ucr/")
  Future<void> updateUserChatBotReaction(@rt.Header("Cookie") String sessionID,
      @rt.Body() ChatBotLogRequest chatBotLogRequest);

  @rt.PATCH("/user-me")
  Future<User> patchFCMUserMe(@rt.Header("Cookie") String sessionID,
      @rt.Body() UserFCMPatchRequest userFCMPatchRequest);

  @rt.PATCH("/user-me")
  Future<User> patchSCNUserMe(@rt.Header("Cookie") String sessionID,
      @rt.Body() UserSCNPatchRequest userSCNPatchRequest);

  @rt.GET("/news")
  Future<List<NewsArticle>> getNews(
      @rt.Header("Cookie") String sessionID,
      @rt.Query("from") int from,
      @rt.Query("num") int num,
      @rt.Query("query") String query);

  @rt.GET("/notifications")
  Future<List<Notification>> getNotifications(
      @rt.Header("Cookie") String sessionID);

  @rt.GET("/notifications/read/{notificationID}")
  Future<void> markNotificationRead(
      @rt.Header("Cookie") String sessionID, @rt.Path() String notificationID);

  @rt.GET("/notifications/read")
  Future<void> markAllNotificationsRead(@rt.Header("Cookie") String sessionID);

  @rt.GET("/logout")
  Future<void> logout(@rt.Header("Cookie") String sessionID);

  // Explore search
  @rt.GET("/search")
  Future<ExploreResponse> search(
      @rt.Header("Cookie") String sessionID, @rt.Query("query") String query);

  @rt.GET("/search")
  Future<ExploreResponse> searchType(@rt.Header("Cookie") String sessionID,
      @rt.Query("query") String query, @rt.Query("types") String type);

  // Venter
  @rt.GET("/venter/complaints")
  Future<List<Complaint>> getAllComplaints(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("from") int from,
      @rt.Query("num") int number,
      @rt.Query("search") String query);

  @rt.GET("/venter/complaints?filter=me")
  Future<List<Complaint>> getUserComplaints(
      @rt.Header("Cookie") String sessionId);

  @rt.GET("/venter/complaints/{complaintId}")
  Future<Complaint> getComplaint(
      @rt.Header("Cookie") String sessionId, @rt.Path() String complaintId);

  @rt.GET("/venter/complaints/{complaintId}/upvote")
  Future<Complaint> upVote(@rt.Header("Cookie") String sessionId,
      @rt.Path() String complaintId, @rt.Query("action") int count);

  @rt.GET("/venter/complaints/{complaintId}/subscribe")
  Future<Complaint> subscribleToComplaint(@rt.Header("Cookie") String sessionId,
      @rt.Path() String complaintId, @rt.Query("action") int count);

  @rt.POST("/venter/complaints")
  Future<Complaint> postComplaint(@rt.Header("Cookie") String sessionId,
      @rt.Body() ComplaintCreateRequest complaintCreateRequest);

  @rt.POST("/venter/complaints/{complaintId}/comments")
  Future<Comment> postComment(
      @rt.Header("Cookie") String sessionId,
      @rt.Path() String complaintId,
      @rt.Body() CommentCreateRequest commentCreateRequest);

  @rt.PUT("/venter/comments/{commentId}")
  Future<Comment> updateComment(
      @rt.Header("Cookie") String sessionId,
      @rt.Path() String commentId,
      @rt.Body() CommentCreateRequest commentCreateRequest);

  @rt.DELETE("/venter/comments/{commentId}")
  Future<void> deleteComment(
      @rt.Header("Cookie") String sessionId, @rt.Path() String commentId);

  @rt.GET("/venter/tags")
  Future<List<TagUri>> getAllTags(@rt.Header("Cookie") String sessionId);

  @rt.POST("/achievements")
  Future<AchievementCreateResponse> postForm(
      @rt.Header("Cookie") String sessionId,
      @rt.Body() AchievementCreateRequest achievementCreateRequest);
  @rt.PUT('/achievements-offer/{id}')
  Future<dynamic> updateAchievement(@rt.Header('Cookie') String sessionId,
      @rt.Body() OfferedAchievements offeredAchievements, @rt.Path() String id);
  @rt.POST("/achievements-offer/{id}")
  Future<SecretResponse> postAchievementOffer(
      @rt.Header("Cookie") String sessionId,
      @rt.Path() String id,
      @rt.Body() Offersecret secret);

  @rt.POST("/interests")
  Future<SecretResponse> postInterests(
      @rt.Header("Cookie") String sessionId, @rt.Body() Interest interest);

  @rt.DELETE("/interests/{title}")
  Future<SecretResponse> postDelInterests(
      @rt.Header("Cookie") String sessionId, @rt.Path() String title);

  @rt.GET("/achievements")
  Future<List<Achievement>> getYourAchievements(
      @rt.Header("Cookie") String sessionId);

  @rt.PATCH("/achievements/{id}")
  Future<void> toggleHidden(@rt.Header("Cookie") String sessionID,
      @rt.Path() String id, @rt.Body() AchievementHiddenPathRequest hidden);

  @rt.GET("/achievements-body/{id}")
  Future<List<Achievement>> getBodyAchievements(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);

  @rt.PUT("/achievements/{id}")
  Future<void> dismissAchievement(@rt.Header("Cookie") String? sessionID,
      @rt.Path() String? id, @rt.Body() AchVerifyRequest achievement);

  @rt.DELETE("/achievements-offer/{id}")
  Future<void> deleteAchievement(
      @rt.Header("Cookie") String sessionID, @rt.Path() String id);

  @rt.GET("/query")
  Future<List<Query>> getQueries(
      @rt.Header("Cookie") String sessionID,
      // @QueryParam("from") int from,
      // @QueryParam("num") int num,
      @rt.Query("query") String query,
      @rt.Query("category") String category);

  @rt.POST("/query/add")
  Future<void> postFAQ(
      @rt.Header("Cookie") String sessionId, @rt.Body() PostFAQRequest request);

  @rt.GET("/query/categories")
  Future<List<String>> getQueryCategories(
      @rt.Header("Cookie") String sessionId);

  @rt.GET("/communities")
  Future<List<Community>> getCommunities(@rt.Header("Cookie") String sessionId);

  @rt.GET("/communities/{id}")
  Future<Community> getCommunity(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);

  @rt.GET("/communityposts")
  Future<CommunityPostListResponse> getCommunityPosts(
      @rt.Header("Cookie") String sessionId,
      @rt.Query("status") int? status,
      @rt.Query("query") String query,
      @rt.Query("community") String id);

  @rt.GET("/communityposts/{id}")
  Future<CommunityPost> getCommunityPost(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);

  @rt.POST("/communityposts")
  Future<void> createCommunityPost(
      @rt.Header("Cookie") String sessionId, @rt.Body() CommunityPost post);

  @rt.PUT("/communityposts/{id}")
  Future<void> updateCommunityPost(
    @rt.Header("Cookie") String sessionId,
    @rt.Path() String id,
    @rt.Body() CommunityPost post,
  );

  @rt.PUT("/communityposts/{action}/{id}")
  Future<void> updateCommunityPostAction(
      @rt.Header("Cookie") String sessionId,
      @rt.Path() String id,
      @rt.Path() String action,
      @rt.Body() ActionCommunityPostRequest data);

  @rt.PUT("/communityposts/moderator/{id}")
  Future<void> updateCommunityPostStatus(@rt.Header("Cookie") String sessionId,
      @rt.Path() String id, @rt.Body() UpdateCommunityPostRequest data);

  @rt.GET("/user-me/ucpr/{postID}")
  Future<void> updateUserCommunityPostReaction(
      @rt.Header("Cookie") String sessionID,
      @rt.Path() String postID,
      @rt.Query("reaction") int reaction);
  @rt.GET("/user-tags")
  Future<List<UserTagHolder>> getUserTags(
      @rt.Header("Cookie") String sessionId);

  @rt.POST("/user-tags/reach")
  Future<UserTagsReachResponse> getUserTagsReach(
      @rt.Header("Cookie") String sessionId,
      @rt.Body() List<int> selectedTagIds);

  @rt.POST('/achievements-offer')
  Future<dynamic> createAchievement(
      sessionId, @rt.Body() OfferedAchievements offeredAchievements);

//Buy & Sell
  @rt.GET('/buy/products')
  Future<List<BuynSellPost>> getBuynSellPosts(
      @rt.Header("Cookie") String sessionId);

  @rt.GET('/buy/products/{id}')
  Future<BuynSellPost> getBuynSellPost(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);

  @rt.DELETE('/buy/products/{id}')
  Future<BuynSellPost> deleteBuynSellPost(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);

  @rt.PUT('/buy/products/{id}')
  Future<BuynSellPost> updateBuynSellPost(@rt.Header("Cookie") String sessionId,
      @rt.Path() String id, @rt.Body() BuynSellPost post);

  @rt.POST("/buy/products")
  Future<BuynSellPost> createBuynSellPost(
      @rt.Header("Cookie") String sessionId, @rt.Body() BuynSellPost post);

  //Lost & Found
  @rt.GET('/lnf/products')
  Future<List<LostAndFoundPost>> getLostAndFoundPosts(
      @rt.Header("Cookie") String sessionId);

  @rt.GET('/lnf/products/{id}')
  Future<LostAndFoundPost> getLostAndFoundPost(
      @rt.Header("Cookie") String sessionId, @rt.Path() String id);
}
