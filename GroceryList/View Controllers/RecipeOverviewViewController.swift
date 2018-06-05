//
//  RecipeOverviewViewController.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

protocol RecipeOverviewViewControllerDelegate: class {
    func recipeOverviewViewController(_ controller: RecipeOverviewViewController, didAddToList recipe: Recipe)
}

class RecipeOverviewViewController: UIViewController {
    @IBOutlet private weak var recipesTableView: UITableView!
    @IBOutlet private weak var emptyStateImage: UIImageView!
    @IBOutlet private weak var emptyStateLabel: UILabel!

    private let viewModel = RecipeOverviewViewModel()
    weak var delegate: RecipeOverviewViewControllerDelegate?
}

// MARK: - View LifeCycle

extension RecipeOverviewViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = R.nib.recipeTableViewCell()
        recipesTableView.register(nib, forCellReuseIdentifier: R.nib.recipeTableViewCell.identifier)

        recipesTableView.dataSource = self
        recipesTableView.delegate = self

        bindViewModel()
    }
}

// MARK: - ViewModel Binding

private extension RecipeOverviewViewController {
    func bindViewModel() {
        viewModel.isEmptyStateHidden.bind(to: emptyStateImage.reactive.isHidden)
        viewModel.isEmptyStateHidden.bind(to: emptyStateLabel.reactive.isHidden)
        viewModel.isEmptyStateHidden
            .map { !$0 }
            .bind(to: recipesTableView.reactive.isHidden)

        viewModel.shouldReloadUI
            .observeNext {
                self.recipesTableView.reloadData()
            }
            .dispose(in: reactive.bag)
    }
}

// MARK: - UITableView Data Source

extension RecipeOverviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        emptyStateImage.isHidden = !viewModel.isEmpty()
//        recipesTableView.isHidden = viewModel.isEmpty()
        return viewModel.isEmpty() ? 0 : viewModel.recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipesTableView.dequeueReusableCell(withIdentifier: R.nib.recipeTableViewCell.identifier) as! RecipeTableViewCell
        cell.inject(recipeName: viewModel.recipes[indexPath.row].name)

        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // Delete item at indexPath
            self.viewModel.deleteRecipe(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return [delete]
    }
}

// MARK: - UITableView Delegate

extension RecipeOverviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = R.storyboard.recipeDetail().instantiateInitialViewController() as? UINavigationController,
            let recipeDetailViewController = navigationController.topViewController as? RecipeDetailViewController
            else { return }

        recipeDetailViewController.inject(recipe: viewModel.recipes[indexPath.row], indexPath: indexPath)
        recipeDetailViewController.delegate = self

        present(navigationController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - RecipeDetailViewController Delegate

extension RecipeOverviewViewController: RecipeDetailViewControllerDelegate {
    func recipeDetailViewController(_ controller: RecipeDetailViewController, didUpdate recipe: Recipe, at indexPath: IndexPath) {
        viewModel.updateRecipe(recipe, at: indexPath)
    }

    func recipeDetailViewController(_ controller: RecipeDetailViewController, didCreate recipe: Recipe) {
        viewModel.addRecipe(recipe)
    }

    func recipeDetailViewController(_ controller: RecipeDetailViewController, didAddToList recipe: Recipe) {
        delegate?.recipeOverviewViewController(self, didAddToList: recipe)
    }
}

// MARK: - IBActions

private extension RecipeOverviewViewController {
    @IBAction func addRecipe(_ sender: Any) {
        guard let navigationController = R.storyboard.recipeDetail().instantiateInitialViewController() as? UINavigationController,
            let recipeDetailViewController = navigationController.topViewController as? RecipeDetailViewController
            else { return }

        recipeDetailViewController.inject(recipe: Recipe(), indexPath: nil, isNewRecipe: true)
        recipeDetailViewController.delegate = self

        present(navigationController, animated: true)
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}
