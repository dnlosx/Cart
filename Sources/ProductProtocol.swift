//
//  ProductProtocol.swift
//  Cart
//
//  Created by Daniel on 9/1/17.
//
//

import Foundation


/// Describes the basic needed to the product for add in the cart.
public protocol ProductProtocol: Equatable {

    /// The price will be use to calculate the amount in the cart.
    var price: Double { get }

}
