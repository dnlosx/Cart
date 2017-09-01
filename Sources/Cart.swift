//
//  Cart.swift
//  Cart
//
//  Created by Daniel on 8/7/17.
//

import Foundation


/// Describes the basic needed to the product for add in the cart.
protocol ProductProtocol: Equatable {

    var price: Double { get }
}

/// Describes the product and quantity.
typealias Item<T> = (product: T, quantity: Int)



enum CartItemChangeType {

    /// When a new item is added to the cart.
    case add(at: Int)

    /// When an existing item increments its quantity.
    case increment(at: Int)

    /// When an existing item decrements its quantity.
    case decrement(at: Int)

    /// When an existing item is removed from the cart.
    case delete(at: Int)

    /// When the cart is cleaned (All items was removed).
    case clean

}



protocol CartDelegate {

    /// Its called when an item is added, removed, or change its quantity.
    ///
    /// - parameter type: Describes which type of change was made.
    ///
    func itemsDidChange(type: CartItemChangeType)

}


/// An object that coordinate the products to sell.
class Cart<T: ProductProtocol> {

    /// Counts the number of items without regard to quantity of each one.
    /// Use this to know the number of items in a list, e.g. To get the number of rows in a table view.
    var count: Int {
        get {
            return items.count
        }
    }

    /// Counts the number of products regarding the quantity of each one.
    /// Use this to know the total of products e.g. To display the number of products in cart.
    var countProducts: Int {
        get {
            var numberOfProducts = 0
            for item in items {
                numberOfProducts += item.quantity
            }
            return numberOfProducts
        }
    }

    /// The amount to charge.
    var amount: Double {
        var total: Double = 0
        for item in items {
            total += (item.product.price * Double(item.quantity))
        }
        return total
    }

    /// The delegate to communicate the changes.
    var delegate: CartDelegate?

    /// The list of products to sell.
    private var items = [Item<T>]()


    /// Gets the item at index.
    subscript(index: Int) -> Item<T> {
        return items[index]
    }

    /// Adds a product to the items.
    /// if the product already exists, increments 1 to the quantity, otherwise adds as new one.
    ///
    /// - parameter product: The product to add.
    /// - parameter quantity: How many times will add the products. Default is 1.
    ///
    func add(_ product: T, quantity: Int = 1) {
        for (index, item) in items.enumerated() {
            if product == item.product {
                items[index].quantity += quantity

                delegate?.itemsDidChange(type: .increment(at: index))
                return
            }
        }

        items.append((product: product, quantity: quantity))
        delegate?.itemsDidChange(type: .add(at: (items.count - 1)))
    }

    /// Increments the quantity of an item at index in 1.
    ///
    /// - parameter index: The index of the product to increment.
    ///
    func increment(at index: Int) {
        items[index].quantity += 1
        delegate?.itemsDidChange(type: .increment(at: index))
    }

    /// Increments the quantity of the product item
    ///
    /// - parameter product: The product to increment the quantity.
    ///
    func increment<T: ProductProtocol>(_ product: T) where T: Equatable  {
        for (index, item) in items.enumerated() {
            if product == (item.product as! T) {
                increment(at: index)
                break
            }
        }
    }

    /// Decrements the quantity of an item at index in 1, removes from items if the quantity downs to 0.
    ///
    /// - parameter index: The index of the product to reduce.
    ///
    func decrement(at index: Int) {
        if items[index].quantity > 1 {
            items[index].quantity -= 1
            delegate?.itemsDidChange(type: .decrement(at: index))
        } else {
            remove(at: index)
        }
    }

    /// Decrements the quantity of a product item.
    ///
    /// - parameter product:  The product to reduce the quantity.
    ///
    func decrement<T: ProductProtocol>(_ product: T) where T: Equatable {
        for (index, item) in items.enumerated() {
            if product == (item.product as! T) {
                decrement(at: index)
                break
            }
        }
    }

    /// Removes completely the product at index from the items list, not matter the quantity.
    ///
    /// - parameter index: The index of the product to remove.
    ///
    func remove(at index: Int) {
        items.remove(at: index)
        delegate?.itemsDidChange(type: .delete(at: index))
    }

    /// Removes all products from the items list.
    func clean() {
        items.removeAll()
        delegate?.itemsDidChange(type: .clean)
    }
    
}
