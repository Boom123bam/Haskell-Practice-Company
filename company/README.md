# Challenge: Employee Management System

## Overview

Build a comprehensive employee management system using functional programming concepts. You'll model employees, departments, and company operations while implementing various business logic functions.

## Core Data Types to Define

### 1. Department ADT (Algebraic Data Type)

Create a sum type `Department` with at least these variants:
- Engineering
- Marketing
- Sales
- HR
- Add 1-2 more departments of your choice

### 2. Employee Status ADT

Create another ADT `Status` representing employment status:
- `Active` (with an `Int` representing years of service)
- `OnLeave` (with a `String` reason and maybe end date)
- `Terminated` (with a `String` reason and maybe termination date)

### 3. Employee Record Type

Define a product type `Employee` with:
- `name :: String`
- `age :: Int`
- `salary :: Float`
- `dept :: Department`
- `status :: Status`
- `skills :: [String]` (list of skills)
- `performanceRating :: Int` (1-5 scale)

## Required Functions to Implement

### Function 1: categorizeEmployee

- **Input:** `Employee`
- **Output:** `String` category
- **Logic:** Use guards to categorize based on age AND salary:
  - "Junior" if age < 30 AND salary < 50000
  - "Mid-Level" if age 30-45 OR salary 50000-90000
  - "Senior" if age > 45 AND salary > 90000
  - "Special Case" for any other combination

### Function 2: calculateBonus

- **Input:** `Employee`
- **Output:** `Float` bonus amount
- **Logic:** Use case expression on the tuple `(dept, performanceRating)`:
  - Engineering: 5000 * rating
  - Marketing: 3000 * rating
  - Sales: 4000 * rating + special 1000 if rating == 5
  - HR: 2000 * rating
  - Default for other departments: 1500 * rating

### Function 3: findEmployeeBySkill

- **Input:** `[Employee]` (list of employees), `String` (skill to find)
- **Output:** `Maybe Employee`
- **Logic:** Use list pattern matching and recursion to find first employee with the skill
  - Return `Just employee` if found, `Nothing` if not found
  - Must use pattern matching on the list: `(x:xs)` pattern

### Function 4: promotionEligible

- **Input:** `Employee`
- **Output:** `Bool`
- **Logic:** Use pattern matching on the `Status` ADT:
  - Only `Active` employees with >2 years service are eligible
  - `OnLeave` or `Terminated` employees are not eligible
  - Additional criteria: `performanceRating` must be >= 4

### Function 5: departmentStats

- **Input:** `[Employee]`, `Department`
- **Output:** Tuple `(Int, Float, [String])`
- **Logic:** Use `let` and `where` clauses to calculate:
  - First element: Count of employees in department
  - Second element: Average salary in department
  - Third element: List of unique skills in department
  - Must use `let` for intermediate calculations and `where` for helper functions

### Function 6: salaryAdjustment

- **Input:** `Employee`
- **Output:** `Employee` (with adjusted salary)
- **Logic:** Create a new employee record with adjusted salary based on:
  - 10% raise if in Engineering department AND age < 40
  - 5% raise if performanceRating == 5
  - 2% raise for everyone else
  - Use pattern matching on the `Employee` record to extract fields

## Advanced Challenges (Bonus)

### Function 7: filterByComplexCriteria

- **Input:** `[Employee]`
- **Output:** `[Employee]`
- **Logic:** Use list comprehensions with multiple conditions:
  - Active status
  - Either in Engineering OR Sales
  - Has at least 3 skills
  - Salary between 40000 and 100000

### Function 8: organizeByDepartment

- **Input:** `[Employee]`
- **Output:** `[(Department, [Employee])]` (list of tuples)
- **Logic:** Group employees by department into tuple pairs

### Function 9: emergencyContact

- Create a new ADT `ContactInfo` with:
  - `Email String`
  - `Phone String`
  - `Both String String`
  - `None`
- Add `emergencyContact :: ContactInfo` field to `Employee`
- Write a function to extract contact info with pattern matching on `ContactInfo`

## Test Data

Create a list of at least 8-10 sample employees with varied:
- Departments
- Statuses (Active, OnLeave, Terminated)
- Age ranges (20-60)
- Salaries (30000-120000)
- Performance ratings (1-5)
- Skills lists (varying lengths 0-5)

## Constraints & Requirements

- **NO** use of `if-then-else` (use guards, pattern matching, or case instead)
- **MUST** use pattern matching on ADTs in at least 3 functions
- **MUST** use `let` or `where` in at least 2 functions
- **MUST** use case expression in at least 1 function
- **MUST** handle edge cases (empty lists, etc.)
- Type signatures required for all functions