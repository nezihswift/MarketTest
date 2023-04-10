//
//  BasketViewController.swift
//  MarketTest
//
//  Created by Nezih on 10.04.2023.
//

import Foundation
import UIKit

class BasketViewController : UIViewController, BasketCollectionViewCellDelegate {

    var delegate : BasketViewControllerDelegate?
    
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var totalCostLabel : UILabel!
    
    var basket : [Consumable] = []
    var totalCost : Double = 0.0
    var currency : String = ""
    
    @IBAction func cleanButtonPressed(_ sender: UIButton){
        let alert = UIAlertController(title: "popup.title".localized(), message: "popup.text".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "popup.accept".localized(), style: UIAlertAction.Style.destructive,handler: { action in
            /// Delete all items selected
            self.basket.removeAll()
            self.collectionView.reloadData()
            self.totalCostLabel.text = self.currency + String(format: "%.2f", 0.0).replacingOccurrences(of: ".", with: ",")
        }))
        alert.addAction(UIAlertAction(title: "popup.reject".localized(), style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func changeMainPageTotalValue(by value: Double) {
        totalCost += value
        totalCostLabel.text = currency + String(format: "%.2f", totalCost).replacingOccurrences(of: ".", with: ",")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTotalCostLabelText()
        /// Load data came from previous ViewController
        collectionView.reloadData()
    }
    
    private func setTotalCostLabelText(){
        guard let currency = basket.first?.currency else {
            return
        }
        
        self.currency = currency
        
        for item in basket {
            guard let count = item.count else {
                continue
            }
            totalCost += item.price * Double(count)
        }
        totalCostLabel.text = currency + String(format: "%.2f", totalCost).replacingOccurrences(of: ".", with: ",")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let del = self.delegate {
            del.refreshedDataFromBasket(basket)
        }
    }
}

protocol BasketViewControllerDelegate: AnyObject {
    func refreshedDataFromBasket(_ consumables: [Consumable])
}

extension BasketViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        basket.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let consumable = basket[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.BasketView.collectionViewCellIdentifier, for: indexPath) as? BasketCollectionViewCell,
              let urlString = consumable.imageUrl,
              let imageURL = URL(string: urlString),
              let count = consumable.count else {
            return UICollectionViewCell()
        }
        let totalPrice = consumable.price * Double(count)
        let formattedPriceText = consumable.currency + String(format: "%.2f", totalPrice).replacingOccurrences(of: ".", with: ",")
        /// Populate Items
        cell.delegate = self
        cell.imageView.af.setImage(withURL: imageURL)
        cell.itemNameLabel.text = consumable.name
        cell.itemCount = count
        cell.countLabel.text = String(count)
        cell.priceLabel.text = formattedPriceText
        cell.consumable = consumable
        
        return cell
    }
}
