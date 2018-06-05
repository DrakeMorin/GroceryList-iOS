//
//  FoodItem.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import RealmSwift
import Gloss

class FoodItem: Object {
    @objc dynamic var name = "ItemName"
    @objc dynamic var quantity = 1

    convenience init(name: String, quantity: Int) {
        self.init()

        self.name = name
        self.quantity = quantity
    }

    convenience init(json: JSON) {
        self.init()
        
        guard let name: String = "name" <~~ json,
            let quantity: Int = "quantity" <~~ json
            else { return }

        self.name = name
        self.quantity = quantity
    }
}
