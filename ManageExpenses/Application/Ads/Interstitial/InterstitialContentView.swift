import GoogleMobileAds
import SwiftUI

struct InterstitialContentView: View {
  @State private var showGameOverAlert = false
  private let viewModel = InterstitialViewModel()
  let navigationTitle: String

  var body: some View {
    VStack(spacing: 20) {
      Text("The Impossible Game")
        .font(.largeTitle)

      Spacer()


      Button("Play Again") {
        startNewGame()
      }
      .font(.title2)

      Spacer()
    }
    
  

    .navigationTitle(navigationTitle)
  }

  private func startNewGame() {
//    countdownTimer.start()
    Task {
      await viewModel.loadAd()
    }
  }
}
