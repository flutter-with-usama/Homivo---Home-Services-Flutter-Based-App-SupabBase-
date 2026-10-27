/// Data class representing a single onboarding page.
class OnboardingModel {
  final String title;
  final String description;
  final int pageIndex; // used to pick the right illustration

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.pageIndex,
  });
}
