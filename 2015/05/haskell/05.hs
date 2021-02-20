main = interact (concat . map (flip (++) "\n") . doParts)

doParts :: String -> [String]
doParts s = map (\f -> show . f $ lines s) [partA, partB]


-- Part A
partA :: [String] -> Int
partA = countNice criteriaA

countNice :: (String -> Bool) -> [String] -> Int
countNice criteria ss = sum $ map (fromEnum . criteria) ss

criteriaA :: String -> Bool
criteriaA s = and [hasThreeVowels s, hasConsecutiveDuplicates s, not (hasNaughtyChars s)]

-- Part A criteria
hasThreeVowels :: [Char] -> Bool
hasThreeVowels s = countVowels s >= 3

countVowels :: [Char] -> Int
countVowels s = sum (map (fromEnum . isVowel) s)

isVowel :: Char -> Bool
isVowel s
  | elem s "aeiou" = True
  | otherwise = False

hasConsecutiveDuplicates :: [Char] -> Bool
hasConsecutiveDuplicates s = any (==True) (zipWith (==) (init s) (tail s))

hasNaughtyChars :: [Char] -> Bool
hasNaughtyChars s = any (==True) (zipWith isNaughtyChars (init s) (tail s))

isNaughtyChars :: Char -> Char -> Bool
isNaughtyChars 'a' 'b' = True
isNaughtyChars 'c' 'd' = True
isNaughtyChars 'p' 'q' = True
isNaughtyChars 'x' 'y' = True
isNaughtyChars  _   _  = False


-- Part B
partB :: [String] -> Int
partB = countNice criteriaB

criteriaB :: String -> Bool
criteriaB s = and [hasPairTwice s, hasRepeatWithSpace s]

-- Part B criteria
hasRepeatWithSpace :: [Char] -> Bool
hasRepeatWithSpace s = any (==True) (zipWith (==) (init (init s)) (tail (tail s)))

hasPairTwice :: [Char] -> Bool
hasPairTwice s 
  | length(s) > 2 = containsSubstring (tail (tail s)) (take 2 s) || hasPairTwice (tail s)
  | otherwise = False

containsSubstring :: String -> String -> Bool
containsSubstring s sub
  | length(s) >= length(sub) = (take (length sub) s) == sub || containsSubstring (tail s) sub
  | otherwise = False
