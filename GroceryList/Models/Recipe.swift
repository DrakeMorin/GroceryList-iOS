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
    let recipeItems = List<FoodItem>()
    @objc dynamic var isDirty = true

    // TODO JSON Decoding
}
