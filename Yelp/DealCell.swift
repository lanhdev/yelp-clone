//
//  DealCell.swift
//  Yelp
//
//  Created by Macintosh on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol DealCellDelegate {
  @objc optional func dealCell (dealCell: DealCell, didChangeValue value: Bool)
}

class DealCell: UITableViewCell {
  
  @IBOutlet weak var dealLabel: UILabel!
  @IBOutlet weak var dealSwitchButton: UISwitch!
  
  weak var delegate: DealCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    dealSwitchButton.onTintColor = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func onSwitchDeal(_ sender: UISwitch) {
    print ("Deal switch state is \(sender.isOn)")
    delegate?.dealCell!(dealCell: self, didChangeValue: sender.isOn)
  }
}
