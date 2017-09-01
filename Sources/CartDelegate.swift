//
//  Delegate.swift
//  Cart
//
//  Created by Daniel on 9/1/17.
//
//

import Foundation


public enum CartItemChangeType {

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


public protocol CartDelegate {

    /// Its called when an item is added, removed, or change its quantity.
    ///
    /// - parameter type: Describes which type of change was made.
    ///
    func cart<T: ProductProtocol>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType)
    
}
