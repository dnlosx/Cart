import XCTest
@testable import Cart

class CartTests: XCTestCase {

    var items = Cart<Product>()

    var pizza = Product(id: 1, name: "Peperoni pizza", price: 120.00)
    var soda = Product(id: 2, name: "Coca-cola", price: 20.00)

    override func setUp() {

        items = Cart()
    }

    func testAdd() {

        items = Cart()

        items.add(pizza)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.countProducts, 1)

        items.add(soda, quantity: 2)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items.countProducts, 3)
    }

    func testIncrement() {
        items.add(pizza)
        items.add(soda)

        XCTAssertEqual(items[0].quantity, 1)

        items.increment(pizza)
        XCTAssertEqual(items[0].quantity, 2)
    }

    func testDecrement() {
        items.add(pizza, quantity: 2)
        items.add(soda, quantity: 2)

        items.decrement(pizza)
        XCTAssertEqual(items[0].quantity, 1)

        items.decrement(pizza)
        XCTAssertEqual(items.count, 1,  "When the quantity of a product is reduce to 0, must be remove.")

        XCTAssertNotEqual(items[0].product, pizza, "The pizza must not been in the cart.")
    }

    func testRemove() {
        items.add(pizza, quantity: 5)

        items.remove(at: 0)
        XCTAssertEqual(items.count, 0)
    }

    func testClean() {
        items.add(pizza, quantity: 2)
        items.add(soda, quantity: 5)

        items.clean()
        XCTAssertEqual(items.count, 0)
    }

    func testAmount() {
        items.add(pizza, quantity: 1)
        items.add(soda, quantity: 4)

        XCTAssertEqual(items.amount, 200)
    }


    static var allTests = [
        ("testAdd", testAdd),
        ("testIncrement", testIncrement),
        ("testDecrement", testDecrement),
        ("testRemove", testRemove),
        ("testClean", testClean),
        ("testAmount", testAmount)
    ]

}
