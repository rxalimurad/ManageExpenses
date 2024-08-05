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
    let randomNumber = Int.random(in: 1...2)
        
        if randomNumber == 2 {
            print("Random Number is 2 so not showing ads")
            completion()
            return
        }
        
        
        
    guard let interstitialAd = interstitialAd else {
        completion()
        Task {
            await loadAd()
        }
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
