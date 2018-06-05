//
//  GroceryListViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import RealmSwift

class GroceryListViewModel {
    let shouldReloadUI = SafePublishSubject<Void>()
    let isEmptyStateHidden = Observable<Bool>(false)

    lazy var uncheckedItems: [GroceryItem] = {
        let realm = try! Realm()

        return Array(realm.objects(GroceryItem.self).filter("isChecked == false"))
    }()

    lazy var checkedItems: [GroceryItem] = {
        let realm = try! Realm()

        return Array(realm.objects(GroceryItem.self).filter("isChecked == true"))
    }()
}

// MARK: - Public Accessor Methods

extension GroceryListViewModel {
    func getGroceryItem(for indexPath: IndexPath) -> GroceryItem {
        if indexPath.section == 0 {
            return uncheckedItems[indexPath.row]
        } else {
            return checkedItems[indexPath.row]
        }
    }

    func deleteCheckedItems() {
        for item in checkedItems {
            deleteItemFromRealm(groceryItem: item)
        }

        checkedItems = []
        shouldReloadUI.next()
        // TODO: Look at doing a Fade animation here, might need another SafePublishSubject
    }

    func deleteItem(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            deleteItemFromRealm(groceryItem: uncheckedItems[indexPath.row])
            uncheckedItems.remove(at: indexPath.row)
        } else {
            deleteItemFromRealm(groceryItem: checkedItems[indexPath.row])
            checkedItems.remove(at: indexPath.row)
        }
    }

    func addItems(_ items: [GroceryItem]) {
        for item in items {
            if let existingItemIndex = uncheckedItems.index(where: { $0 == item }) {
                incrementItemQuantityInRealm(for: uncheckedItems[existingItemIndex], by: item.quantity)
            } else {
                addItemtoRealm(item: item)
                uncheckedItems.append(item)
            }
        }

        shouldReloadUI.next()
    }

    func updateCellCheckedState(at indexPath: IndexPath, isChecked: Bool) {
        let item = getGroceryItem(for: indexPath)
        do {
            let realm = try Realm()

            try realm.write {
                item.isChecked = isChecked
            }
        } catch {
            debugPrint("Error adding to Realm")
        }

        if isChecked {
            uncheckedItems.remove(at: indexPath.row)
            checkedItems.append(item)
        } else {
            checkedItems.remove(at: indexPath.row)
            uncheckedItems.append(item)
        }

        shouldReloadUI.next()
    }

    func isListEmpty() -> Bool {
        isEmptyStateHidden.value = !(uncheckedItems.isEmpty && checkedItems.isEmpty)
        return !isEmptyStateHidden.value
    }
}

// MARK: - Private Helper Functions

private extension GroceryListViewModel {
    func addItemtoRealm(item: GroceryItem) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.create(GroceryItem.self, value: item, update: false)
            }
        } catch {
            debugPrint("Error adding GroceryItem to Realm")
        }
    }

    func incrementItemQuantityInRealm(for groceryItem: GroceryItem, by quantity: Int, isDirty: Bool = true) {
        do {
            let realm = try Realm()

            try realm.write {
                groceryItem.quantity += quantity
                groceryItem.isDirty = isDirty
            }
        } catch {
            debugPrint("Error updating GroceryItem in Realm")
        }
    }

    func deleteItemFromRealm(groceryItem: GroceryItem) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(realm.objects(GroceryItem.self).filter("id == '\(groceryItem.id)'"))
            }
        } catch {
            debugPrint("Error deleting GroceryItem from Realm")
        }
    }
}
