//
//  ViewController.swift
//  MarketTest
//
//  Created by Nezih on 9.04.2023.
//

import UIKit
import Combine
import AlamofireImage

class HomeViewController: UIViewController, BasketViewControllerDelegate {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// If next page is BasketViewController
        guard let destinationVC = segue.destination as? BasketViewController else {
            return
        }
        /// If CollectionView has items
        guard let collectionViewCellCount = viewModel.consumables?.count,
              collectionViewCellCount != 0 else {
            return
        }
        
        var basket : [Consumable] = []
        /// Check every consumable
        for i in 0...collectionViewCellCount-1 {
            let indexPath = IndexPath(item: i, section: 0)
            guard let cell = collectionView.cellForItem(at: indexPath) as? HomeCollectionViewCell else {
                break
            }
            /// If there is an item on basket
            if cell.itemCount > 0 {
                guard let consumable = cell.consumable else {
                    return
                }
                /// Add item to the basket
                basket.append(consumable)
            }
        }
        /// Send basket to next ViewController
        destinationVC.delegate = self
        destinationVC.basket = basket
    }
    
    private let viewModel = HomeViewModel()
    private var cancellables : Set<AnyCancellable> = []
    
    /// IBOutlets
    @IBOutlet var collectionView : UICollectionView!

    func refreshedDataFromBasket(_ consumables: [Consumable]) {
        /*guard var viewModelItems = viewModel.consumables else {
            return
        }
        for consumable in consumables {
            for (index, viewModelItem) in viewModelItems.enumerated() {
                if consumable.id == viewModelItem.id {
                    viewModelItems[index].count = consumable.count
                    continue
                }
            }
        }
        viewModel.consumables = viewModelItems*/
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initListeners()
        viewModel.getConsumables()
    }
    
    private func initListeners(){
        viewModel.$consumables
            .receive(on: RunLoop.main)
            .sink { consumables in
                self.collectionView.reloadData()
                /// TODO: Set them into tableview
            }
            .store(in: &cancellables)
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { error in
                /// TODO: Error case
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = viewModel.consumables,
              !items.isEmpty else {
                  return 0
              }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.HomeView.collectionViewCellIdentifier, for: indexPath) as? HomeCollectionViewCell,
              let consumable = viewModel.consumables?[indexPath.row],
              let urlString = consumable.imageUrl,
              let imageURL = URL(string: urlString) else {
            return UICollectionViewCell()
        }
        let formattedPriceText = consumable.currency + String(format: "%.2f", consumable.price).replacingOccurrences(of: ".", with: ",")
        
        /// Populate Items
        cell.imageView.af.setImage(withURL: imageURL)
        cell.itemNameLabel.text = consumable.name
        cell.priceLabel.text = formattedPriceText
        cell.consumable = consumable
        
        /// Adding Border Colors Programmaticly (Couldn't find on storyboard I'm not used to do on storyboard)
        cell.setBorderColors()
        
        guard let count = consumable.count else {
            return cell
        }
        if count > 0 {
            cell.countLabel.text = String(count)
            cell.countLabel.isHidden = false
            cell.deleteButton.isHidden = false
        } else {
            cell.countLabel.isHidden = true
            cell.deleteButton.isHidden = true
        }
        
        return cell
    }
}
