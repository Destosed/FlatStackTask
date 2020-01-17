import UIKit

class CountryListViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var countries: [Country] = []
    
    //MARK: - Life Circle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()
    }
    
    //MARK: - Data Methods
    
    func fetchData() {
        
        RemoteDataManager.shared.getData { networkResponse, error in
            
            guard error == nil else { fatalError() }
            
            if let networkResponse = networkResponse {
                
                let fetchedCountries = networkResponse.countries
                DispatchQueue.main.async {
                    
                    self.countries = fetchedCountries
                    self.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - Table View Stack

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibCell = UINib(nibName: "CountryCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "cell")
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountryCell
        cell.setup(for: countries[indexPath.row])
        
        return cell
    }
}
