//
//  RecipeDetailViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit
import Bond

class RecipeDetailViewModel {
    let recipeName = Observable<String?>(nil)
    var ingredients = [FoodItem]()
    let isEmptyStateHidden = Observable<Bool>(false)
    let shouldRefreshUI = SafePublishSubject<Void>()
    // TODO: Implement a, isAddIngredientsToRecipe enabled observable!

    private let recipeID: String

    init(recipe: Recipe) {
        recipeID = recipe.id
        recipeName.value = recipe.name
        ingredients = Array(recipe.recipeItems)
    }
}

// MARK: - Public Accessors

extension RecipeDetailViewModel {
    func addIngredients(items: [FoodItem]) {
        ingredients.insert(contentsOf: items, at: ingredients.count)
        shouldRefreshUI.next()
    }

    func deleteIngredient(at indexPath: IndexPath) {
        ingredients.remove(at: indexPath.row)
    }

    func getRecipe() -> Recipe {
        var name = recipeName.value ?? "Unnamed"
        name = name.isEmpty ? "Unnamed" : name
        return Recipe(id: recipeID, name: name, recipeItems: ingredients)
    }

    func isEmpty() -> Bool {
        isEmptyStateHidden.value = !ingredients.isEmpty
        return ingredients.isEmpty
    }
}
