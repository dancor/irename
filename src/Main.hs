import Control.Applicative
import Control.Monad
import FUtil
import System.Directory
import System.Environment
import System.Process

-- don't actually need " stuff..
encode = show

main = do
  args <- getArgs
  -- fixme
  let tempF = "tmp"
  cs <- zip args . map encode <$> mapM readFile args
  writeFile tempF . unlines $ map (\ (a, b) -> a ++ "\t" ++ b) cs
  p <- runProcess "vim" [tempF] Nothing Nothing Nothing Nothing Nothing
  waitForProcess p
  ls <- filter (not . null) . map (takeWhile (/= '\t')) . lines <$>
    readFile tempF
  if length ls == length args
    then mapM_ (\ (old, new) -> when (old /= new) $ renameFile old new) $
      zip args ls
    else error "Line count mismatch, aborting without moving any files."

