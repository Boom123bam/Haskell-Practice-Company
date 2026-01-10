module Main where

data Department = Engineering | Marketing | Sales | HR | Finance | IT
    deriving (Show, Eq)

data Status = Active Int | OnLeave String | Terminated String
    deriving (Show, Eq)

data ContactInfo = Email String | Phone String | Both String String | None
    deriving (Show, Eq)

data Employee = Employee
    { name :: String
    , age :: Int
    , salary :: Float
    , dept :: Department
    , status :: Status
    , skills :: [String]
    , performanceRating :: Int
    , emergencyContact :: ContactInfo
    }
    deriving (Show, Eq)

-- inRangeInc :: a -> (b,c) -> Bool
inRangeInc i (a,b) = i >= a && i <= b

categorizeEmployee::Employee->String
categorizeEmployee e 
    | age e < 30 && salary e < 50000 = "Junior"
    | inRangeInc (age e) (30,45) || inRangeInc (salary e) (50000, 90000) = "Mid-Level"
    | age e > 45 && salary e > 90000 = "Senior"
    | otherwise = "special case"

calculateBonus::Employee -> Int
calculateBonus e = case (dept e, performanceRating e) of
    (Engineering, rating) -> 5000*rating
    (Marketing, rating) -> 3000*rating
    (Sales, rating) -> 4000*rating +(if rating == 5 then 1000 else 0)
    (HR, rating) -> 2000*rating
    (_,rating) -> 1500*rating


contains::[String] -> String -> Bool
contains [] _ = False
contains (x:xs) e = if x == e then True else contains xs e

findEmployeeBySkill::[Employee] -> String -> Maybe Employee
findEmployeeBySkill [] _ = Nothing
findEmployeeBySkill (e:es) skill = if contains (skills e) skill then Just e else findEmployeeBySkill es skill

promotionEligible :: Employee -> Bool
promotionEligible e = base && additional where
    base = case status e of
        Active n -> n>2
        _ -> False
    additional = performanceRating e >= 4

uniqueJoin :: [String] -> [String] -> [String]
uniqueJoin as [] = as
uniqueJoin as (b:bs) = uniqueJoin newAs bs where
    newAs = if b `elem` as then b:as else as

departmentStats :: [Employee] -> Department -> (Int, Float, [String])
departmentStats allEmps d = 
    let emps = filter (\e -> dept e == d) allEmps
        count = length emps
        totalSalary = sum (map salary emps)
        avgSalary = if count == 0 
                   then 0.0 
                   else totalSalary / fromIntegral count
        uniqueSkills=foldr uniqueJoin [] (map skills emps)
    in (count, avgSalary, uniqueSkills)

-- TODO

salaryAdjustment :: Employee -> Employee
salaryAdjustment e = e

filterByComplexCriteria :: [Employee] -> [Employee]
filterByComplexCriteria _ = []

organizeByDepartment :: [Employee] -> [(Department, [Employee])]
organizeByDepartment _ = []










-- ==================== SAMPLE TEST DATA ====================
-- Create diverse test employees
sampleEmployees :: [Employee]
sampleEmployees =
    [ Employee "Alice Chen" 28 48000 Engineering (Active 3) ["Haskell", "Python", "Docker"] 4 (Both "alice@company.com" "555-0101")
    , Employee "Bob Smith" 42 95000 Sales (Active 10) ["Negotiation", "CRM", "Public Speaking"] 5 (Email "bob@company.com")
    , Employee "Carol Davis" 35 75000 Marketing (OnLeave "Maternity") ["SEO", "Analytics", "Content"] 3 (Phone "555-0202")
    , Employee "David Wilson" 50 120000 Engineering (Active 20) ["C++", "Linux", "Kubernetes", "AWS"] 5 (Email "david@company.com")
    , Employee "Eve Johnson" 26 42000 HR (Active 1) ["Recruitment", "Training"] 2 None
    , Employee "Frank Miller" 48 88000 Sales (Terminated "Performance") ["Sales", "Marketing"] 1 (Phone "555-0303")
    , Employee "Grace Lee" 32 68000 IT (Active 5) ["JavaScript", "React", "Node.js", "TypeScript"] 4 (Both "grace@company.com" "555-0404")
    , Employee "Henry Brown" 55 110000 Finance (Active 25) ["Accounting", "Excel", "Tax"] 3 (Email "henry@company.com")
    , Employee "Ivy Taylor" 29 52000 Engineering (Active 4) ["Python", "ML", "Data Analysis"] 5 (Phone "555-0505")
    , Employee "Jack White" 45 92000 Marketing (Active 12) ["Branding", "Social Media"] 4 (Email "jack@company.com")
    ]

