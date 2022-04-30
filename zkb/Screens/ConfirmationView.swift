import SwiftUI

// simple Confirmation view
// with thank you text and all data of the user
// additionally I added a button to reset the app (UserDefaults + app state)
struct ConfirmationView: View {
  @ObservedObject var viewModel: ContentView.ViewModel
  var body: some View {
    VStack {
      Spacer()
      Text("Thank you for your registration")
        .font(.headline)
      Text(viewModel.user.name)
        .padding(.vertical, 2)
      Text(viewModel.user.email)
        .padding(.vertical, 2)
      Text(viewModel.user.birthday())
        .padding(.top, 2)
      Spacer()
      Button("Unregister") {
        viewModel.reset()
      }
      .padding()
      .frame(maxWidth: 400)
      .background(Color.blue)
      .foregroundColor(Color.white)
      .cornerRadius(10)
      .padding(.horizontal, 20)
    }
  }
}

struct ConfirmationView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ConfirmationView(viewModel: ContentView.ViewModel(UserDefaults.standard))
    }
  }
}
