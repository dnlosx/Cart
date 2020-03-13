# Cart

iOS, macOS and Linux support.

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

**Cart** doesn't provide any `Type` to use it as product in the cart, you need to implement the `ProductProtocol` to be able of create a Cart instance.

To conform the `ProductProtocol` is needed to implement the `price` property, and the requirements of `Equatable`.

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
```

Equatable is required to implement `ProductProtocol`.
```swift
extension Product: Equatable {

    static func == (lhs: Product, rhs: Product) -> Bool {
        return (lhs.id == rhs.id)
    }
}

```

Now you can create a instance of `Cart`, using your implementation of `ProductProtocol`.
```swift
let items = Cart<Product>()
```

###  When you create a custom class that implements the `ProductProtocol`, you will be ready to create an instance of `Cart`.

Note: The `Product` can be any type that implements `ProductProtocol`.

```swift
let items = Cart<Product>()
let pizza = Product(name: "Pizza", price: 120.00)
items.add(pizza)
```

You can add a product with an initial quantity.
```swift
let soda = Product(id: 2, name: "Coca-cola", price: 20.00)
items.add(soda, quantity: 2)
```

Count the number of different items in the cart.
```swift
items.count // 2
```

Count the number of products regarding the quantity of each one.
```swift
items.countQuantities // 3
```

Get the amount to pay.
```swift
items.amount // 160.00
```

Get an item.
```swift
let pizzaItem = items[0]
pizzaItem.product.price // 120
pizzaItem.quantity // 1
```

 Modify the quantity.
```swift
items.increment(pizza)
items[0].quantity // 2

items.increment(at: 0) // Increments item at index
items[0].quantity // 3

items.decrement(pizza)
items[0].quantity // 2

items.decrement(at: 0)  // Decrements item at index
items[0].quantity // 1
```


### Cart delegate

You can know when a cart item is added, deleted, or its quantity is changed and when the cart is cleaned, by implementing the `CartDelegate` protocol.

Setting the delegate.
```swift
cart.delegate = myViewController
```

Implementing the delegate.
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


### Cloning notes

This project was created with Swift Package Mananger, this mean that the `xcodeproj` file is ignored by default. If you want to use Xcode to build, test or edit this repository, you can generate a Xcode Project with the command `swift package generate-xcodeproj`.

