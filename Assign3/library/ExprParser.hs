{-# LANGUAGE FlexibleContexts #-}
{-|
Module : ExprParser
Description : Contains The Various Parsers Needed
              To Parse Certain Strings to Expr.
Copyright : (c) Chitwan Sharma 2018
License : MIT
Maintainer : sharmc6@mcmaster.ca
Stability : experimental
Portability : DOS

-}
module ExprParser where

import ExprType
import ExprPretty
import ExprDiff
import Text.Parsec
import Text.Parsec.String
import Text.Parsec.Expr


-- * Main Parsing Functions

-- | Parses a String Into an Expr Double Type Using The exprD Parser
parseExprD :: String -> Expr Double
parseExprD ss = case parse exprD "" ss of
                  Left err   -> error $ show err
                  Right expr -> expr

-- | Parses a String Into an Expr Float Type Using The exprF Parser
parseExprF :: String -> Expr Float
parseExprF ss = case parse exprF "" ss of
                  Left err   -> error $ show err
                  Right expr -> expr

-- | Parses a String Into an Expr Integer Type Using The exprI Parser
parseExprI :: String -> Expr Integer
parseExprI ss = case parse exprI "" ss of
                  Left err   -> error $ show err
                  Right expr -> expr

{- Parsers Used In The Functions Above -}

-- * Main Parsers Used in The Parsing Functions

-- | Parses All Valid Strings Into 'Expr' 'Double' Types Using Text.Parsec.Expr Parser Maker
exprD :: Parser (Expr Double)
exprD = buildExpressionParser table factord <?> "exprD Error!"

table = [[binary "*" Mult AssocLeft], [binary "+" Add AssocLeft], [binary "^" Power AssocLeft], [preop "e**" Exp]
        , [preop "ln" Natlog], [preop "cos" Cos], [preop "sin" Sin]]
    where
      binary str exprr assoc = Infix (do { string str;
                                 return exprr}) assoc

      preop str exprr = Prefix (do { string str;
                               return exprr})

-- | Statement For Parsing String With 'Expr' 'Double' Type to Actual Type
factord = do { char '('; x <- exprD; char ')'; return x} <|> numd <|> varOpD <?> "simple expression"

-- | Parses All Valid Strings Into 'Expr' Types Using Text.Parsec.Expr Parser Maker
exprF :: Parser (Expr Float)
exprF = buildExpressionParser table factorf <?> "exprF Error"


-- | Statement For Parsing String With 'Expr' 'Float' Type to Actual Type
factorf = do { char '('; x <- exprF; char ')'; return x} <|> numf <|> varOpF <?> "simple expression"

-- | Parses All Valid Strings Into 'Expr' Types Using Text.Parsec.Expr Parser Maker
exprI :: Parser (Expr Integer)
exprI = buildExpressionParser table factori <?> "exprI Error"

factori = do { char '('; x <- exprI; char ')'; return x} <|> numi <|> varOpI <?> "simple expression"


{- Parsers Used In exprD, exprF, exprI -}

-- * Parsers For Extracting Various Num Types and Vars (Parsers Used In exprD, exprF, exprI)

-- | Parses All Valid Strings Into a 'Double'
numd :: Parser (Expr Double)
numd = do {
             d <- double;
             return (Const (read d))}

-- | Parses All Valid Strings Into a 'Float'
numf :: Parser (Expr Float)
numf = do {
             d <- double;
             return (Const (read d))}

-- | Parses All Valid Strings Into an 'Integer'
numi :: Parser (Expr Integer)
numi = do {
             d <- integer1;
             return (Const (read d))}

-- | Parses All Valid Strings to a Variable Identifier For 'Expr' 'Double' Types
varOpD :: Parser (Expr Double)
varOpD = do { 
             var1 <- many1 letter;
             return (Var var1) }

-- | Parses All Valid Strings to a Variable Identifier For 'Expr' 'Float' Types
varOpF :: Parser (Expr Float)
varOpF = do { 
             var1 <- many1 letter;
             return (Var var1) }

-- | Parses All Valid Strings to a Variable Identifier For 'Expr' 'Integer' Types
varOpI :: Parser (Expr Integer)
varOpI = do { 
             var1 <- many1 letter;
             return (Var var1) }


{- Accessory Parsers -}

-- * Smaller Accessory Parsers Used in The Larger Parsers

-- | Takes a 'String' and Parses it Into a Format So That it Can Be Used With Read
double :: Parser String
double = do { spaces;
              f1 <- (integer1) <|> return "0";
              dot <- (symbol ".");
              f2 <- (digits) <|> return "0";
              spaces;
              return (f1 ++ dot ++ f2) }


-- | Takes a 'String' With a Symbol and Parses it
symbol :: String -> Parser String
symbol ss = let
  symbol' :: Parser String
  symbol' = do { spaces;
                 ss' <- string ss;
                 spaces;
                 return ss' }
  in try symbol'

-- | Takes a 'String' With Digit(s) and Parses it
digits :: Parser String
digits = many1 digit

-- | Takes a 'String' With Negative Digit(s) and Parses it
negDigits :: Parser String
negDigits = do { neg <- symbol "-" ;
                 dig <- digits ;
                 return (neg ++ dig) }

-- | Takes a 'String' With Integer(s) and Parses it
integer1 :: Parser String
integer1 =  negDigits <|> digits