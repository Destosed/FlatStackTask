import Foundation
import Alamofire

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    func getData(page: String, complition: @escaping (NetworkResponse?, Error?) -> ()) {
        
        print("DEBUG:")
        print("Going to URL: \(page)")
        
        Alamofire.request(page).responseData { response in
            
            print(response.result)
            print("--------------------")
            
            if let error = response.error {
                complition(nil, error)
                return
            }
            
            if let data = response.result.value {
                
                guard let networkResponse = try? JSONDecoder().decode(NetworkResponse.self, from: data) else {
                    print("Error")
                    return
                }
                DispatchQueue.main.async {
                    complition(networkResponse, nil)
                }
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
