//
//  BasketCollectionViewCell.swift
//  MarketTest
//
//  Created by Nezih on 10.04.2023.
//

import Foundation
import UIKit

protocol BasketCollectionViewCellDelegate: AnyObject {
    func changeMainPageTotalValue(by value: Double)
}

class BasketCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var addButton : UIButton!
    @IBOutlet weak var deleteButton : UIButton!
    @IBOutlet weak var countLabel : UILabel!
    @IBOutlet weak var priceLabel : UILabel!
    @IBOutlet weak var itemNameLabel : UILabel!
    
    var itemCount = 0
    var consumable : Consumable?
    
    var delegate : BasketCollectionViewCellDelegate?
    
    private func changeTotalValue(by value: Double) {
        if let del = self.delegate {
            del.changeMainPageTotalValue(by: value)
        }
    }
    
    @IBAction func addButtonClicked(){
        guard let stock = consumable?.stock,
              let currency = consumable?.currency,
              let price = consumable?.price else {
            return
        }
        if itemCount != stock {
            itemCount += 1
            consumable?.count = itemCount
            countLabel.text = String(itemCount)
            priceLabel.text = currency + String(format: "%.2f", Double(itemCount)*price).replacingOccurrences(of: ".", with: ",")
            changeTotalValue(by: price)
        }
    }
    
    @IBAction func deleteButtonClicked(){
        guard let currency = consumable?.currency,
              let price = consumable?.price else {
            return
        }
        if itemCount == 0 {
            return
        }
        itemCount -= 1
        consumable?.count = itemCount
        countLabel.text = String(itemCount)
        priceLabel.text = currency + String(format: "%.2f", Double(itemCount)*price).replacingOccurrences(of: ".", with: ",")
        changeTotalValue(by: -price)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
