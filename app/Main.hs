module Main where

import System.Environment (getArgs)
import Control.Exception (evaluate)

-- expecting to be launched with
-- tail -F -N +$(<offset) mylog | { ./me --offset-out offset; pkill -P$$ tail; }

main = do
  ["--offset-out", offsetOutPath] <- getArgs
  offset <- fmap read (readFile offsetOutPath)
  evaluate offset -- annoying. causes readFile lazy I/O to finish and close the file
  mainLoop offset offsetOutPath $ \line -> do
    -- do what you will with line
    putStrLn line -- dummy example

mainLoop offset offsetOutPath crunchLine = do
  line <- getLine
  let offset' = offset+1
  crunchLine line
  writeFile offsetOutPath (show offset')
  mainLoop offset' offsetOutPath crunchLine
