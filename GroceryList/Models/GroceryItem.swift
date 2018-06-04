//
//  GroceryItem.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

class GroceryItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var quantity = 1
    @objc dynamic var name = "GroceryItem"
    @objc dynamic var isDirty = true
    @objc dynamic var isChecked = false

    // Initializer for JSON received from API
    convenience init(json: JSON) {
        self.init()

        guard let id: String = "id" <~~ json,
            let quantity: Int = "quantity" <~~ json,
            let name: String = "name" <~~ json,
            let isChecked: Bool = "is_checked" <~~ json
            else { return }

        self.id = id
        self.quantity = quantity
        self.name = name
        self.isDirty = false
        self.isChecked = isChecked
    }

    // Initializer for when the User creates an Item
    convenience init(name: String, quantity: Int) {
        self.init()

        self.id = UUID().uuidString
        self.quantity = quantity
        self.name = name
        self.isDirty = true
        self.isChecked = false
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    // TODO: Test if overriding this breaks Realm
    static func ==(lhs: GroceryItem, rhs: GroceryItem) -> Bool {
        return lhs.name.lowercased() == rhs.name.lowercased() && lhs.isChecked == rhs.isChecked
    }
}
