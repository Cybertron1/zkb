import XCTest
@testable import zkb

class ZkbTests: XCTestCase {
  private var userDefaults: UserDefaults!
  private var viewModel: ContentView.ViewModel!
  
  override func setUp() {
    userDefaults = UserDefaults(suiteName: #file)
    userDefaults.removePersistentDomain(forName: #file)
    
    viewModel = ContentView.ViewModel(userDefaults)
  }
  
  func testEmailValidation() {
    viewModel.user.email = ""
    viewModel.register()
    XCTAssertTrue(viewModel.errors.email)
    
    viewModel.user.email = "test@test.c"
    viewModel.register()
    XCTAssertTrue(viewModel.errors.email)
    
    viewModel.user.email = "@test.c"
    viewModel.register()
    XCTAssertTrue(viewModel.errors.email)
    
    viewModel.user.email = "@test.ch"
    viewModel.register()
    XCTAssertTrue(viewModel.errors.email)
    
    viewModel.user.email = "test.ch"
    viewModel.register()
    XCTAssertTrue(viewModel.errors.email)
    
    viewModel.user.email = "test@test.ch"
    viewModel.register()
    XCTAssertFalse(viewModel.errors.email)
  }
  
  func testNameValidation() {
    viewModel.user.name = ""
    viewModel.register()
    XCTAssertTrue(viewModel.errors.name)
    
    viewModel.user.name = "M"
    viewModel.register()
    XCTAssertFalse(viewModel.errors.name)
    
    viewModel.user.name = "Mika"
    viewModel.register()
    XCTAssertFalse(viewModel.errors.name)
  }
  
  func testAppState() {
    XCTAssertEqual(viewModel.state, .notRegisterd)
    
    viewModel.user.email = "test@test.ch"
    viewModel.user.name = "Mika"
    // no need to set date since default date is today
    
    viewModel.register()
    
    XCTAssertEqual(viewModel.state, .registerd)
  }
  
  func testRegisteredAppState() {
    // fill the UserDefaults
    viewModel.user.email = "test@test.ch"
    viewModel.user.name = "Mika"
    // no need to set date since default date is today
    
    viewModel.register()
    
    let vm = ContentView.ViewModel(userDefaults)
    XCTAssertEqual(vm.state, .registerd)
  }
  
  func testReset() {
    viewModel.user.email = "test@test.ch"
    viewModel.user.name = "Mika"
    // no need to set date since default date is today
    
    viewModel.register()
    XCTAssertNotNil(userDefaults.value(forKey: "user"))
    
    viewModel.reset()
    XCTAssertNil(userDefaults.value(forKey: "user"))
  }
  
  func testBirthdayFormatter() {
    viewModel.user.date = Date("1998-01-01")
    
    XCTAssertEqual(viewModel.user.birthday(), "01.01.1998")
  }
}
