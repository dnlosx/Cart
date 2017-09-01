import XCTest
@testable import Cart

class CartTests: XCTestCase {

    var items = Cart<Product>()

    var pizza = Product(id: 1, name: "Peperoni pizza", price: 120.00)
    var soda = Product(id: 2, name: "Coca-cola", price: 20.00)

    // Delegate expectations
    var delegateExpectation: XCTestExpectation?

    var expectedType: CartItemChangeType?


    override func setUp() {
        super.setUp()

        items = Cart()
    }

    func testAdd() {

        items = Cart()

        items.add(pizza)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.countQuantities, 1)

        items.add(soda, quantity: 2)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items.countQuantities, 3)
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

    func testDelegateInsert() {
        delegateExpectation = expectation(description: "Waiting for insert delegate")

        items.delegate = self
        expectedType = .add(at: 0)
        items.add(pizza)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testDelegateIncrement() {
        items.add(pizza)
        items.add(soda)

        delegateExpectation = expectation(description: "Waiting for increment delegate")

        items.delegate = self

        let index = 1
        expectedType = .increment(at: index)
        items.increment(at: index)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testDelegateDecrement() {
        items.add(pizza, quantity: 2)
        items.add(soda, quantity: 4)

        delegateExpectation = expectation(description: "Waiting for reduce delegate")

        items.delegate = self

        let index = 0
        expectedType = .decrement(at: index)
        items.decrement(at: index)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testDelegateDelete() {
        items.add(pizza, quantity: 5)

        delegateExpectation = expectation(description: "Waiting for delete delegate")

        items.delegate = self

        let index = 0
        expectedType = .delete(at: index)
        items.remove(at: 0)

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func testDelegateClean() {
        items.add(pizza, quantity: 5)
        items.add(soda, quantity: 20)

        delegateExpectation = expectation(description: "Waiting for delete delegate")

        items.delegate = self
        expectedType = .clean
        items.clean()

        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
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



extension CartTests: CartDelegate {

    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType) where T : ProductProtocol {

        guard let expectedType = expectedType else {
            XCTFail("The expected type must not be nil")
            return
        }

        switch type {
        case .add(at: let index):
            if case .add(at: let expectedIndex) = expectedType {
                XCTAssertEqual(index, expectedIndex)
            } else {
                XCTFail("The types does not match")
            }
            delegateExpectation?.fulfill()

        case .increment(at: let index):
            if case .increment(at: let expectedIndex) = expectedType {
                XCTAssertEqual(index, expectedIndex)
            } else {
                XCTFail("The types does not match")
            }
            delegateExpectation?.fulfill()

        case .decrement(at: let index):
            if case .decrement(at: let expectedIndex) = expectedType {
                XCTAssertEqual(index, expectedIndex)
            } else {
                XCTFail("The types does not match")
            }
            delegateExpectation?.fulfill()

        case .delete(at: let index):
            if case .delete(at: let expectedIndex) = expectedType {
                XCTAssertEqual(index, expectedIndex)
            } else {
                XCTFail("The types does not match")
            }
            delegateExpectation?.fulfill()

        case .clean:
            defer {
                delegateExpectation?.fulfill()
            }
            guard case .clean = expectedType else {
                XCTFail("The types does not match")
                return
            }
        }
    }


}
