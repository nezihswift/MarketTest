//
//  ConsumableAPI.swift
//  MarketTest
//
//  Created by Nezih on 9.04.2023.
//

import Foundation
import Alamofire

typealias ConsumableAPIResponse = ((Swift.Result<[Consumable], Error>) -> Void)

final class ConsumableAPI {
    static func getConsumables(completion: @escaping ConsumableAPIResponse) {
        AF.request(Constants.URL.getURL)
            .validate()
            .responseDecodable(of: [Consumable].self) { response in
                switch response.result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let movies):
                    completion(.success(movies))
                }
            }
    }
}
