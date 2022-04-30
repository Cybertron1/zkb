import Foundation

extension ContentView {
  // AppState defines the current state of the app
  // loading: the state while the app starts and fetches the data from UserDefaults -> simply to avoid any potential flickering if the user is registered
  // notRegistered: the state when nothing could be found in the UserDefaults
  // registered: the state when data could be found in the UserDefaults
  enum AppState {
    case loading
    case notRegisterd
    case registerd
  }
  
  class ViewModel: ObservableObject {
    @Published var state: AppState = .loading
    @Published var user: User
    // this is used so the view knows which entry contains errors
    @Published var errors: (name: Bool, email: Bool) = (false, false)
    
    let userDefaults: UserDefaults
    
    // pass UserDefaults instance for easy testing
    // try to fetch the user from UserDefaults if found set the state + user
    // if not set empty user
    init(_ userDefaults: UserDefaults) {
      self.userDefaults = userDefaults
      if let user: User = userDefaults.get(forKey: "user") {
        self.user = user
        state = .registerd
      } else {
        user = User(name: "", email: "", date: Date())
        state = .notRegisterd
      }
    }
    
    // write to UserDefaults if entries are valid
    // write JSON into UserDefaults
    // once registered switch UI to confirmation screen
    func register() {
      guard validate() else {
        return
      }
      do {
        try userDefaults.set(object: user, forKey: "user")
        state = .registerd
      } catch {
        print(error)
        // show error to the user to try again later
      }
    }
    
    // reset UserDefaults
    // create new User and discard the old one
    // set state to notRegistered for UI switch
    func reset() {
      userDefaults.removeObject(forKey: "user")
      user = User(name: "", email: "", date: Date())
      state = .notRegisterd
    }
    
    // validate checks name + email
    // date does not need to be checked since a range was applied
    private func validate() -> Bool {
      let name = user.name.count > 0
      let emailPattern = #"^\S+@\S+\.\S{2,}$"#
      let email = user.email.range(of: emailPattern, options: .regularExpression) != nil
      errors = (!name, !email)
      return name && email
    }
  }
  
  struct User: Codable {
    var name: String
    var email: String
    var date: Date
  
    // format date to readable string
    func birthday() -> String {
      let formatter = DateFormatter()
      formatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
      return formatter.string(from: date)
    }
  }
}
