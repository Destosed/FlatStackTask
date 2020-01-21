import Foundation
import UIKit
import Alamofire

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
    private let localDM = LocalDataManager.shared
    
    func getData(page: String, complition: @escaping (NetworkResponse?, Error?) -> ()) {
        
        Alamofire.request(page).responseData { response in
            
            if let error = response.error {
                
                DispatchQueue.main.async {
                    complition(nil, error)
                    return
                }
            }
            
            if let data = response.result.value {
                
                guard let networkResponse = try? JSONDecoder().decode(NetworkResponse.self, from: data) else {
                    print("Error: Couldn't built networkResponse model")
                    return
                }
                
                DispatchQueue.main.async {
                    complition(networkResponse, nil)
                }
            }
        }
    }
    
    func getImage(by stringURL: String, complition: @escaping (UIImage?) -> ()) {
        
        if let image = localDM.getCachedImage(key: stringURL) {
            
            DispatchQueue.main.async {
                
                complition(image)
                return
            }
            
        } else {
        
            Alamofire.request(stringURL).responseData { response in
                
                if response.error != nil {
                    
                    complition(nil)
                    return
                }
                
                if let data = response.result.value {
                    
                    if let image = UIImage(data: data) {
                        
                        DispatchQueue.main.async {
                            
                            self.localDM.saveCachedImage(image: image, key: stringURL)
                            complition(image)
                        }
                    }
                }
            }
        }
    }
    
    func getImages(flagImageURL: String, imageURLs: [String], complition: @escaping ([UIImage]) -> Void) {
        
        let group = DispatchGroup()
        var images: [UIImage] = []
        
        for imageURL in imageURLs {
            
            if let image = localDM.getCachedImage(key: imageURL) {
                
                images.append(image)
                
            } else {
            
                group.enter()
                
                Alamofire.request(imageURL).responseData { response in
                    
                    if let data = response.result.value {
                        
                        if let image = UIImage(data: data) {
                            
                            self.localDM.saveCachedImage(image: image, key: imageURL)
                            images.append(image)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            
            //Happens after imageURLs loop
            
            if images.isEmpty {
                
                if let image = self.localDM.getCachedImage(key: flagImageURL) {
                    
                    DispatchQueue.main.async {
                        complition([image])
                        return
                    }
                    
                } else {
                
                    Alamofire.request(flagImageURL).responseData { response in
                        
                        if let data = response.result.value {
                            
                            if let image = UIImage(data: data) {
                                
                                self.localDM.saveCachedImage(image: image, key: flagImageURL)
                                complition([image])
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    complition(images)
                }
            }
        }
    }
}
