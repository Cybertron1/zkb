import Foundation

// read and write JSON to UserDefaults
public extension UserDefaults {
  func set<T: Codable>(object: T, forKey: String) throws {
    let jsonData = try JSONEncoder().encode(object)
    set(jsonData, forKey: forKey)
  }
  
  func get<T>(forKey: String) -> T? where T: Codable {
    guard let result = value(forKey: forKey) as? Data,
          let data = try? JSONDecoder().decode(T.self, from: result) else {
      return nil
    }
    
    return data
  }
}
