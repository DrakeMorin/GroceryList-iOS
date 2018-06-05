//
//  GroceryItemCellViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Bond
import ReactiveKit
import RealmSwift

// TODO: API call to patch server data where necessary

class GroceryItemCellViewModel {
    let itemName = Observable<String?>(nil)
    let quantity = Observable<String?>(nil)
    let checkmarkButtonImage = Observable<UIImage>(R.image.ic_check_empty()!)

    private let groceryItem: GroceryItem

    private let bag = DisposeBag()

    init(groceryItem: GroceryItem) {
        self.groceryItem = groceryItem
        quantity.value = "\(groceryItem.quantity)"
        itemName.value = groceryItem.name
        checkmarkButtonImage.value = groceryItem.isChecked ? R.image.ic_check_filled()! : R.image.ic_check_empty()!

        quantity
            .observeNext {
                    if let quantity = Int($0 ?? "") {
                        self.updateGroceryItem(name: groceryItem.name, quantity: quantity, isChecked: groceryItem.isChecked)
                    } else {
                        self.updateGroceryItem(name: groceryItem.name, quantity: 1, isChecked: groceryItem.isChecked)
                        self.quantity.value = "1"
                    }
            }
            .dispose(in: bag)

        itemName
            .observeNext {
                self.updateGroceryItem(name: $0 ?? "", quantity: groceryItem.quantity, isChecked: groceryItem.isChecked)
            }
            .dispose(in: bag)
    }

    deinit {
        bag.dispose()
    }

    func toggleButton() {
        updateGroceryItem(name: groceryItem.name, quantity: groceryItem.quantity, isChecked: !groceryItem.isChecked)
        checkmarkButtonImage.value = groceryItem.isChecked ? R.image.ic_check_filled()! : R.image.ic_check_empty()!
    }

    func isChecked() -> Bool {
        return groceryItem.isChecked
    }
}

private extension GroceryItemCellViewModel {
    func updateGroceryItem(name: String, quantity: Int, isChecked: Bool, isDirty: Bool = true) {
        do {
            let realm = try Realm()
            try realm.write {
                groceryItem.name = name
                groceryItem.quantity = quantity
                groceryItem.isChecked = isChecked
                groceryItem.isDirty = isDirty
            }
        } catch {
            debugPrint("Error updating GrocceryItem")
        }
    }
}
