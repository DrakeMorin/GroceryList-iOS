//
//  AddGroceryItemsViewController.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

protocol AddFoodItemsViewControllerDelegate: class {
    func addFoodItemsViewController(_ controller: AddFoodItemsViewController, didAdd items: [FoodItem])
}

class AddFoodItemsViewController: UIViewController {
    @IBOutlet private weak var itemTextView: UITextView!

    let viewModel = AddFoodItemsViewModel()
    weak var delegate: AddFoodItemsViewControllerDelegate?
}

// MARK: - View LifeCycle

extension AddFoodItemsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }
}

// MARK: - ViewModel Binding

extension AddFoodItemsViewController {
    func bindViewModel() {
        itemTextView.reactive.text.bind(to: viewModel.itemInput)
    }
}

// MARK: - IBActions

private extension AddFoodItemsViewController {
    @IBAction func saveItems(_ sender: Any) {
        let items = viewModel.parseInputToItems()
        delegate?.addFoodItemsViewController(self, didAdd: items)
        self.dismiss(animated: true)
    }
}
