{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Htm.Stats
  ( Stats (..)
  , emptyStats
  , saveStatsToFile
  ) where


import           Data.Aeson           (ToJSON (..), encode, object, (.=))
import qualified Data.ByteString.Lazy as LB (writeFile)
import           Data.Int             (Int64)

data Stats = Stats
  { trainCount      :: Int
  , testCount       :: Int
  , trainStartedAt  :: Int64
  , trainFinishedAt :: Int64
  , trainSpent      :: String
  , testStartedAt   :: Int64
  , testFinishedAt  :: Int64
  , testSpent       :: String
  , testScore       :: Int
  }
  deriving (Show)


emptyStats :: Stats
emptyStats = Stats
  { trainCount      = 0
  , testCount       = 0
  , trainStartedAt  = 0
  , trainFinishedAt = 0
  , trainSpent      = ""
  , testStartedAt   = 0
  , testFinishedAt  = 0
  , testSpent       = ""
  , testScore       = 0
  }


instance ToJSON Stats where
  toJSON Stats {..} = object
    [ "train_count"       .= trainCount
    , "test_count"        .= testCount
    , "started_at"        .= trainStartedAt
    , "train_started_at"  .= trainStartedAt
    , "train_iter"        .= trainCount
    , "train_finished_at" .= trainFinishedAt
    , "test_started_at"   .= testStartedAt
    , "test_iter"         .= testCount
    , "test_finished_at"  .= testFinishedAt
    , "score"             .= testScore
    , "finished_at"       .= testFinishedAt
    ]


saveStatsToFile :: FilePath -> Stats -> IO ()
saveStatsToFile path = LB.writeFile path . encode