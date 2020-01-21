import Foundation

struct Country: Codable {
    
    let name: String
    let continent: String
    let capital: String
    let population: Int
    let description_small: String
    let description: String
    let image: String
    let country_info: CountryInfo
}

struct CountryInfo: Codable {
    
    let images: [String]
    let flag: String
}
