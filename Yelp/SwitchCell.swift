//
//  SwitchCell.swift
//  Yelp
//
//  Created by Macintosh on 10/18/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
  @objc optional func switchCell (switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
  
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var switchButton: UISwitch!
  
  weak var delegate: SwitchCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    switchButton.onTintColor = UIColor(red: 255.0 / 255.0, green: 45.0 / 255.0, blue: 85.0 / 255.0, alpha: 1.0)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func onSwitch(_ sender: UISwitch) {
    print ("Switch state is \(sender.isOn)")
    
    delegate?.switchCell!(switchCell: self, didChangeValue: sender.isOn)
  }
}
