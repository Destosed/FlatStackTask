import UIKit

class AboutInfoCell: UITableViewCell {
    
    @IBOutlet weak var aboutLabel: UILabel!
    
    func setup(for text: String) {
        
        aboutLabel.text = text
    }
}
