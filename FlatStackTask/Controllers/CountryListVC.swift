import UIKit

class CountryListViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var countries: [Country] = []
    var firstPage = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    var nextPage: String?
    var isGettingData = false
    var refresher = UIRefreshControl()
    
    //MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefresher()
        fetchData(page: firstPage)
    }
    
    //MARK:- Infinity Scroll
    
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !isGettingData && nextPage != "" {
                fetchData(page: nextPage!)
            }
        }
    }
    
    //MARK: - Data Methods
    
    func fetchData(page: String) {
        
        isGettingData = true
        
        RemoteDataManager.shared.getData(page: page) { networkResponse, error in
            
            guard error == nil else {
                AlertService.showErrorAlert(on: self, message: error!.localizedDescription)
                self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                return
            }
            
            if let networkResponse = networkResponse {
                
                let fetchedCountries = networkResponse.countries
                self.countries += fetchedCountries
                self.nextPage = networkResponse.next
                self.isGettingData = false
                self.tableView.reloadData()
                self.refresher.endRefreshing()
            }
        }
    }
    
    //MARK: - Refresher Stack
    
    func setupRefresher() {
        
        refresher.addTarget(self, action: #selector(pulledToRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    @objc func pulledToRefresh() {
        
        countries.removeAll()
        fetchData(page: firstPage)
    }
}

//MARK: - Table View Stack

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let countryCellNib = UINib(nibName: "CountryCell", bundle: nil)
        tableView.register(countryCellNib, forCellReuseIdentifier: "CountryCell")
        
        let loadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingCellNib, forCellReuseIdentifier: "LoadingCell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return countries.count
        } else if section == 1 && isGettingData {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
            cell.setup(for: countries[indexPath.row])
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell") as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedInfoVC = storyboard.instantiateViewController(identifier: "DetailedInfoVC") as! DetailedInfoViewController
        
        detailedInfoVC.countryInfo = countries[indexPath.row]
        
        navigationController?.pushViewController(detailedInfoVC, animated: true)
    }
}
