//
//  RecipeTableViewCell.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    @IBOutlet private weak var recipeNameLabel: UILabel!

    func inject(recipeName: String) {
        recipeNameLabel.text = recipeName
        // TODO: Determine if I want "Add to Grocery List" button on each cell
    }
}
