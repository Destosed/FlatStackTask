import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var coutryNameLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var shortInfoLabel: UILabel!
    
    func setup(for country: Country) {
        
        setupUI()
        
        coutryNameLabel.text = country.name
        capitalLabel.text = country.capital
        shortInfoLabel.text = country.description_small
        
        let imageURL = country.country_info.flag
        RemoteDataManager.shared.getImage(by: imageURL, complition: { image in
            
            if let image = image {
                self.flagImageView.image = image
            }
        })
    }
    
    func setupUI() {
        
        self.selectionStyle = .none
    }
}
