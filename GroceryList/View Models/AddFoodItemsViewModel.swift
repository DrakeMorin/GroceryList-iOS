//
//  AddGroceryItemsViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit

class AddFoodItemsViewModel {
    let itemInput = Observable<String?>(nil)
}

// MARK: - Public Accessor Functions

extension AddFoodItemsViewModel {
    func parseInputToItems() -> [FoodItem] {
        guard let lines = itemInput.value?.split(separator: "\n")
            else { return [] }

        var items = [FoodItem]()

        for line in lines {
            items.append(parseLineToItem(line: line))
        }

        return items
    }
}

//MARK: Helper Functions

private extension AddFoodItemsViewModel {
    func parseLineToItem(line: Substring) -> FoodItem {
        // Need to determine if quantity was provided or not
        let firstSpace = line.index(of: " ") ?? line.endIndex
        let quantityString = line[..<firstSpace]

        if let quantity = Int(quantityString) {
            let index = line.index(after: firstSpace)
            return  FoodItem(name: String(line.suffix(from: index)), quantity: quantity)
        } else {
            return FoodItem.init(name: String(line), quantity: 1)
        }
    }
}
