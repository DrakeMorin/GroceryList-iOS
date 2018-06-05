//
//  RecipeOverviewViewModel.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit
import Bond

class RecipeOverviewViewModel {
    let shouldReloadUI = SafePublishSubject<Void>()
    let isEmptyStateHidden = Observable<Bool>(true)

    lazy var recipes: [Recipe] = {
        let realm = try! Realm()

        return Array(realm.objects(Recipe.self))
    }()
}

// MARK: - Public Accessors

extension RecipeOverviewViewModel {
    func deleteRecipe(at indexPath: IndexPath) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.delete(realm.objects(Recipe.self).filter("id == '\(recipes[indexPath.row].id)'"))
            }

            recipes.remove(at: indexPath.row)
        } catch {
            debugPrint("Error deleting Recipe from Realm")
        }
    }

    func addRecipe(_ recipe: Recipe) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.create(Recipe.self, value: recipe, update: false)
            }

            recipes.append(recipe)
            shouldReloadUI.next()
        } catch {
            debugPrint("Error adding Recipe to Realm")
        }
    }

    func updateRecipe(_ recipe: Recipe, at indexPath: IndexPath) {
        do {
            let realm = try Realm()

            try realm.write {
                realm.create(Recipe.self, value: recipe, update: true)
            }

            recipes[indexPath.row] = recipe
            shouldReloadUI.next()
        } catch {
            debugPrint("Error updating Recipe in Realm")
        }
    }

    func isEmpty() -> Bool {
        isEmptyStateHidden.value = !recipes.isEmpty
        return recipes.isEmpty
    }
}