-- Single employee for focused tests
testEmployee1 :: Employee
testEmployee1 = head sampleEmployees  -- Alice Chen

testEmployee2 :: Employee
testEmployee2 = sampleEmployees !! 1  -- Bob Smith

testEmployee3 :: Employee
testEmployee3 = sampleEmployees !! 4  -- Eve Johnson

-- ==================== TEST FUNCTIONS ====================

-- Test 1: categorizeEmployee
testCategorizeEmployee :: IO ()
testCategorizeEmployee = do
    putStrLn $ "\n=== Testing categorizeEmployee ==="
    putStrLn $ "Alice (28, 48000): " ++ categorizeEmployee testEmployee1
    putStrLn $ "Bob (42, 95000): " ++ categorizeEmployee testEmployee2
    putStrLn $ "David (50, 120000): " ++ categorizeEmployee (sampleEmployees !! 3)
    putStrLn $ "Eve (26, 42000): " ++ categorizeEmployee testEmployee3
    
    -- Test all employees
    putStrLn $ "\nAll employees categorized:"
    mapM_ (\e -> putStrLn $ name e ++ ": " ++ categorizeEmployee e) sampleEmployees

-- Test 2: calculateBonus
testCalculateBonus :: IO ()
testCalculateBonus = do
    putStrLn $ "\n=== Testing calculateBonus ==="
    putStrLn $ "Alice (Engineering, rating 4): " ++ show (calculateBonus testEmployee1)
    putStrLn $ "Bob (Sales, rating 5): " ++ show (calculateBonus testEmployee2)
    putStrLn $ "Carol (Marketing, rating 3): " ++ show (calculateBonus (sampleEmployees !! 2))
    putStrLn $ "David (Engineering, rating 5): " ++ show (calculateBonus (sampleEmployees !! 3))
    putStrLn $ "Eve (HR, rating 2): " ++ show (calculateBonus testEmployee3)
    
    -- Edge case: Unknown department (if you have default case)
    putStrLn $ "Henry (Finance, rating 3): " ++ show (calculateBonus (sampleEmployees !! 7))

-- Test 3: findEmployeeBySkill
testFindEmployeeBySkill :: IO ()
testFindEmployeeBySkill = do
    putStrLn $ "\n=== Testing findEmployeeBySkill ==="
    
    let skill1 = "Python"
    putStrLn $ ("Looking for skill '" ++ skill1 ++ "':")
    case findEmployeeBySkill sampleEmployees skill1 of
        Nothing -> putStrLn $ "  Not found"
        Just e -> putStrLn $ "  Found: " ++ name e
        
    let skill2 = "Haskell"
    putStrLn $ ("Looking for skill '" ++ skill2 ++ "':")
    case findEmployeeBySkill sampleEmployees skill2 of
        Nothing -> putStrLn $ "  Not found"
        Just e -> putStrLn $ "  Found: " ++ name e
        
    let skill3 = "NonExistentSkill"
    putStrLn $ ("Looking for skill '" ++ skill3 ++ "':")
    case findEmployeeBySkill sampleEmployees skill3 of
        Nothing -> putStrLn $ "  Not found (correct!)"
        Just e -> putStrLn $ "  Found: " ++ name e
    
    -- Test with empty list
    putStrLn $ "\nTesting with empty list:"
    case findEmployeeBySkill [] "Python" of
        Nothing -> putStrLn $ "  Nothing returned (correct)"
        Just _ -> putStrLn $ "  ERROR: Should return Nothing"

