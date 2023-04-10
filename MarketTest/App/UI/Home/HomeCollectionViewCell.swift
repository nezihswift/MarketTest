//
//  HomeCollectionViewCell.swift
//  MarketTest
//
//  Created by Nezih on 9.04.2023.
//

import Foundation
import UIKit

class HomeCollectionViewCell : UICollectionViewCell {
    
    /// IBOutlets
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var countLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var itemNameLabel : UILabel!
    
    var itemCount = 0
    var consumable : Consumable?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setBorderColors(){
        imageView.layer.borderColor = UIColor.secondaryLabel.cgColor
        countLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    @IBAction func addButtonClicked(){
        guard let stock = consumable?.stock else {
            return
        }
        if itemCount != stock {
            if itemCount == 0 {
                countLabel.isHidden = false
                deleteButton.isHidden = false
            }
            itemCount += 1
            consumable?.count = itemCount
            countLabel.text = String(itemCount)
        }
    }
    
    @IBAction func deleteButtonClicked(){
        if itemCount == 0 {
            return
        } else if itemCount == 1 {
            countLabel.isHidden = true
            deleteButton.isHidden = true
        }
        itemCount -= 1
        consumable?.count = itemCount
        countLabel.text = String(itemCount)
    }
}
