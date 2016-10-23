//
//  SortCell.swift
//  Yelp
//
//  Created by Macintosh on 10/23/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SortCellDelegate {
  @objc optional func sortCell(sortCell: SortCell, didChangeValue value: Bool)
}

class SortCell: UITableViewCell {
  
  @IBOutlet weak var sortLabel: UILabel!
  @IBOutlet weak var sortCheckButton: UIButton!
  
  weak var delegate: SortCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    sortCheckButton.isHidden = true
  }

  @IBAction func onSortButton(_ sender: UIButton) {
    print ("Sort button is \(sender.isEnabled)")
    sortCheckButton.setImage(UIImage(named: "check"), for: UIControlState.normal)
    delegate?.sortCell!(sortCell: self, didChangeValue: sender.isEnabled)
  }
}
