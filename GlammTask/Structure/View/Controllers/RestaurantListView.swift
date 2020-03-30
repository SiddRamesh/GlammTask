//
//  RestaurantListView.swift
//  GlammTask
//
//  Created by Ramesh Siddanavar on 30/03/20.
//  Copyright © 2020 Ramesh Siddanavar. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantListView: UITableViewController {
    
    private var arrRestaurants: [RestaurantData] = [RestaurantData]()
    private var viewModel: RestaurantListViewModel = RestaurantListViewModel()
    
    var currentRecord = 1
    var lastLatValue = 19.0760
    var lastLngValue = 72.8777
    var isLoadingData = false
    var currCity = "Mumbai"
    
    var dictLocalCacheImages = [String : UIImage?]()
    let imageCache = NSCache<NSString, UIImage>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "restaurantListVC"
//        self.title = "MyGlamm"//"Find Restaurants"
//        self.navigationItem.prompt = self.currCity
//        self.navigationItem.titleView = setTitle(title: "MyGlamm", subtitle: self.currCity)
        self.navigationItem.titleView = self.navigationItem.setTitle(title:"MyGlamm", subtitle:self.currCity)
        
        viewModel.restaurantListDelegate = self
        
        self.tableView.tableFooterView = UIView.init()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 275 //370
        
        self.tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Fetching new Glamms...")
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        //Load Local Data
        self.loadLocalRestaurantData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchDataFromLocation), name: NSNotification.Name(rawValue: AppConstantValues.constLocationChanged), object: nil)
//        self.navigationItem.titleView = setTitle(title: "MyGlamm", subtitle: self.currCity)
        self.navigationItem.titleView = self.navigationItem.setTitle(title:"MyGlamm", subtitle:self.currCity)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: AppConstantValues.constLocationChanged), object: nil)
        super.viewWillDisappear(animated)
    }
    
    //Load Local Restaurant Data
    func loadLocalRestaurantData() {
        
        self.viewModel.fetchLocalRestaurantData()
    }
    
    //Fetch Data From Location
    @objc func fetchDataFromLocation(_ notification: NSNotification) {
        
        if let locationInfo = notification.userInfo?["user_location"] as? [String : Double] {
            
            self.lastLatValue = locationInfo["lat"] ?? 19.0760
            self.lastLngValue = locationInfo["lng"] ?? 72.8777
            self.fetchRestaurantsData(isFresh: true)
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        
        self.currentRecord = 1
        self.fetchRestaurantsData(isFresh: true)
//        self.navigationItem.titleView = setTitle(title: "MyGlamm", subtitle: self.currCity)
        self.navigationItem.titleView = self.navigationItem.setTitle(title:"MyGlamm", subtitle:self.currCity)
    }
    
    //Fetch Restuarants from APIs
    func fetchRestaurantsData(isFresh: Bool) {
        
        self.isLoadingData = true
        let reqParams = String(format: "lat=%.3f&lon=%.3f&entity_type=city&start=%d&count=20", self.lastLatValue, self.lastLngValue, self.currentRecord)
        self.viewModel.fetchNewRestaurantData(params: reqParams, isFreshDataRequired: isFresh)
    }
    
}

extension RestaurantListView: RestaurantViewModelDelegate {
    
    func didReceiveRestaurantData(restaurants: [RestaurantData], isFreshData: Bool, success: Bool, error: String?) {
        
        self.isLoadingData = false
        
        if success {
            
            if isFreshData {
                self.arrRestaurants = restaurants
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            else {
                var indexPaths = [IndexPath]()
                let currentCount = self.arrRestaurants.count
                
                for i in 0..<restaurants.count {
                    self.arrRestaurants.append(restaurants[i])
                    print("New Count: \(currentCount + i)")
                    indexPaths.append(IndexPath(item: currentCount + i, section: 0))
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                    
                    self.tableView.refreshControl?.endRefreshing()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            
            //Store Restaurants in Cache
            viewModel.storeRestaurantDataInLocalCache(resturants: self.arrRestaurants)
        }
        else {
            print("Error ===> \(error ?? "")")
        }
    }
}

//MARK: Navigation Bar Button Methods
extension RestaurantListView: LocationSelectionDelegate {
    
    @IBAction func clickToFindMyNearBy() {
        
        self.fetchRestaurantsData(isFresh: true)
    }
    
    @IBAction func clickToSearchCity() {
        
        let locationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idLocationListVC") as! LocationListView
        locationVC.locationSelectDelegate = self
        self.present(locationVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    func selectedLocationData(selectedCity: CityData) {
        
        let entityId = "\(selectedCity.city_id)"
        let reqParams = String(format: "entity_id=%@&entity_type=city&count=50", entityId)
        viewModel.fetchNewRestaurantData(params: reqParams, isFreshDataRequired: true)
        print(selectedCity.city_name)
        print(selectedCity.title)
        self.currCity = selectedCity.title //selectedCity.city_name
//        self.navigationItem.titleView = setTitle(title: "MyGlamm", subtitle: self.currCity)
        self.navigationItem.titleView = self.navigationItem.setTitle(title:"MyGlamm", subtitle:self.currCity)
    }
}

//MARK: Table View Methods
extension RestaurantListView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrRestaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objRestaurant = self.arrRestaurants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        cell.configureCell(restaurant: objRestaurant)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Load Image
        if let resCell = cell as? RestaurantCell {
            
            let objRestaurant = self.arrRestaurants[indexPath.row]
            
            guard let featuredImage = objRestaurant.featured_image, featuredImage.count > 0 else {
                resCell.imgImage.image = UIImage(named: "ImgPlacholder")
                return
            }
            
            var resImageURL = featuredImage.components(separatedBy: "?")[0]
            if let params = ("fit=around|200:200&crop=\(resCell.frame.size.width*2):\(resCell.frame.size.height*2)").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), params.count > 0 {
                resImageURL = "\(resImageURL)?\(params)"
            }
            
            resCell.imgImage.sd_setImage(with: URL(string: resImageURL), placeholderImage: UIImage(named: "ImgPlacholder"), options: .continueInBackground) { (image, error, type, url) in
                
                if let img = image {
                    resCell.imgImage.image = img
                }
            }
        }
        
        //Load More Restaurants Data
        let lastElement = self.arrRestaurants.count - 1
        if !isLoadingData, indexPath.row == lastElement {
            
            self.currentRecord = self.arrRestaurants.count + 1
            print("=======> \(self.currentRecord)")
            self.fetchRestaurantsData(isFresh: false)
        }
    }
}
