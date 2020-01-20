import UIKit

class DetailedInfoViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topOffsetConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    var countryInfo: Country!
    var flagImage: UIImage!
    
    var images: [UIImage] = []
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupTableView()
        setupPageControl()
        prepareTableViewForTransition()
        
        fetchImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        enableNavBarTransparency()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        disableNavBarTransparency()
    }
    
    //MARK: - Data fetching
    
    func fetchImages() {
        
        images = [#imageLiteral(resourceName: "imagePlaceholder.jpg")] //Ставим PlaceHolder
        
        let flagImageURL = countryInfo.country_info.flag
        var imagesURL = countryInfo.country_info.images
        if let extraImageURL = countryInfo.image, !extraImageURL.isEmpty {
            imagesURL.append(extraImageURL)
        }
        
        RemoteDataManager.shared.getImages(flagImageURL: flagImageURL, imageURLs: imagesURL) { images in
            
            DispatchQueue.main.async {
                
                self.images.removeAll() //Убираем PlaceHolder
                self.images = images
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Scrollable TableView Covering CollectionView
    
    var panGesture = UIPanGestureRecognizer()
    
    func prepareTableViewForTransition() {
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(sender:)))
        tableView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        guard !tableView.isScrollEnabled else { return }
        guard let senderView = sender.view else { return }
        
        let translation = sender.translation(in: view)
        
        switch sender.state {
        case .began, .changed:
            
            if topOffsetConstraint.constant + translation.y <= 60 {
                tableView.removeGestureRecognizer(panGesture)
                tableView.isScrollEnabled = true
                break
            }
            
            if topOffsetConstraint.constant + translation.y >= 245 {
                break
            }
            
            topOffsetConstraint.constant += translation.y
            sender.setTranslation(CGPoint.zero, in: view)

        case .ended:
            break

        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= 0 {
            
            tableView.isScrollEnabled = false
            tableView.addGestureRecognizer(panGesture)
        }
    }
    
    //MARK: - Setups
    
    func setupPageControl() {
        
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
    }
    
    func enableNavBarTransparency() {
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.barStyle = .black
    }
    
    func disableNavBarTransparency() {
        
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.barStyle = .default
    }
}

//MARK: - CollectionView Stack

extension DetailedInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let cellNib = UINib(nibName: "ImageSliderCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "ImageSliderCell")
        
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCell", for: indexPath) as! ImageSliderCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(collectionView.contentOffset.x) / Int(self.collectionView.frame.width)
    }
    
    //MARK: - Flow Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
}

//MARK: - TableView Stack

extension DetailedInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        
        //Register Cell
        let aboutInfoCellNIB = UINib(nibName: "AboutInfoCell", bundle: nil)
        tableView.register(aboutInfoCellNIB, forCellReuseIdentifier: "AboutInfoCell")
        
        //HeaderView with label
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75)
        
        let label = UILabel()
        label.text = countryInfo.name
        label.font = label.font.withSize(30)
        label.numberOfLines = 0
        
        headerView.addSubview(label)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()

        //Label constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 10).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 25).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 7).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 44
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Capital"
                cell.imageView?.image = #imageLiteral(resourceName: "i-star.png")
                cell.detailTextLabel?.text = countryInfo.capital
            case 1:
                cell.textLabel?.text = "Population"
                cell.imageView?.image = #imageLiteral(resourceName: "i-face.png")
                cell.detailTextLabel?.text = Helper.convertNumber(number: countryInfo.population)
            case 2:
                cell.textLabel?.text = "Continent"
                cell.imageView?.image = #imageLiteral(resourceName: "i-earth.png")
                cell.detailTextLabel?.text = countryInfo.continent
            default:
                return UITableViewCell()
            }
                
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutInfoCell") as! AboutInfoCell

            cell.setup(for: countryInfo.description)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
