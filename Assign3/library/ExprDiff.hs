{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-|
Module : ExprType
Description : Functions for Computing Partial Differentiation
Copyright : (c) Chitwan Sharma 2018
License : MIT
Maintainer : sharmc6@mcmaster.ca
Stability : experimental
Portability : DOS
-}
module ExprDiff where

import ExprType
import ExprPretty

import qualified Data.Map as Map


list = Map.fromList[("x",1.0)]

-- * Class Declaration For DiffExpr
class DiffExpr a where
    -- | Function For Evaluating an Expression Given a Dictionary
    eval :: Map.Map String a -- ^ Takes a Dictionary With Strings and Numbers
            -> Expr a        -- ^ And Takes an Expression
            -> a             -- ^ Returns a Value in The Type Used In The Inputs

    -- | Function For Simplifying an Expression Given a Dictionary That May be Empty
    simplify :: Map.Map String a -- ^ Takes a Dictionary With Strings and Numbers (Possibly Empty)
                -> Expr a        -- ^ And Takes an Expression
                -> Expr a        -- ^ Returns a Possibly Simplified Expression

    -- | Function For Calculating The Partial Differentiation of an Expression
    partDiff :: String    -- ^ Takes a Variable To be Differentiated as a String
                -> Expr a -- ^ And Takes an Expression
                -> Expr a -- ^ Returns a Partial Differentiated Expression in Terms of The String Provided

    {- Default Methods -}

    -- | Generate Add Type For an Expression
    (!+) :: Expr a -> Expr a -> Expr a
    e1 !+ e2 = simplify (Map.fromList[]) $ Add e1 e2

    -- | Generate Mult Type For an Expression
    (!*) :: Expr a -> Expr a -> Expr a
    e1 !* e2 = simplify (Map.fromList[]) $ Mult e1 e2

    -- | Generate Raise Type For an Expression
    (!^) :: Expr a -> Expr a -> Expr a
    e1 !^ e2 = simplify (Map.fromList[]) $ Power e1 e2

    -- | Function For Turning a Value Into a Const Type for an Expresion
    val :: a -> Expr a
    val x = Const x

    -- | Function For Turning a String Into a Var Type for an Expresion
    var :: String -> Expr a
    var x = Var x

    -- | Function For Turning an Expr Into a Sin Type for an Expresion
    sine :: Expr a -> Expr a
    sine x = Sin x

    -- | Function For Turning an Expr Into a Cos Type for an Expresion
    cosine :: Expr a -> Expr a
    cosine x = Cos x

    -- | Function For Turning an Expr Into a Natlog Type for an Expresion
    natlog :: Expr a -> Expr a
    natlog x = Natlog x

    -- | Function For Turning an Expr Into a Exp Type for an Expresion
    expnat :: Expr a -> Expr a
    expnat x = Exp x

-- Instance for DiffExpr For Using Functions With Expr Data Types
instance (Floating a, Ord a) => DiffExpr a where
    {- Multiple Pattern Matching Situations Shown For Eval.
       The Structure is Made in a Way to Recurse Down to a Basic
       Form of Either a Variable or a Constant Term. -}
    eval vrs (Add e1 e2) = eval vrs e1 + eval vrs e2
    eval vrs (Mult e1 e2) = eval vrs e1 * eval vrs e2
    eval vrs (Const x) = x
    eval vrs (Var x) = case Map.lookup x vrs of
                        Just v -> v
                        Nothing -> error "Variables not in expression"
    eval vrs (Cos e1) = cos (eval vrs e1)
    eval vrs (Sin e1) = sin (eval vrs e1)
    eval vrs (Exp e1) = exp (eval vrs e1)
    eval vrs (Natlog e1) = if eval vrs e1 > 0 then log(eval vrs e1) else error "Log is undefined"
    eval vrs (Power e1 e2) = (eval vrs e1) ** (eval vrs e2)

    {- Multiple Pattern Matching Situations Shown For Simplify.
       The Structure is Made in a Way to Recurse Down to a Basic
       Form of Either a Variable or a Constant Term. This Function
       Also Attempts to Recognize Common Things like 0 Multiplied by a Term.
       Also, Looks For Places Where a Simple Constant can Replace an Expression. -}
    simplify vars (Add (Const e1) (Const e2)) = Const (e1 + e2)
    simplify vars (Mult (Const e1) (Const e2)) = Const (e1 * e2)
    simplify vars (Exp (Const e1)) = Const (exp e1)
    simplify vars (Natlog (Const e1)) = Const (log e1)
    simplify arg (Add e1 e2) = simplify arg $ Add (simplify arg e1) (simplify arg e2)
    simplify arg (Mult e1 e2) = 
        if (e1 == Const 0 || e2 == Const 0) then Const 0
        else Mult (simplify arg e1) (simplify arg e2)
    simplify arg (Cos e) = Cos (simplify arg e)
    simplify arg (Sin e) = Sin (simplify arg e)
    simplify arg (Natlog e) = Natlog (simplify arg e)
    simplify arg (Exp e) = Exp (simplify arg e)
    simplify arg (Power e1 e2) = Power (simplify arg e1) (simplify arg e2)
    simplify vars (Const e) = Const e
    simplify arg (Var e) = case Map.lookup e arg of
                        Just v -> (Const v)
                        Nothing -> (Var e)

    {- Multiple Pattern Matching Situations Shown For PartDiff.
       The Structure is Made assuming the User Has to Input in a
       Set Guideline.
            ie. For Expressions With a Certain Expr Raised to a Power, Only Use Raise
                and Not Mult With The Expression Multiplied With Itself.
        As can be seen Below, The partDiff Function also Utilizes the getVars Function
        From The ExprType Module. partDiff Uses it to Check Early on Whether
        a Function Has Variables or Not to Easily Provide (Const 0) in the Case it Doesn't. -}
    partDiff f (Var e) =
        if (e == f) then (Const 1)
        else Const 0
    partDiff f (Sin e) = Mult (Cos e) (partDiff f e)
    partDiff f (Cos e) = 
        if (f `elem` getVars e) then Mult (Sin e) (Mult (Const (-1)) (partDiff f e))
        else (Const 0)
    partDiff f (Add e1 e2) = Add (partDiff f e1) (partDiff f e2)
    partDiff f (Mult (Var e1) (Var e2)) =
        if (e2 == e1 && e1 == f) then (partDiff f (Power (Var e1) (Const 2)))
        else if (e1 == f && e2 /= e1) then (Mult (Const 1) (Var e2))
        else if (e2 == f && e2 /= e1) then (Mult (Var e1) (Const 1))
        else (Const 0)
    partDiff f (Mult (e1) (e2)) = (Add (Mult (partDiff f e1) (e2)) (Mult (e1) (partDiff f e2)))
    partDiff f (Power (Var e1) (Const e2)) =
        if (f == e1 && e2 > 0.0) then (Mult (Const e2) (Power (Var e1) (Const (e2-1))))
        else (Const 0)
    partDiff f (Power (e1) (Var e2)) =
        if (f == e2 && not(f `elem` getVars e1)) then (Mult (Natlog e1) (Power (e1) (Var e2)))
        else (Const 0)
    partDiff f (Exp e1) =
        if (f `elem` getVars e1) then (Mult (Exp (e1)) (partDiff f e1))
        else Const 0
    partDiff f (Natlog e1) =
        if (f `elem` getVars e1) then Mult (partDiff f e1) (Power (e1) (Const (-1)))
        else Const 0
    partDiff f (Const _) = Const 0
    partDiff _ e = e

    