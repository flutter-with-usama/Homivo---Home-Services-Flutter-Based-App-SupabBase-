import '../models/onboarding_model.dart';
import 'onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  @override
  List<OnboardingModel> getPages() => const [
        OnboardingModel(
          pageIndex: 0,
          title: 'Book Trusted\nHome Services',
          description:
              'From plumbing to painting, find verified\nprofessionals for every corner of your home.',
        ),
        OnboardingModel(
          pageIndex: 1,
          title: 'Track Your Job\nin Real Time',
          description:
              'Watch your pro arrive on a live map, get\nupdates, and never be left in the dark.',
        ),
        OnboardingModel(
          pageIndex: 2,
          title: 'Your Home,\nPerfectly Cared For',
          description:
              'Schedule recurring services, manage bookings,\nand keep your home in top shape — effortlessly.',
        ),
      ];
}
