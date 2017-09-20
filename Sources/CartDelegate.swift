//    CartDelegate.swift
//
//    Copyright 2017 Fco Daniel BR.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//    documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//    rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
//    and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//    Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//    WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


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
    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType)
    
}
