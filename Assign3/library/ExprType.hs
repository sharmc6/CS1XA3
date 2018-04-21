{-|
Module : ExprType
Description : Contains The Type Definition for The Expr Type
Copyright : (c) Chitwan Sharma 2018
License : MIT
Maintainer : sharmc6@mcmaster.ca
Stability : experimental
Portability : DOS
-------------------------
Supports the followwing operations
-   Add - binary addition
-   Mult - binary multiplication
-   Const - value wrapper
-   Var - variable identifier
-}
module ExprType where

import Data.List


-- | Expression DataType Declaration
data Expr a = Add (Expr a) (Expr a)   -- ^ Binary Addition
            | Mult (Expr a) (Expr a)  -- ^ Binary Multiplication
            | Const a                 -- ^ Value Wrapper
            | Var String              -- ^ Variable Identifier
            | Cos (Expr a)            -- ^ Cosine of Another Expression
            | Sin (Expr a)            -- ^ Since of Another Expression
            | Natlog (Expr a)         -- ^ Natural Log of Another Expression
            | Exp (Expr a)            -- ^ Base e to The Power of Another Expression
            | Power (Expr a) (Expr a) -- ^ Raise the Expression to a Power
    deriving Eq


-- | Function For Obtaining Variables From an Expr Type Expression
getVars :: Expr a -> [String] 
getVars (Add e1 e2) = getVars e1 `union` getVars e2
getVars (Mult e1 e2) = getVars e1 `union` getVars e2
getVars (Cos e1) = getVars e1
getVars (Sin e1) = getVars e1
getVars (Natlog e1) = getVars e1
getVars (Exp e1) = getVars e1
getVars (Const _) = []
getVars (Var x) = [x]
getVars (Power e1 e2) = getVars e1 `union` getVars e2