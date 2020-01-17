import Foundation

struct NetworkResponse: Codable {
    
    let next: String?
    let countries: [Country]
}
