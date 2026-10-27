import '../models/onboarding_model.dart';

abstract class OnboardingRepository {
  List<OnboardingModel> getPages();
}
