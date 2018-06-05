//
//  RecipeDetailViewController.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

protocol RecipeDetailViewControllerDelegate: class {
    func recipeDetailViewController(_ controller: RecipeDetailViewController, didUpdate recipe: Recipe, at indexPath: IndexPath)
    func recipeDetailViewController(_ controller: RecipeDetailViewController, didCreate recipe: Recipe)
    func recipeDetailViewController(_ controller: RecipeDetailViewController, didAddToList recipe: Recipe)
}

class RecipeDetailViewController: UIViewController {
    @IBOutlet private weak var recipeNameTextField: UITextField!
    @IBOutlet private weak var foodItemTableView: UITableView!
    @IBOutlet private weak var emptyStateImage: UIImageView!
    @IBOutlet private weak var emptyStateLabel: UILabel!

    private var indexPath: IndexPath!
    private var isNewRecipe = false
    private var viewModel: RecipeDetailViewModel!
    weak var delegate: RecipeDetailViewControllerDelegate?
}

// MARK: - Dependency Injection

extension RecipeDetailViewController {
    func inject(recipe: Recipe, indexPath: IndexPath?, isNewRecipe: Bool = false) {
        viewModel = RecipeDetailViewModel(recipe: recipe)
        self.indexPath = indexPath
        self.isNewRecipe = isNewRecipe
    }
}

// MARK: - View LifeCycle

extension RecipeDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = R.nib.foodItemTableViewCell()
        foodItemTableView.register(nib, forCellReuseIdentifier: R.nib.foodItemTableViewCell.identifier)

        foodItemTableView.dataSource = self
        foodItemTableView.delegate = self

        bindViewModel()
    }
}

// MARK: - ViewModel Binding

private extension RecipeDetailViewController {
    func bindViewModel() {
        viewModel.recipeName.bidirectionalBind(to: recipeNameTextField.reactive.text)
        viewModel.isEmptyStateHidden.bind(to: emptyStateImage.reactive.isHidden)
        viewModel.isEmptyStateHidden.bind(to: emptyStateLabel.reactive.isHidden)

        viewModel.isEmptyStateHidden
            .map { !$0 }
            .bind(to: foodItemTableView.reactive.isHidden)

        viewModel.shouldRefreshUI
            .observeNext {
                self.foodItemTableView.reloadData()
            }
            .dispose(in: reactive.bag)
    }
}

// MARK: - UITableView DataSource

extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isEmpty() {
            return 0
        }
        
        return viewModel.ingredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.foodItemTableViewCell.identifier) as! FoodItemTableViewCell
        let ingredient = viewModel.ingredients[indexPath.row]
        cell.inject(name: ingredient.name, quantity: ingredient.quantity, indexPath: indexPath)
        cell.delegate = self

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // Delete item at indexPath
            self.viewModel.deleteIngredient(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

// MARK: - UITableView Delegate

extension RecipeDetailViewController: UITableViewDelegate { }

// MARK: - FoodItemTableViewCell Delegate

extension RecipeDetailViewController: FoodITemTableViewCellDelegate {
    func foodItemTableViewCell(_ cell: FoodItemTableViewCell, didUpdate foodItem: FoodItem, at indexPath: IndexPath) {
        viewModel.ingredients[indexPath.row] = foodItem
        foodItemTableView.reloadData()
    }
}

// MARK: - AddFoodItems Delegate

extension RecipeDetailViewController: AddFoodItemsViewControllerDelegate {
    func addFoodItemsViewController(_ controller: AddFoodItemsViewController, didAdd items: [FoodItem]) {
        viewModel.addIngredients(items: items)
    }
}

// MARK: - IBActions

private extension RecipeDetailViewController {
    @IBAction func addFoodItems(_ sender: Any) {
        guard let navigationController = R.storyboard.addFoodItems().instantiateInitialViewController() as? UINavigationController,
            let addFoodItemsViewController = navigationController.topViewController as? AddFoodItemsViewController
            else { return }

        addFoodItemsViewController.delegate = self

        present(navigationController, animated: true)
    }

    @IBAction func close(_ sender: Any) {
        view.endEditing(true)
        
        if viewModel.recipeName.value == nil && viewModel.ingredients.isEmpty {
            dismiss(animated: true)
        } else {
            if !isNewRecipe {
                delegate?.recipeDetailViewController(self, didUpdate: viewModel.getRecipe(), at: indexPath)
            } else {
                delegate?.recipeDetailViewController(self, didCreate: viewModel.getRecipe())
            }

            dismiss(animated: true)
        }
    }

    @IBAction func addIngredientsToList(_ sender: Any) {
        if !viewModel.ingredients.isEmpty {
            delegate?.recipeDetailViewController(self, didAddToList: viewModel.getRecipe())
            close(self)
        }
    }
}
