//
//  Recipe.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

class Recipe: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let recipeItems = List<FoodItem>()
    @objc dynamic var isDirty = true

    convenience init(json: JSON) {
        self.init()
        
        guard let id: String = "id" <~~ json,
            let name: String = "name" <~~ json,
            let recipeItemsJSON = json["recipeItems"] as? [JSON]
            else { return }

        for item in recipeItemsJSON {
            recipeItems.append(FoodItem.init(json: item))
        }

        self.id = id
        self.name = name
        self.isDirty = false
    }

    convenience init(id: String, name: String, recipeItems: [FoodItem]) {
        self.init()

        self.id = id
        self.name = name
        self.recipeItems.append(objectsIn: recipeItems)
    }

    override class func primaryKey() -> String? {
        return "id"
    }
}
