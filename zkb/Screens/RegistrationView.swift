import SwiftUI

// A simple registration form
// I wrapped it in the NavigationView for the big title
// Additionally I wrapped the entries into the Form for easy styling by Apple
// It automatically applies light/dark mode and manages the dynamic font sizes
// If the entry is wrong a footnote below the TextField is displayed in red

// The DatePicker has a fixed range between 01.01.1900 and 31.12.2022 so there
// is never a validation necessary since the user can not override it

// navigationBarTitle is used because of the iOS 13 deployment version
// navigationViewStyle is used to avoid constraint issues
struct RegistrationView: View {
  @ObservedObject var viewModel: ContentView.ViewModel
  
  var range: ClosedRange<Date> {
    let start = Date("1900-01-01")
    let end = Date("2022-12-31")
    
    return start...end
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Details")) {
          VStack {
            TextField("Name", text: $viewModel.user.name)
              .padding(.vertical, 5)
            if viewModel.errors.name {
              Text("Please fill in your name")
                .font(.footnote)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            }
          }
          VStack {
            TextField("Email", text: $viewModel.user.email)
              .padding(.vertical, 5)
            if viewModel.errors.email {
              Text("Please fill in a valid email")
                .font(.footnote)
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 2)
            }
          }
          
          DatePicker("Birthday", selection: $viewModel.user.date, in: range, displayedComponents: .date)
        }
        
        Section {
          Button("Register") {
            viewModel.register()
          }
        }
      }.navigationBarTitle("Registration")
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct RegistrationView_Previews: PreviewProvider {
  static var previews: some View {
    RegistrationView(viewModel: ContentView.ViewModel(UserDefaults.standard))
  }
}
