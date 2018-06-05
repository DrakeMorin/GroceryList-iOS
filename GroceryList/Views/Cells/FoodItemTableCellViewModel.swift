//
//  FoodItemTableViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond

class FoodItemTableCellViewModel {
    let name = Observable<String?>(nil)
    let quantity = Observable<String?>(nil)

    let bag = DisposeBag()

    init(name: String, quantity: Int) {
        self.name.value = name
        self.quantity.value = "\(quantity)"

        self.quantity
            .observeNext {
                if let _ = Int($0 ?? "") {

                } else {
                    self.quantity.value = "1"
                }
            }
            .dispose(in: bag)
    }

    deinit {
        bag.dispose()
    }

    func getFoodItem() -> FoodItem {
        return FoodItem(name: name.value ?? "", quantity: Int(quantity.value ?? "") ?? 0)
    }
}
