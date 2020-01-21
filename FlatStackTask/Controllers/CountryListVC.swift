import UIKit

class CountryListViewController: UIViewController {
    
    //MARK: - Constants
    
    let firstPage = "https://rawgit.com/NikitaAsabin/799e4502c9fc3e0ea7af439b2dfd88fa/raw/7f5c6c66358501f72fada21e04d75f64474a7888/page1.json"
    let countryCellNibName = "CountryCell"
    let countryCellIdentifier = "CountryCell"
    let loadingCellNibName = "LoadingCell"
    let loadingCellIdentifier = "LoadingCell"
    let detailInfoVC_Identifier = "DetailedInfoVC"
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var countries: [Country] = []
    var nextPage: String?
    var isGettingData = false
    var refresher = UIRefreshControl()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefresher()
        fetchData(page: firstPage)
    }
    
    //MARK: - Data Methods
    
    func fetchData(page: String) {
        
        isGettingData = true
        
        RemoteDataManager.shared.getData(page: page) { networkResponse, error in
            
            if error != nil {
                
                //If couldn't get data from RemoteDM then getting from LocalDM
                AlertService.showErrorAlert(on: self, message: error!.localizedDescription + "\nPresenting cached countries")
                self.countries = LocalDataManager.shared.getAllData()
                self.tableView.reloadData()
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
    
    //MARK:- Infinity Scroll
    
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !isGettingData && nextPage != "" {
                
                isGettingData = true
                tableView.reloadSections(IndexSet(integer: 1), with: .none)
                fetchData(page: nextPage!)
            }
        }
    }
}

//MARK: - Table View Stack

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let countryCellNib = UINib(nibName: countryCellNibName, bundle: nil)
        tableView.register(countryCellNib, forCellReuseIdentifier: countryCellIdentifier)
        
        let loadingCellNib = UINib(nibName: loadingCellNibName, bundle: nil)
        tableView.register(loadingCellNib, forCellReuseIdentifier: loadingCellIdentifier)
        
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
            
            let cell = tableView.dequeueReusableCell(withIdentifier: countryCellIdentifier) as! CountryCell
            cell.setup(for: countries[indexPath.row])
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier) as! LoadingCell
            cell.spinner.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailedInfoVC = storyboard.instantiateViewController(identifier: detailInfoVC_Identifier) as! DetailedInfoViewController
        
        detailedInfoVC.countryInfo = countries[indexPath.row]
        
        navigationController?.pushViewController(detailedInfoVC, animated: true)
    }
}
