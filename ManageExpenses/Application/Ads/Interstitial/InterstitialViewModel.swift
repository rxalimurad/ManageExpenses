import GoogleMobileAds

class InterstitialViewModel: NSObject, GADFullScreenContentDelegate {
  private var interstitialAd: GADInterstitialAd?
    private var onfinish: (() -> Void)?

  func loadAd() async {
    do {
      interstitialAd = try await GADInterstitialAd.load(
        withAdUnitID: Constants.ads.interstitial, request: GADRequest())
      interstitialAd?.fullScreenContentDelegate = self
    } catch {
      print("Failed to load interstitial ad with error: \(error.localizedDescription)")
    }
  }

    func showAd(completion: @escaping (() -> Void)) {
    self.onfinish = completion
    guard let interstitialAd = interstitialAd else {
        completion()
      return print("Ad wasn't ready.")
        
        
    }
     interstitialAd.present(fromRootViewController: nil)
  }

  // MARK: - GADFullScreenContentDelegate methods

  func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    interstitialAd = nil
      self.onfinish?()
  }
}
