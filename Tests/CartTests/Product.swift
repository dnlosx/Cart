//
//  Product.swift
//  Cart
//
//  Created by Daniel on 9/1/17.
//
//

import Foundation


class Product: ProductProtocol {

    var id: Int
    var name: String
    var price: Double

    init(id: Int, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }


}


extension Product: Equatable {

    static func == (lhs: Product, rhs: Product) -> Bool {
        return (lhs.id == rhs.id)
    }


}
