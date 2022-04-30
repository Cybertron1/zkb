import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = ViewModel(UserDefaults.standard)
  
  // see ContentViewModel for AppState description
  // pass down the viewModel for easy data sharing
  // the loading stage is used to avoid any potential flickering between the views in case the loading of the UserDefaults is slow
  var body: some View {
    switch viewModel.state {
    case .loading:
      EmptyView()
        .background(Color.white)
    case .registerd:
      ConfirmationView(viewModel: viewModel)
    default:
      RegistrationView(viewModel: viewModel)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
