//
//  Cart.swift
//  Cart
//
//  Created by Daniel on 8/7/17.
//

import Foundation


/// Describes the product and quantity.
public typealias Item<T> = (product: T, quantity: Int)



/// An object that coordinate the products to sell.
public class Cart<T: ProductProtocol> {

    /// Counts the number of items without regard to quantity of each one.
    /// Use this to know the number of items in a list, e.g. To get the number of rows in a table view.
    public var count: Int {
        get {
            return items.count
        }
    }

    /// Counts the number of products regarding the quantity of each one.
    /// Use this to know the total of products e.g. To display the number of products in cart.
    public var countQuantities: Int {
        get {
            var numberOfProducts = 0
            for item in items {
                numberOfProducts += item.quantity
            }
            return numberOfProducts
        }
    }

    /// The amount to charge.
    public var amount: Double {
        var total: Double = 0
        for item in items {
            total += (item.product.price * Double(item.quantity))
        }
        return total
    }

    /// The delegate to communicate the changes.
    public var delegate: CartDelegate?

    /// The list of products to sell.
    private var items = [Item<T>]()


    /// Gets the item at index.
    public subscript(index: Int) -> Item<T> {
        return items[index]
    }

    /// Adds a product to the items.
    /// if the product already exists, increments 1 to the quantity, otherwise adds as new one.
    ///
    /// - parameter product: The product to add.
    /// - parameter quantity: How many times will add the products. Default is 1.
    ///
    public func add(_ product: T, quantity: Int = 1) {
        for (index, item) in items.enumerated() {
            if product == item.product {
                items[index].quantity += quantity

                delegate?.cart(self, itemsDidChangeWithType: .increment(at: index))
                return
            }
        }

        items.append((product: product, quantity: quantity))

        delegate?.cart(self, itemsDidChangeWithType: .add(at: (items.count - 1)))
    }

    /// Increments the quantity of an item at index in 1.
    ///
    /// - parameter index: The index of the product to increment.
    ///
    public func increment(at index: Int) {
        items[index].quantity += 1
        delegate?.cart(self, itemsDidChangeWithType: .increment(at: index))
    }

    /// Increments the quantity of the product item
    ///
    /// - parameter product: The product to increment the quantity.
    ///
    public func increment<T: ProductProtocol>(_ product: T) where T: Equatable  {
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
    public func decrement(at index: Int) {
        if items[index].quantity > 1 {
            items[index].quantity -= 1
            delegate?.cart(self, itemsDidChangeWithType: .decrement(at: index))
        } else {
            remove(at: index)
        }
    }

    /// Decrements the quantity of a product item.
    ///
    /// - parameter product:  The product to reduce the quantity.
    ///
    public func decrement<T: ProductProtocol>(_ product: T) where T: Equatable {
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
    public func remove(at index: Int) {
        items.remove(at: index)

        delegate?.cart(self, itemsDidChangeWithType: .delete(at: index))
    }

    /// Removes all products from the items list.
    public func clean() {
        items.removeAll()

        delegate?.cart(self, itemsDidChangeWithType: .clean)
    }
    
}
