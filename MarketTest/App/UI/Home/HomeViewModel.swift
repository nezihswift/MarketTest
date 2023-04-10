//
//  HomeViewModel.swift
//  MarketTest
//
//  Created by Nezih on 9.04.2023.
//

import Foundation

class HomeViewModel {
    @Published var consumables : [Consumable]? = nil
    @Published private (set) var error : Error? = nil
    
    
    func getConsumables(){
        ConsumableAPI.getConsumables { result in
            switch result {
            case .success(let consumables):
                /// Checking if consumables is empty or not, if it is not publish the array to ViewController
                guard !consumables.isEmpty else {
                    return
                }
                self.consumables = consumables
            case .failure(let error):
                self.error = error
            }
        }
    }
    
}