-- Test 4: promotionEligible
testPromotionEligible :: IO ()
testPromotionEligible = do
    putStrLn $ "\n=== Testing promotionEligible ==="
    
    putStrLn $ "Alice (Active 3y, rating 4): " ++ show (promotionEligible testEmployee1)
    putStrLn $ "Bob (Active 10y, rating 5): " ++ show (promotionEligible testEmployee2)
    putStrLn $ "Carol (OnLeave): " ++ show (promotionEligible (sampleEmployees !! 2))
    putStrLn $ "Eve (Active 1y, rating 2): " ++ show (promotionEligible testEmployee3)
    putStrLn $ "Frank (Terminated): " ++ show (promotionEligible (sampleEmployees !! 5))
    putStrLn $ "David (Active 20y, rating 5): " ++ show (promotionEligible (sampleEmployees !! 3))

-- Test 5: departmentStats
testDepartmentStats :: IO ()
testDepartmentStats = do
    putStrLn $ "\n=== Testing departmentStats ==="
    
    putStrLn $ "Engineering Department Stats:"
    let (count, avgSalary, skillsList) = departmentStats sampleEmployees Engineering
    putStrLn $ "  Count: " ++ show count
    putStrLn $ "  Average Salary: " ++ show avgSalary
    putStrLn $ "  Unique Skills: " ++ show skillsList
    
    putStrLn $ "\nSales Department Stats:"
    let (count2, avgSalary2, skillsList2) = departmentStats sampleEmployees Sales
    putStrLn $ "  Count: " ++ show count2
    putStrLn $ "  Average Salary: " ++ show avgSalary2
    putStrLn $ "  Unique Skills: " ++ show skillsList2
    
    putStrLn $ "\nHR Department Stats:"
    let (count3, avgSalary3, skillsList3) = departmentStats sampleEmployees HR
    putStrLn $ "  Count: " ++ show count3
    putStrLn $ "  Average Salary: " ++ show avgSalary3
    putStrLn $ "  Unique Skills: " ++ show skillsList3
    
    -- Test with non-existent department
    putStrLn $ "\nNon-existent Department Stats (should handle gracefully):"
    let (count4, avgSalary4, skillsList4) = departmentStats sampleEmployees IT
    putStrLn $ "  Count: " ++ show count4
    putStrLn $ "  Average Salary: " ++ show avgSalary4
    putStrLn $ "  Unique Skills: " ++ show skillsList4

-- Test 6: salaryAdjustment
testSalaryAdjustment :: IO ()
testSalaryAdjustment = do
    putStrLn $ "\n=== Testing salaryAdjustment ==="
    
    putStrLn $ "Alice (Engineering, 28):"
    let aliceAdjusted = salaryAdjustment testEmployee1
    putStrLn $ "  Old: " ++ show (salary testEmployee1)
    putStrLn $ "  New: " ++ show (salary aliceAdjusted)
    putStrLn $ "  Increase: " ++ show (salary aliceAdjusted - salary testEmployee1)
    
    putStrLn $ "\nDavid (Engineering, 50):"
    let david = sampleEmployees !! 3
    let davidAdjusted = salaryAdjustment david
    putStrLn $ "  Old: " ++ show (salary david)
    putStrLn $ "  New: " ++ show (salary davidAdjusted)
    putStrLn $ "  Increase: " ++ show (salary davidAdjusted - salary david)
    
    putStrLn $ "\nBob (Sales, rating 5):"
    let bobAdjusted = salaryAdjustment testEmployee2
    putStrLn $ "  Old: " ++ show (salary testEmployee2)
    putStrLn $ "  New: " ++ show (salary bobAdjusted)
    
    putStrLn $ "\nEve (HR, rating 2):"
    let eveAdjusted = salaryAdjustment testEmployee3
    putStrLn $ "  Old: " ++ show (salary testEmployee3)
    putStrLn $ "  New: " ++ show (salary eveAdjusted)

