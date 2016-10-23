//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Chau Vo on 10/17/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var businesses: [Business]!
  var businessesSearch : [Business]!
  var searchActive: Bool = false
  
  let searchBar = UISearchBar()
  
  struct data {
    static let barColor = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    static let foregroundColor = UIColor.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadTheme()
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 100
    
    initializeSearchBar()
    
    Business.search(with: "Thai") { (businesses: [Business]?, error: Error?) in
      if let businesses = businesses {
        self.businesses = businesses
        self.tableView.reloadData()
        for business in businesses {
          print(business.name!)
          print(business.address!)
        }
      }
    }
  }
  
  func loadTheme() {
    navigationController?.navigationBar.barTintColor = data.barColor
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: data.foregroundColor]
    navigationController?.navigationBar.tintColor = data.foregroundColor // Set text color for back button
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let navController = segue.destination as! UINavigationController
    let filtersVC = navController.topViewController as! FiltersViewController
    
    filtersVC.delegate = self
  }
  
}

extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate,  UISearchBarDelegate {
  
  func initializeSearchBar() {
    searchBar.delegate = self
    searchBar.showsCancelButton = false
    searchBar.placeholder = "Restaurants"
    navigationItem.titleView = searchBar
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
    searchBar.endEditing(true)
    searchBar.text = ""
    self.tableView.reloadData()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = true
    searchBar.endEditing(true)
    self.tableView.reloadData()
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    searchActive = false
    searchBar.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == "" {
      searchActive = false
    } else {
      searchActive = true
    }
    
    Business.search(with: searchText) { (businesses: [Business]?, error: Error?) in
      if let businesses = businesses {
        self.businessesSearch = businesses
        self.tableView.reloadData()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchActive {
      if businessesSearch != nil {
        return businessesSearch.count
      } else {
        return 0
      }
    } else {
      if businesses != nil {
        return businesses.count
      } else {
        return 0
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessCell
    if searchActive {
      cell.business = businessesSearch[indexPath.row]
    } else {
      cell.business = businesses[indexPath.row]
    }
    return cell
  }
  
  func filtersViewController(filtersViewController: FiltersViewController, didDealValue deal: Bool, didDistanceValue distance: Int, didSortValue sort: Int, didFiltersValue filters: [String]) {
    print("I get new filters from filtersVC")
    
    Business.search(with: "", sort: YelpSortMode(rawValue: sort), categories: filters, deals: deal, distance: distance) { (businesses: [Business]?, error: Error?) in
      if let businesses = businesses {
        self.businesses = businesses
        print ("I got businesses")
        print ("Deal is \(deal)")
        print ("Distance is \(distance)")
        self.tableView.reloadData()
        print ("I have reloaded")
      }
    }
  }
}


