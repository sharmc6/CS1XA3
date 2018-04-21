{-|
Module : ExprType
Description : Takes 'Expr' expressions and prints them in a readable format
-}
module ExprPretty where

import ExprType

-- | Function For Providing Brackets Around a String
parens1 :: String -> String
parens1 ss = "(" ++ ss ++ ")"

parens :: String -> String
parens ss = ss

-- | Instance of Show Class For The Expr Type Expressions
instance Show a => Show (Expr a) where
    show (Mult e1 e2)  = parens1 $ (show e1) ++ " !* " ++ (show e2)
    show (Add e1 e2) = parens1 $ (show e1) ++ " + " ++ (show e2)
    show (Var ss) = parens $ "var \"" ++ ss ++ "\""
    show (Const x) = parens $ "val " ++ show x
    show (Natlog x) = parens1 $ "Ln " ++ show x
    show (Exp x) = parens1 $ "e ^ " ++ show x
    show (Cos x) = parens $ "Cos " ++ show x
    show (Sin x) = parens $ "Sin " ++ show x
    show (Power e1 e2) = parens1 $ show e1 ++ " ^ " ++ show e2