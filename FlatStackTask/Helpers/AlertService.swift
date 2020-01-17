import UIKit

class AlertService {
    
    static func showErrorAlert(on vc: UIViewController, message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
