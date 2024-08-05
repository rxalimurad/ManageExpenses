import GoogleMobileAds

class AppOpenAdManager: NSObject, GADFullScreenContentDelegate {
    private var appOpenAd: GADAppOpenAd?
    private var loadTime: Date?
    
    static let shared = AppOpenAdManager()
    
    private override init() {
        super.init()
        loadAd()
    }
    
    func loadAd() {
        GADAppOpenAd.load(withAdUnitID: Constants.ads.appOpen, request: GADRequest()) { ad, error in
            if let error = error {
                print("Failed to load App Open Ad: \(error.localizedDescription)")
                return
            }
            self.appOpenAd = ad
            self.loadTime = Date()
            self.appOpenAd?.fullScreenContentDelegate = self
            print("App Open Ad loaded.")
        }
       
    }
    
    func isAdAvailable() -> Bool {
        if let ad = appOpenAd, let loadTime = loadTime {
            let timeInterval = Date().timeIntervalSince(loadTime)
            return timeInterval < 4 * 3600 
        }
        return false
    }
    
    func showAdIfAvailable() {
        if isAdAvailable() {
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                print("No root view controller to present ad.")
                return
            }
            appOpenAd?.present(fromRootViewController: rootViewController)
        } else {
            print("Ad not ready.")
            loadAd()
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad dismissed.")
        loadAd()
    }
    
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad impression recorded.")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("App Open Ad clicked.")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("App Open Ad failed to present: \(error.localizedDescription)")
        loadAd()
    }
}
