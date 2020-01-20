import UIKit
import Alamofire

extension UIImageView {
    
    func setImage(from url: URL) {
        
        self.image = #imageLiteral(resourceName: "imagePlaceholder.jpg")
        
        Alamofire.request(url).responseData { response in
            
            if let data = response.result.value {
                
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    
                    self.image = image
                }
            }
        }
    }
}