-- Test 7: filterByComplexCriteria (Bonus)
testFilterByComplexCriteria :: IO ()
testFilterByComplexCriteria = do
    putStrLn $ "\n=== Testing filterByComplexCriteria (Bonus) ==="
    
    let filtered = filterByComplexCriteria sampleEmployees
    putStrLn $ "Number of employees matching complex criteria: " ++ show (length filtered)
    putStrLn $ "Matching employees:"
    mapM_ (\e -> putStrLn $ "  - " ++ name e ++ " (" ++ show (dept e) ++ ")") filtered

-- Test 8: organizeByDepartment (Bonus)
testOrganizeByDepartment :: IO ()
testOrganizeByDepartment = do
    putStrLn $ "\n=== Testing organizeByDepartment (Bonus) ==="
    
    let organized = organizeByDepartment sampleEmployees
    mapM_ (\(dept, emps) -> 
        putStrLn $ show dept ++ ": " ++ show (length emps) ++ " employees") organized

-- Comprehensive test runner
runAllTests :: IO ()
runAllTests = do
    putStrLn $ "========================================="
    putStrLn $ "   EMPLOYEE MANAGEMENT SYSTEM TESTS      "
    putStrLn $ "========================================="
    
    testCategorizeEmployee
    testCalculateBonus
    testFindEmployeeBySkill
    testPromotionEligible
    testDepartmentStats
    testSalaryAdjustment
    
    -- Uncomment these when you implement bonus functions
    -- testFilterByComplexCriteria
    -- testOrganizeByDepartment
    
    putStrLn $ "\n========================================="
    putStrLn $ "              TESTS COMPLETE             "
    putStrLn $ "========================================="

-- Quick individual test (for REPL testing)
quickTest :: IO ()
quickTest = do
    putStrLn $ "Quick test of first 3 functions:"
    putStrLn $ "Alice category: " ++ categorizeEmployee testEmployee1
    putStrLn $ "Alice bonus: " ++ show (calculateBonus testEmployee1)
    putStrLn $ "Find Haskell skill: " ++ 
        case findEmployeeBySkill sampleEmployees "Haskell" of
            Nothing -> "Not found"
            Just e -> name e

-- Helper function to create more test cases
createEdgeCaseEmployees :: [Employee]
createEdgeCaseEmployees =
    [ Employee "Young High Earner" 25 95000 Sales (Active 1) [] 3 None
    , Employee "Old Low Earner" 60 30000 HR (Active 30) [] 1 None
    , Employee "Max Rating" 30 50000 Engineering (Active 2) [] 5 None
    , Employee "Min Rating" 30 50000 Engineering (Active 2) [] 1 None
    , Employee "No Skills" 35 60000 Marketing (Active 5) [] 3 None
    , Employee "Many Skills" 40 80000 IT (Active 8) 
        ["A","B","C","D","E","F","G"] 4 None
    ]

-- Test edge cases
testEdgeCases :: IO ()
testEdgeCases = do
    putStrLn $ "\n=== Testing Edge Cases ==="
    let edgeEmployees = createEdgeCaseEmployees
    
    putStrLn $ "Categorization edge cases:"
    mapM_ (\e -> putStrLn $ name e ++ ": " ++ categorizeEmployee e) edgeEmployees
    
    putStrLn $ "\nBonus calculation edge cases:"
    mapM_ (\e -> putStrLn $ name e ++ ": " ++ show (calculateBonus e)) edgeEmployees

-- ==================== HOW TO USE ====================
-- In your REPL/compiler:
-- 1. Load your Employee module
-- 2. Load this test file
-- 3. Run: runAllTests
-- 4. Or test individually: testCalculateBonus
-- 5. For quick check: quickTest

main :: IO ()
main = do
    runAllTests
    -- Uncomment to also test edge cases
    -- testEdgeCases 