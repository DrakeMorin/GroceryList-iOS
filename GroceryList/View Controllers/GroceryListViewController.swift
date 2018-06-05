//
//  ViewController.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

class GroceryListViewController: UIViewController {
    @IBOutlet private weak var groceriesTableView: UITableView!
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var emptyStateImage: UIImageView!
    @IBOutlet private weak var emptyStateLabel: UILabel!

    private let viewModel = GroceryListViewModel()
}

// MARK: - View LifeCycle

extension GroceryListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = R.nib.groceryItemTableViewCell()
        groceriesTableView.register(nib, forCellReuseIdentifier: R.nib.groceryItemTableViewCell.identifier)

        groceriesTableView.dataSource = self
        groceriesTableView.delegate = self

        bindViewModel()
    }
}

// MARK: - ViewModel Binding

private extension GroceryListViewController {
    func bindViewModel() {
        viewModel.isEmptyStateHidden.bind(to: emptyStateImage.reactive.isHidden)
        viewModel.isEmptyStateHidden.bind(to: emptyStateLabel.reactive.isHidden)
        viewModel.isEmptyStateHidden
            .map { !$0 }
            .bind(to: groceriesTableView.reactive.isHidden)

        viewModel.shouldReloadUI
            .observeNext {
                self.groceriesTableView.reloadData()
            }
            .dispose(in: reactive.bag)
    }
}

// MARK: - UITableView Data Source

extension GroceryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.uncheckedItems.count : viewModel.checkedItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groceryCell = tableView.dequeueReusableCell(withIdentifier: R.nib.groceryItemTableViewCell.identifier) as! GroceryItemTableViewCell
        groceryCell.selectionStyle = .none
        groceryCell.delegate = self

        if indexPath.section == 0 {
            // Unchecked items
            groceryCell.inject(groceryItem: viewModel.uncheckedItems[indexPath.row], indexPath: indexPath)
        } else {
            // Checked items
            groceryCell.inject(groceryItem: viewModel.checkedItems[indexPath.row], indexPath: indexPath)
        }

        return groceryCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.isListEmpty() {
            return 1
        }
        
        return viewModel.checkedItems.count == 0 ? 1 : 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Still to Buy" : "Done Items"
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // Delete item at indexPath
            self.viewModel.deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

// MARK: - UITableView Delegate

extension GroceryListViewController: UITableViewDelegate { }

// MARK: - AddFoodItems Delegate

extension GroceryListViewController: AddFoodItemsViewControllerDelegate {
    func addFoodItemsViewController(_ controller: AddFoodItemsViewController, didAdd items: [FoodItem]) {
        viewModel.addItems(convertToGroceryItems(items))
    }
}

// MARK: - GroceryItemCell Delegate

extension GroceryListViewController: GroceryItemTableViewCellDelegate {
    func groceryItemTableViewCell(_ cell: GroceryItemTableViewCell, didToggleCellCheckAt indexPath: IndexPath, isChecked: Bool) {
        viewModel.updateCellCheckedState(at: indexPath, isChecked: isChecked)
    }
}

// MARK: - RecipeOverview Delegate

extension GroceryListViewController: RecipeOverviewViewControllerDelegate {
    func recipeOverviewViewController(_ controller: RecipeOverviewViewController, didAddToList recipe: Recipe) {
        viewModel.addItems(convertToGroceryItems(Array(recipe.recipeItems)))
    }
}

// MARK: - Navigation

extension GroceryListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        view.endEditing(true)

        if segue.identifier == R.segue.groceryListViewController.groceryListShowAddFoodItems.identifier {
            guard let navigationController = segue.destination as? UINavigationController,
                let addFoodItemsViewController = navigationController.topViewController as? AddFoodItemsViewController
                else { return }

            addFoodItemsViewController.delegate = self
        } else if segue.identifier == R.segue.groceryListViewController.showRecipeOverview.identifier {
            guard let navigationController = segue.destination as? UINavigationController,
                let recipeOverviewController = navigationController.topViewController as? RecipeOverviewViewController
                else { return }

            recipeOverviewController.delegate = self
        }
    }
}

// MARK: IBActions

private extension GroceryListViewController {
    @IBAction func deleteCheckedItems(_ sender: Any) {
        viewModel.deleteCheckedItems()
    }
}

// MARK: - Helper Functions

private extension GroceryListViewController {
    func convertToGroceryItems(_ foodItems: [FoodItem]) -> [GroceryItem] {
        var groceryItems = [GroceryItem]()

        for item in foodItems {
            groceryItems.append(GroceryItem(name: item.name, quantity: item.quantity))
        }

        return groceryItems
    }
}
