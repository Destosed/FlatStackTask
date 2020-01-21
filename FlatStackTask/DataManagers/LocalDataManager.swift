import UIKit

class LocalDataManager {
    
    static let shared = LocalDataManager()
    
    private var cacheImage = [String:UIImage]()
    
    private let userDefaults = UserDefaults.standard
    private let countriesKey = "countries"
    private let cacheImageKey = "cacheImage"
    
    init() {
        
        if let savedCacheImage = userDefaults.dictionary(forKey: cacheImageKey),
            savedCacheImage is [String : UIImage] {
            
            self.cacheImage = savedCacheImage as! [String : UIImage]
            
        }
    }
    
    func getAllData() -> [Country] {
        
        if let countriesData = userDefaults.object(forKey: countriesKey) as? Data {
            
            if let countries = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(countriesData) as? [Country] {
                
                return countries
            }
        }
        return []
    }
    
    func saveAllData(countries: [Country]) {
        
        let countriesData = try? NSKeyedArchiver.archivedData(withRootObject: countries, requiringSecureCoding: false)
        userDefaults.set(countriesData, forKey: countriesKey)
    }
    
    func getCachedImage(key: String) -> UIImage? {
        
        if let image = cacheImage[key] {
            return image
        }
        return nil
    }
    
    func saveCachedImage(image: UIImage, key: String) {
        
        cacheImage[key] = image
    }
}
