import Foundation
import UIKit
import Alamofire

let cacheImage = NSCache<NSString, UIImage>()

class RemoteDataManager {
    
    static let shared = RemoteDataManager()
    
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
        
        if let image = cacheImage.object(forKey: stringURL as NSString) {
            
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
                            
                            cacheImage.setObject(image, forKey: stringURL as NSString)
                            complition(image)
                        }
                    }
                }
            }
        }
    }
    
    func getImages(flagImageURL: String, imageURLs: [String], complition: @escaping ([UIImage]) -> Void) {
        
        //Принимаем URL флага и [URL] всех картинок
        
        var images: [UIImage] = []
        
        let group = DispatchGroup()
        
        
        for imageURL in imageURLs {
            
            if let image = cacheImage.object(forKey: imageURL as NSString) {
                
                images.append(image)
                
            } else {
            
                group.enter()
                
                Alamofire.request(imageURL).responseData { response in
                    
                    if let data = response.result.value {
                        
                        if let image = UIImage(data: data) {
                            
                            cacheImage.setObject(image, forKey: imageURL as NSString)
                            images.append(image)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            
            if images.isEmpty {
                
                if let image = cacheImage.object(forKey: flagImageURL as NSString) {
                    
                    DispatchQueue.main.async {
                        complition([image])
                        return
                    }
                    
                } else {
                
                    Alamofire.request(flagImageURL).responseData { response in
                        
                        if let data = response.result.value {
                            
                            if let image = UIImage(data: data) {
                                
                                cacheImage.setObject(image, forKey: flagImageURL as NSString)
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
