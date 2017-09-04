# Cart

iOS and macOS support.

This project contains the basic needed to create a Shopping Cart in memory.
It doesn't supports (and is not intended) persistence.


## Features

- [x] Add products with custom class via Generics
- [x] Increment/decrement the quantity of the cart items
- [x] Remove items from cart
- [x] Clean all items from cart
- [x] Delegate to handle cart items changes


## Examples

### Implement ProductProtocol

**Cart** doesn't provides any class to use as product in cart, you must implement the `ProductProtocol` to can create a Cart instance.

For conform the `ProductProtocol` is needed to implement the `price` property, and the requirements of `Equatable`.

```swift

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

// Equatable is required to implement ProductProtocol.
extension Product: Equatable {

    static func == (lhs: Product, rhs: Product) -> Bool {
        return (lhs.id == rhs.id)
    }
}

```

```swift
let items = Cart<Product>()
```

###  When you create a custom class that implements the `ProductProtocol`, you will be ready to create an instance of `Cart`.

```swift

/// Note: The 'Product' can by any class that implements 'ProductProtocol'
let items = Cart<Product>()
let pizza = Product(name: "Pizza", price: 120.00)
items.add(pizza)

// You can add a product with an initial quantity
let soda = Product(id: 2, name: "Coca-cola", price: 20.00)
items.add(soda, quantity: 2)

// Count the number of different items in the cart
print(items.count) // 2

//  Count the number of products regarding the quantity of each one
print(items.countQuantities) // 3

// Get the amount to pay
print(items.amount) // 160.00

// Get an item
let pizzaItem = items[0]
print(pizzaItem.product.price) // 120
print(pizzaItem.quantity) // 1

```


### Cart delegate

You can know when a cart item is added, deleted, if its quantity was changed and when the cart is cleaned, implementing the `CartDelegate`.

```swift
cart.delegate = self
```

```swift
extension MyViewController: CartDelegate {

    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType) where T : ProductProtocol {

        updateAmount()

        switch type {
        case .add(at: let index):
            let indexPath = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)

        case .increment(at: let index), .decrement(at: let index):
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
            cell.quantityLabel.text = String(items[index].quantity)

        case .delete(at: let index):
            let indexPath = IndexPath(row: index, section: 0)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        case .clean:
            if let all = tableView.indexPathsForVisibleRows {
                tableView.deleteRows(at: all, with: .automatic)
            }
        }
    }
}
```

