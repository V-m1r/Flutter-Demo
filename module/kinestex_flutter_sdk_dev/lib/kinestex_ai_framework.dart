import 'package:flutter/material.dart';
import 'generic_web_view.dart';
import 'kinestex_sdk.dart';

class KinesteXAIFramework {

  static Widget createMainView(
      {required String apiKey,
      required String companyName,
      required String userId,
      PlanCategory planCategory = PlanCategory.Cardio,
      UserDetails? user,
      Map<String, dynamic>? customParams,
      required ValueNotifier<bool> isLoading,
      required ValueNotifier<bool> isShowKinestex,
      required Function(WebViewMessage) onMessageReceived}) {
    final validationError = _validateInput(
      apiKey: apiKey,
      companyName: companyName,
      userId: userId,
      planCategory: planCategory,
    );

    if (validationError != null) {
      print("⚠️ Validation Error: $validationError");
      return Container();
    } else {
      final data = <String, dynamic>{
        'planC': planCategoryString(planCategory),
        if (user != null) ...{
          'age': user.age,
          'height': user.height,
          'weight': user.weight,
          'gender': genderString(user.gender),
          'lifestyle': lifestyleString(user.lifestyle),
        },
      };

      validateCustomParams(customParams, data);

      return GenericWebView(
        apiKey: apiKey,
        companyName: companyName,
        userId: userId,
        url: "https://kinestex.vercel.app",
        data: data,
        isLoading: isLoading,
        onMessageReceived: onMessageReceived,
        showKinesteX: isShowKinestex
      );
    }
  }

  static Widget createPlanView({
    required String apiKey,
    required String companyName,
    required String userId,
    required String planName,
    UserDetails? user,
    Map<String, dynamic>? customParams,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> isShowKinestex,
    required Function(WebViewMessage) onMessageReceived,
  }) {
    if (containsDisallowedCharacters(apiKey) ||
        containsDisallowedCharacters(companyName) ||
        containsDisallowedCharacters(userId) ||
        containsDisallowedCharacters(planName)) {
      print(
          "⚠️ Validation Error: apiKey, companyName, userId, or planName contains disallowed characters");
      return Container();
    } else {
      final adjustedPlanName = planName.replaceAll(' ', '%20');
      final url = "https://kinestex.vercel.app/plan/$adjustedPlanName";
      final data = <String, dynamic>{
        if (user != null) ...{
          'age': user.age,
          'height': user.height,
          'weight': user.weight,
          'gender': genderString(user.gender),
          'lifestyle': lifestyleString(user.lifestyle),
        },
      };

      validateCustomParams(customParams, data);

      return GenericWebView(
          apiKey: apiKey,
          companyName: companyName,
          showKinesteX: isShowKinestex,
          userId: userId,
          url: url,
          data: data,
          isLoading: isLoading,
          onMessageReceived: onMessageReceived
      );
    }
  }

  static Widget createWorkoutView(
      {required String apiKey,
      required String companyName,
      required String userId,
      required String workoutName,
      UserDetails? user,
      Map<String, dynamic>? customParams,
      required ValueNotifier<bool> isShowKinestex,
      required ValueNotifier<bool> isLoading,
      required Function(WebViewMessage) onMessageReceived}) {
    if (containsDisallowedCharacters(apiKey) ||
        containsDisallowedCharacters(companyName) ||
        containsDisallowedCharacters(userId) ||
        containsDisallowedCharacters(workoutName)) {
      print(
          "⚠️ Validation Error: apiKey, companyName, userId, or workoutName contains disallowed characters");
      return Container();
    } else {
      final adjustedWorkoutName = workoutName.replaceAll(' ', '%20');
      final url = "https://kinestex.vercel.app/workout/$adjustedWorkoutName";
      final data = <String, dynamic>{
        if (user != null) ...{
          'age': user.age,
          'height': user.height,
          'weight': user.weight,
          'gender': genderString(user.gender),
          'lifestyle': lifestyleString(user.lifestyle),
        },
      };

      validateCustomParams(customParams, data);

      return GenericWebView(
          apiKey: apiKey,
          companyName: companyName,
          showKinesteX: isShowKinestex,
          userId: userId,
          url: url,
          data: data,
          isLoading: isLoading,
          onMessageReceived: onMessageReceived
      );
    }
  }

