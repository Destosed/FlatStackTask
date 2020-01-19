import UIKit

class DetailedInfoViewController: UIViewController {
    
    //MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Properties
    
    var countryInfo: Country!
    var images: [UIImage] = [#imageLiteral(resourceName: "test1.jpg"), #imageLiteral(resourceName: "test2.jpg"), #imageLiteral(resourceName: "test3.jpg")]
    
    //MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupTableView()
        setupPageControl()
        setupNavBar()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        self.navigationController?.navigationBar.transparentNavigationBar()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        self.navigationController?.navigationBar.removeTransparentNavigationBar()
//    }
    
    //MARK: - Setups
    
    func setupPageControl() {
        
        pageControl.numberOfPages = images.count
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false
    }
    
    func setupNavBar() {
        
        //Transparent NavBar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.barStyle = .black
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
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControl.currentPage = indexPath.row
//    }
    
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
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        let label = UILabel()
        label.frame = CGRect.init(x: 25, y: 5, width: headerView.frame.width - 10, height: headerView.frame.height)
        label.text = "Argentina"
        label.font = label.font.withSize(30)
        label.textColor = .black
        headerView.addSubview(label)
        
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        let aboutInfoCellNIB = UINib(nibName: "AboutInfoCell", bundle: nil)
        tableView.register(aboutInfoCellNIB, forCellReuseIdentifier: "AboutInfoCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = UITableViewCell()
            cell.textLabel?.text = "\(indexPath.row)"
            cell.selectionStyle = .none
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutInfoCell") as! AboutInfoCell

            let text = "Республика Абхазия - частично признанное независимое государство. Кем не признано - для тех это Автономная Республика Абхазия в составе Грузии, причем оккупированная Россией. С VI века начало формироваться Абхазское Царство, тесно связанное с Византией. С XV века на страну стала давить и влиять мощная Османская Империя, а в XVIII веке в ситуацию вмешалась Российская Империя: для защиты от турков манифестом Александра I в 1810 году Абхазское Княжество было присоединено к Российской Империи. С преобразованием России в СССР статус Абхазии также менялся: то советская республика, то автономия в составе грузинской ССР. С распадом Советского Союза в конце XX века возобновились конфликты: грузины посчитали, что Абхазия принадлежит им, теперь независимым, а абхазы тому воспротивились и грузинов со своей территории повыгоняли"
            cell.setup(for: text)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}
