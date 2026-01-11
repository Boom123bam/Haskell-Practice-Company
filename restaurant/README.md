
# 🍽️ Haskell Restaurant System Exercise

## 📋 Project Overview

Build a restaurant order processing system that practices core Haskell concepts. You'll create types, implement business logic, and handle edge cases using functional programming patterns.

## 🎯 Learning Objectives

Practice: type aliases, function composition (`.`), application (`$`), type classes, monads, higher-order functions, lambda expressions, and currying.

---

## 📁 Part 1: Type Definitions & Aliases

### Step 1: Create Type Aliases

Define these type synonyms for better readability:

- `CustomerId` → `Int`
- `ItemName` → `String`
- `Price` → `Float`
- `Quantity` → `Int`

### Step 2: Define Core Data Types

- `MenuItem` record with:
    - `itemName :: ItemName`
    - `itemPrice :: Price`
    - Derive `Show` and `Eq` instances
- `Order` as a list of `(MenuItem, Quantity)` pairs
- `Customer` record with:
    - `customerId :: CustomerId`
    - `customerName :: String`
    - `customerOrder :: Order`
    - Derive `Show` instance

---

## 🔧 Part 2: Core Functions

### Step 3: Menu Operations

#### Apply Discount Function
- Write `applyDiscount :: (Price -> Price) -> [MenuItem] -> [MenuItem]`
- Takes a discount function and applies it to all menu items
- Use a lambda expression to transform each item
- Example: 10% discount = `(*0.9)` function

#### Calculate Order Total
- Write `orderTotal :: Order -> Price`
- Calculate sum of (price × quantity) for all items
- Use function composition (`.`) to chain operations
- Use `$` operator for clean parentheses-free code

### Step 4: Type Class Implementation

#### Make MenuItem Orderable
- Implement `Ord` instance for `MenuItem`
- Primary ordering: by price (cheapest first)
- Secondary ordering: by name (alphabetical)
- Use type class inheritance (`Ord` requires `Eq`)

#### Create Discountable Type Class
- Define class: `class Discountable a where`
- Method: `applyDiscountTo :: a -> Price -> a`
- Make `MenuItem` an instance

---

## 🚦 Part 3: Monadic Validation

### Step 5: Order Validation with Maybe Monad

Write `validateOrder :: Order -> Maybe Order` that:
- Uses `Maybe` monad with `>>=` (bind operator)
- First check: Reject empty orders (return `Nothing`)
- Second check: Validate all quantities are positive
- Chain operations using monadic binding
- Return `Just validOrder` if all checks pass

### Step 6: Customer Order Processing

Write `processCustomerOrder :: Customer -> Maybe (Customer, Price)` that:
- Validates the customer's order
- Calculates total price
- Applies 10% discount for orders over $50
- Returns updated customer and final price
- Returns `Nothing` for invalid orders

---

## 🎯 Part 4: Currying & Partial Application

### Step 7: Order Building Functions

#### Curried Function
- Write `addToOrder :: MenuItem -> Quantity -> Order -> Order`
- Adds an item with quantity to an existing order

#### Partial Application
- Create `addBurger :: Quantity -> Order -> Order`
- Create `addFries :: Quantity -> Order -> Order`
- These should be partially applied versions of `addToOrder` with specific menu items pre-filled

---

## 🧪 Part 5: Testing Your Implementation

### Test Data
- Sample menu with 3+ items (Burger, Fries, Soda, etc.)
- Customer with valid order (multiple items, quantities > 0)
- Customer with empty order

### Expected Test Results
Run these operations and verify:
- ✅ Order total calculation is correct
- ✅ Empty orders fail validation (`Nothing`)
- ✅ Discounts apply correctly (> $50 gets 10% off)
- ✅ Menu items can be sorted by price
- ✅ Partial application functions work
- ✅ Discount function works on entire menu

---

## 📝 Implementation Guidelines

- Use type inference where possible (let Haskell figure out types)
- Prefer point-free style with `.` and `$` when it improves readability
- Use lambda expressions for simple one-time transformations
- Ensure monadic operations properly handle failure cases
- Apply currying naturally where it makes sense

---

## 🎓 Success Criteria

Your solution should demonstrate:
- Clean separation of pure and monadic code
- Proper use of type classes and instances
- Effective function composition and application
- Correct handling of optional values with `Maybe`
- Elegant use of higher-order functions

---

## 💡 Tips

- Start with type signatures before implementations
- Test each function independently in GHCi
- Use `:t` in GHCi to check inferred types
- Remember: `>>=` for sequential operations, `.` for function composition
- Partial application = free functionality from currying!