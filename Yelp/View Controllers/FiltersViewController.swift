//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Macintosh on 10/18/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
  @objc optional func filtersViewController(filtersViewController: FiltersViewController, didDealValue deal: Bool, didDistanceValue distance: Int, didSortValue sort: Int, didFiltersValue filters: [String])
}

class FiltersViewController: UIViewController {
  
  let distanceTitle = ["Auto", "1.2 miles", "5 miles", "10 miles", "20 miles"]
  let distanceValue = [40000, 2000, 8500, 16000, 32000]
  var distanceDefault = "Auto"
  
  let sortTitle = ["Best Match", "Distance", "Highest Rated"]
  let sortValue = [0, 1, 2]
  var sortDefault = "Best Match"

  let categories = [["name" : "African", "code": "african"],
                    ["name" : "American, New", "code": "newamerican"],
                    ["name" : "American, Traditional", "code": "tradamerican"],
                    ["name" : "Argentine", "code": "argentine"],
                    ["name" : "Asian Fusion", "code": "asianfusion"],
                    ["name" : "Australian", "code": "australian"],
                    ["name" : "Brazilian", "code": "brazilian"],
                    ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                    ["name" : "British", "code": "british"],
                    ["name" : "Buffets", "code": "buffets"],
                    ["name" : "Bulgarian", "code": "bulgarian"],
                    ["name" : "Burgers", "code": "burgers"],
                    ["name" : "Burmese", "code": "burmese"],
                    ["name" : "Cafes", "code": "cafes"],
                    ["name" : "Cafeteria", "code": "cafeteria"],
                    ["name" : "Cajun/Creole", "code": "cajun"],
                    ["name" : "Cambodian", "code": "cambodian"],
                    ["name" : "Canadian", "code": "New)"],
                    ["name" : "Canteen", "code": "canteen"],
                    ["name" : "Caribbean", "code": "caribbean"],
                    ["name" : "Catalan", "code": "catalan"],
                    ["name" : "Chech", "code": "chech"],
                    ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                    ["name" : "Chicken Shop", "code": "chickenshop"],
                    ["name" : "Chicken Wings", "code": "chicken_wings"],
                    ["name" : "Chilean", "code": "chilean"],
                    ["name" : "Chinese", "code": "chinese"],
                    ["name" : "Italian", "code": "italian"],
                    ["name" : "Japanese", "code": "japanese"],
                    ["name" : "Mexican", "code": "mexican"],
                    ["name" : "Thai", "code": "thai"],
                    ["name" : "Vietnamese", "code": "vietnamese"]]
  
  @IBOutlet weak var tableView: UITableView!
  
  var dealSwitchStates = false
  var distanceSwitchStates = [Int: Bool]()
  var sortSwitchStates = [Int: Bool]()
  var categorySwitchStates = [Int: Bool]()

  
  weak var delegate: FiltersViewControllerDelegate?
  
  struct data {
    static let barColor = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
    static let foregroundColor = UIColor.white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    loadTheme()
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
  }
  
  func loadTheme() {
    navigationController?.navigationBar.barTintColor = data.barColor
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: data.foregroundColor]
    navigationController?.navigationBar.tintColor = data.foregroundColor // Set text color for back button
  }
  
  @IBAction func onBack(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func onSearch(_ sender: UIBarButtonItem) {
    var categoryFilters = [String]()
    var distanceFilters = Int()
    var sortFilters = Int()
    
    let deal = dealSwitchStates

    for (row, isSelected) in distanceSwitchStates {
      if isSelected {
        distanceFilters = distanceValue[row]
      }
    }
    
    for (row, isSelected) in sortSwitchStates {
      if isSelected {
        sortFilters = sortValue[row]
      }
    }

    for (row, isSelected) in categorySwitchStates {
      if isSelected {
        categoryFilters.append(categories[row]["code"]!)
      }
    }
    
    if categoryFilters.count > 0 {
      delegate?.filtersViewController!(filtersViewController: self, didDealValue: deal, didDistanceValue: distanceFilters, didSortValue: sortFilters, didFiltersValue: categoryFilters)
    } else {
      categoryFilters = [""]
      delegate?.filtersViewController!(filtersViewController: self, didDealValue: deal, didDistanceValue: distanceFilters, didSortValue: sortFilters, didFiltersValue: categoryFilters)
    }
    
    dismiss(animated: true, completion: nil)
  }
}

extension FiltersViewController: UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, DealCellDelegate, DistanceCellDelegate, SortCellDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Deal"
    case 1:
      return "Distance"
    case 2:
      return "Sort"
    case 3:
      return "Category"
    default:
      return " "
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return distanceValue.count
    case 2:
      return sortTitle.count
    case 3:
      return categories.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DealCell") as! DealCell
      cell.dealLabel.text = "Offering a Deal"
      cell.dealSwitchButton.isOn = dealSwitchStates
      cell.delegate = self
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceCell") as! DistanceCell
      let distance = distanceTitle[indexPath.row]
      cell.distanceLabel.text = distance
      cell.checkButton.isHidden = distance != distanceDefault
      cell.delegate = self
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortCell
      let sort = sortTitle[indexPath.row]
      cell.sortLabel.text = sort
      cell.sortCheckButton.isHidden = sort != sortDefault
      cell.delegate = self
      return cell
    case 3:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
      cell.categoryLabel.text = categories[indexPath.row]["name"]
      //    if switchStates[indexPath.row] != nil {
      //      cell.switchButton.isOn = switchStates[indexPath.row]!
      //    } else {
      //      cell.switchButton.isOn = false
      //    }
      cell.switchButton.isOn = categorySwitchStates[indexPath.row] ?? false
      cell.delegate = self
      return cell
    default:
      return UITableViewCell()
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      distanceDefault = distanceTitle[indexPath.row]
      tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    if indexPath.section == 2 {
      sortDefault = sortTitle[indexPath.row]
      tableView.reloadSections(IndexSet(integer: 2), with: .none)
    }
  }
  
  func dealCell(dealCell: DealCell, didChangeValue value: Bool) {
    dealSwitchStates = value
    print("filtersVC has got signal from deal switch cell")
  }
  
  func distanceCell(distanceCell: DistanceCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPath(for: distanceCell)
    distanceSwitchStates[(indexPath?.row)!] = value
    print("filtersVC has got signal from distance switch cell")
  }
  
  func sortCell(sortCell: SortCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPath(for: sortCell)
    sortSwitchStates[(indexPath?.row)!] = value
    print("filtersVC has got signal from sort switch cell")
  }
  
  func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
    let indexPath = tableView.indexPath(for: switchCell)
    categorySwitchStates[(indexPath?.row)!] = value
    print("filtersVC has got signal from category switch cell")
  }
}
