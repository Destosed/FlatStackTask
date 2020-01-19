import UIKit

extension UINavigationBar {
    
    func transparentNavigationBar() {
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
    
    func removeTransparentNavigationBar() {
        
        self.setBackgroundImage(nil, for: .default)
        self.shadowImage = nil
        self.isTranslucent = false
    }
}
