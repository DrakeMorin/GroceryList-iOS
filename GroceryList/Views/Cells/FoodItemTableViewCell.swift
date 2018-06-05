//
//  FoodItemTableViewCell.swift
//  GroceryList
//
//  Created by Drake Morin on 2018-06-04.
//  Copyright © 2018 Drake Morin. All rights reserved.
//

import UIKit

protocol FoodITemTableViewCellDelegate: class {
    func foodItemTableViewCell(_ cell: FoodItemTableViewCell, didUpdate foodItem: FoodItem, at indexPath: IndexPath)
}

class FoodItemTableViewCell: UITableViewCell {
    @IBOutlet private weak var name: UITextField!
    @IBOutlet private weak var quantity: UITextField!

    private var viewModel: FoodItemTableCellViewModel!
    private var indexPath: IndexPath!
    weak var delegate: FoodITemTableViewCellDelegate?

    func inject(name: String, quantity: Int, indexPath: IndexPath) {
        viewModel = FoodItemTableCellViewModel(name: name, quantity: quantity)
        bind()
    }
}

// MARK: - View Binding

private extension FoodItemTableViewCell {
    func bind() {
        viewModel.name.bidirectionalBind(to: name.reactive.text)
        viewModel.quantity.bidirectionalBind(to: quantity.reactive.text)
        name.delegate = self
        quantity.delegate = self
    }
}

// MARK: - TextField Delegate

extension FoodItemTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.foodItemTableViewCell(self, didUpdate: viewModel.getFoodItem(), at: indexPath)
    }
}
