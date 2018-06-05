//
//  GroceryItemTableViewCell.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-03.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

protocol GroceryItemTableViewCellDelegate: class {
    func groceryItemTableViewCell(_ cell: GroceryItemTableViewCell, didToggleCellCheckAt indexPath: IndexPath, isChecked: Bool)
}

class GroceryItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var checkedButton: UIButton!
    @IBOutlet private weak var quantityTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!

    private var indexPath: IndexPath!
    private var viewModel: GroceryItemCellViewModel!
    weak var delegate: GroceryItemTableViewCellDelegate?

    // TODO: Fix TextField height / text size
}

// MARK: - Dependency Injection

extension GroceryItemTableViewCell {
    func inject(groceryItem: GroceryItem, indexPath: IndexPath) {
        viewModel = GroceryItemCellViewModel(groceryItem: groceryItem)
        self.indexPath = indexPath
        bindViewModel()
    }
}

// MARK: - ViewModel Binding

private extension GroceryItemTableViewCell {
    func bindViewModel() {
        viewModel.quantity.bidirectionalBind(to: quantityTextField.reactive.text)
        viewModel.itemName.bidirectionalBind(to: nameTextField.reactive.text)
        viewModel.checkmarkButtonImage.bind(to: checkedButton.reactive.image)
    }
}

// MARK: - IBActions

private extension GroceryItemTableViewCell {
    @IBAction func toggleChecked(_ sender: Any) {
        viewModel.toggleButton()
        delegate?.groceryItemTableViewCell(self, didToggleCellCheckAt: indexPath, isChecked: viewModel.isChecked())
    }
}
