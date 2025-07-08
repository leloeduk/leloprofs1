// ad_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Événements
abstract class AdEvent {}

class InitializeAdMob extends AdEvent {}

class LoadBannerAd extends AdEvent {}

class LoadInterstitialAd extends AdEvent {}

// États
abstract class AdState {}

class AdInitial extends AdState {}

class AdLoading extends AdState {}

class AdLoaded extends AdState {
  final BannerAd? bannerAd;
  final InterstitialAd? interstitialAd;
  AdLoaded({this.bannerAd, this.interstitialAd});
}

class AdError extends AdState {
  final String message;
  AdError(this.message);
}

// BLoC
class AdBloc extends Bloc<AdEvent, AdState> {
  AdBloc() : super(AdInitial()) {
    on<InitializeAdMob>(_initializeAdMob);
    on<LoadBannerAd>(_loadBannerAd);
    on<LoadInterstitialAd>(_loadInterstitialAd);
  }

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  // Initialisation AdMob
  Future<void> _initializeAdMob(
    InitializeAdMob event,
    Emitter<AdState> emit,
  ) async {
    emit(AdLoading());
    try {
      await MobileAds.instance.initialize();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ['a63e97ea-004f-44c7-9ec4-6537181c08c0'],
        ),
      );
      emit(AdInitial());
    } catch (e) {
      emit(AdError('AdMob init failed: $e'));
    }
  }

  // Chargement bannière
  Future<void> _loadBannerAd(LoadBannerAd event, Emitter<AdState> emit) async {
    emit(AdLoading());
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Test ID
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => emit(AdLoaded(bannerAd: _bannerAd)),
        onAdFailedToLoad:
            (ad, error) => emit(AdError('Banner failed: ${error.message}')),
      ),
    );
    await _bannerAd?.load();
  }

  // Chargement interstitielle
  Future<void> _loadInterstitialAd(
    LoadInterstitialAd event,
    Emitter<AdState> emit,
  ) async {
    emit(AdLoading());
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ID
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          emit(AdLoaded(interstitialAd: ad));
        },
        onAdFailedToLoad:
            (error) => emit(AdError('Interstitial failed: ${error.message}')),
      ),
    );
  }

  @override
  Future<void> close() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    return super.close();
  }
}