  static Widget createChallengeView(
      {required String apiKey,
      required String companyName,
      required String userId,
      String exercise = "Squats",
      required int countdown,
      UserDetails? user,
      Map<String, dynamic>? customParams,
      required ValueNotifier<bool> isShowKinestex,
      required ValueNotifier<bool> isLoading,
      required Function(WebViewMessage) onMessageReceived}) {
    if (containsDisallowedCharacters(apiKey) ||
        containsDisallowedCharacters(companyName) ||
        containsDisallowedCharacters(userId) ||
        containsDisallowedCharacters(exercise)) {
      print(
          "⚠️ Validation Error: apiKey, companyName, userId, or exercise contains disallowed characters");
      return Container();
    } else {
      final data = <String, dynamic>{
        'exercise': exercise,
        'countdown': countdown,
        if (user != null) ...{
          'age': user.age,
          'height': user.height,
          'weight': user.weight,
          'gender': genderString(user.gender),
          'lifestyle': lifestyleString(user.lifestyle),
        },
      };

      validateCustomParams(customParams, data);

      return GenericWebView(
          apiKey: apiKey,
          showKinesteX: isShowKinestex,
          companyName: companyName,
          userId: userId,
          url: "https://kinestex-challenge.vercel.app",
          data: data,
          isLoading: isLoading,
          onMessageReceived: onMessageReceived
      );
    }
  }

  static Widget createCameraComponent({
    required String apiKey,
    required String companyName,
    required String userId,
    required List<String> exercises,
    required String currentExercise,
    UserDetails? user,
    Map<String, dynamic>? customParams,
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<bool> isShowKinestex,
    required Function(WebViewMessage) onMessageReceived,
    String? updatedExercise,
  }) {
    for (final exercise in exercises) {
      if (containsDisallowedCharacters(exercise)) {
        print("⚠️ Validation Error: $exercise contains disallowed characters");
        return Container();
      }
    }

    if (containsDisallowedCharacters(apiKey) ||
        containsDisallowedCharacters(companyName) ||
        containsDisallowedCharacters(userId) ||
        containsDisallowedCharacters(currentExercise)) {
      print(
          "⚠️ Validation Error: apiKey, companyName, userId, or currentExercise contains disallowed characters");
      return Container();
    } else {
      final data = <String, dynamic>{
        'exercises': exercises,
        'currentExercise': currentExercise,
        if (user != null) ...{
          'age': user.age,
          'height': user.height,
          'weight': user.weight,
          'gender': genderString(user.gender),
          'lifestyle': lifestyleString(user.lifestyle),
        },
      };

      validateCustomParams(customParams, data);

      // log("Updated - ---AIFrameWork----------  >  ${updatedExercise}");
      return GenericWebView(
          apiKey: apiKey,
          companyName: companyName,
          showKinesteX: isShowKinestex,
          userId: userId,
          url: "https://kinestex-camera-ai.vercel.app",
          data: data,
          isLoading: isLoading,
          onMessageReceived: onMessageReceived,
          updatedExercise: updatedExercise
      );
    }
  }

  static void validateCustomParams(
      Map<String, dynamic>? customParams, Map<String, dynamic> data) {
    if (customParams != null) {
      customParams.forEach((key, value) {
        if (containsDisallowedCharacters(key) ||
            (value is String && containsDisallowedCharacters(value))) {
          print(
              '⚠️ Validation Error: Custom parameter key or value contains disallowed characters');
        } else {
          data[key] = value;
        }
      });
    }
  }

  static String? _validateInput({
    required String apiKey,
    required String companyName,
    required String userId,
    required PlanCategory planCategory,
  }) {
    if (containsDisallowedCharacters(apiKey) ||
        containsDisallowedCharacters(companyName) ||
        containsDisallowedCharacters(userId)) {
      return "apiKey, companyName, or userId contains disallowed characters";
    }
    if (planCategory == PlanCategory.Custom &&
        (planCategoryString(planCategory).isEmpty ||
            containsDisallowedCharacters(planCategoryString(planCategory)))) {
      return "planCategory is invalid";
    }
    return null;
  }
}
