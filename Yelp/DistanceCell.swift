//
//  DistanceCell.swift
//  Yelp
//
//  Created by Macintosh on 10/22/16.
//  Copyright © 2016 CoderSchool. All rights reserved.
//

import UIKit

@objc protocol DistanceCellDelegate {
  @objc optional func distanceCell(distanceCell: DistanceCell, didChangeValue value: Bool)
}

class DistanceCell: UITableViewCell {
  
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  
  weak var delegate: DistanceCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    checkButton.isHidden = true
  }
  
  @IBAction func onButton(_ sender: UIButton) {
    print ("Distance button is \(sender.isEnabled)")
    checkButton.setImage(UIImage(named: "check"), for: UIControlState.normal)
    delegate?.distanceCell!(distanceCell: self, didChangeValue: sender.isEnabled)
  }
}
