import Foundation
import Alamofire

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    private let firstPageURL = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    
    func getData(complition: @escaping (NetworkResponse?, Error?) -> ()) {
        
        Alamofire.request(firstPageURL).responseData { response in
            
            if let error = response.error {
                complition(nil, error)
                return
            }
            
            if let data = response.result.value {
                
                guard let networkResponse = try? JSONDecoder().decode(NetworkResponse.self, from: data) else {
                    print("Error")
                    return
                }
                complition(networkResponse, nil)
                return
            }
        }
    }
    
    func getImage(by stringURL: String, complition: @escaping (UIImage?) -> ()) {
        
        Alamofire.request(stringURL).responseData { response in
            
            if response.error != nil {
                
                complition(nil)
                return
            }
            
            if let data = response.result.value {
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    complition(image)
                }
            }
        }
    }
}
