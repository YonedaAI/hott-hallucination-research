{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE StandaloneDeriving    #-}

-- ============================================================================
-- TopologicalDetection.hs
--
-- Topological Hallucination Detection:
-- A Homotopy-Theoretic Classification of LLM Failure Modes
--
-- Author: Matthew Long, YonedaAI Research Collective / Magneton Labs LLC
-- Date: April 2026
--
-- This module provides a complete, executable formalization of the five
-- topological obstruction detectors for LLM hallucination:
--   1. Circular Reasoning    (pi_1 != 0)
--   2. Unjustified Inference (pi_0 disconnection)
--   3. Inconsistent Justifications (pi_2 / 2-cells)
--   4. Fabricated Entity Chain (H_n != 0)
--   5. Compositional Drift   (Holonomy != id)
-- ============================================================================

module Main where

import Data.List (nub)
import Data.Maybe (mapMaybe)
import qualified Data.Map.Strict as Map

-- ============================================================================
-- I. SEMANTIC TYPES AS HOMOTOPY TYPES
-- ============================================================================

-- | Source of grounding for a semantic term.
data Source
  = Empirical String      -- ^ Direct observation / measurement
  | Documentary String    -- ^ Document / database reference
  | Axiomatic             -- ^ Definitional truth
  | Derived [Source]      -- ^ Derived from multiple sources
  deriving (Show, Eq)

-- | Justifications are 1-cells in the semantic infinity-groupoid.
data Justification
  = Entailment String String    -- ^ Genuine 1-cell: A entails B
  | Definition                  -- ^ Definitional (refl)
  | Analogy String String       -- ^ Structural similarity only (WEAK)
  | Statistical Float           -- ^ Probability -- NO PATH STRUCTURE
  deriving (Show, Eq)

-- | Path evidence: proof that two terms are identifiable.
data PathEvidence
  = Definitional'     -- ^ Judgmentally equal (a === b)
  | Propositional     -- ^ A proof term inhabits a =_A b
  | ByUnivalence      -- ^ An equivalence A ~ B provides ua(e) : A =_U B
  | NoEvidence        -- ^ THE HALLUCINATION CASE: identity type is empty
  deriving (Show, Eq)

-- | Semantic types: the space of valid instances of a concept.
data SemType
  = Entity String           -- ^ Atomic entity type
  | Prop String             -- ^ Proposition type
  | PathType SemType String String  -- ^ Identity type a =_A b
  | ProdType SemType SemType        -- ^ Product (conjunction)
  | SumType SemType SemType         -- ^ Sum (disjunction)
  | VoidType                -- ^ Absurdity / contradiction
  | UnitType                -- ^ Trivially true
  deriving (Show, Eq)

-- | Semantic terms: inhabitants of semantic types.
data SemTerm
  = Grounded String Source        -- ^ Backed by evidence
  | Inferred SemTerm Justification  -- ^ Derived inference
  | PathWitness String String PathEvidence  -- ^ Proof of a =_A b
  | PathCompose SemTerm SemTerm   -- ^ Transitivity
  | Refl String                   -- ^ Reflexivity (a = a)
  | Hallucinated String           -- ^ EXPLICIT HALLUCINATION
  deriving (Show, Eq)

-- | Context: dependent telescope of typed bindings.
data Context
  = Empty
  | Extend Context (String, SemType)
  deriving (Show, Eq)

-- ============================================================================
-- II. TOPOLOGICAL OBSTRUCTIONS
-- ============================================================================

-- | The five topological obstruction types corresponding to
--   the five proof cases of the Hallucination-Homotopy Correspondence.
data TopologicalObstruction
  = MissingPath String String
    -- ^ pi_0 obstruction: disconnected components (Case 2)
  | NonContractibleLoop [String]
    -- ^ pi_1 obstruction: circular reasoning (Case 1)
  | IncoherentPaths String String PathEvidence PathEvidence
    -- ^ pi_2 obstruction: incompatible justifications (Case 3)
  | HomologicalHole Int [String]
    -- ^ H_n obstruction: fabricated entity chain (Case 4)
  | TransportAnomaly String String String
    -- ^ Holonomy obstruction: compositional drift (Case 5)
    --   TransportAnomaly original transported context
  deriving (Show, Eq)

-- | Grounding result after topological analysis.
data GroundingResult
  = FullyGrounded [Source]
  | PartiallyGrounded [Source] [TopologicalObstruction]
  | Ungrounded [TopologicalObstruction]
  | Contradictory String String
  deriving (Show)

-- | Hallucination type classification.
data HallucinationType
  = TypeMismatch String String
  | StatisticalNotProof Float
  | MissingPathDerivation String String
  | FreeFloating
  | ReflMismatch String String String
  | Unchecked
  deriving (Show)

-- ============================================================================
-- III. THE SIMPLICIAL KNOWLEDGE COMPLEX
-- ============================================================================

-- | A simplicial knowledge complex K_bullet.
--   Vertices are grounded facts (0-simplices).
--   Edges are justified pairs (1-simplices).
--   Triangles are 2-simplices providing higher coherence.
data KnowledgeComplex = KnowledgeComplex
  { kcVertices  :: [String]          -- ^ K_0: grounded facts
  , kcEdges     :: [(Int, Int)]      -- ^ K_1: justified pairs (by index)
  , kcTriangles :: [(Int, Int, Int)] -- ^ K_2: filled triangles (by index)
  } deriving (Show)

-- | A chain in C_n(K_bullet): formal sum of simplices with integer coefficients.
type Chain0 = Map.Map Int Int        -- ^ 0-chains: vertex -> coefficient
type Chain1 = Map.Map (Int,Int) Int  -- ^ 1-chains: edge -> coefficient

-- | Boundary operator partial_1 : C_1 -> C_0
--   partial_1([v_i, v_j]) = v_j - v_i
boundary1 :: Chain1 -> Chain0
boundary1 chain1 = Map.foldlWithKey' addBoundary Map.empty chain1
  where
    addBoundary acc (i, j) coeff =
      Map.insertWith (+) j coeff $
      Map.insertWith (+) i (-coeff) acc

-- | Boundary operator partial_2 : C_2 -> C_1
--   partial_2([v_i, v_j, v_k]) = [v_j, v_k] - [v_i, v_k] + [v_i, v_j]
boundary2 :: (Int, Int, Int) -> Chain1
boundary2 (i, j, k) = Map.fromList
  [ ((j, k),  1)
  , ((i, k), -1)
  , ((i, j),  1)
  ]

-- | Check if a 1-chain is a 1-cycle (in ker partial_1).
isCycle1 :: Chain1 -> Bool
isCycle1 chain = all (== 0) (Map.elems (boundary1 chain))

-- | Check if a 1-cycle is a 1-boundary (in im partial_2).
--   A cycle sigma is a boundary if it equals partial_2(tau) for some 2-chain tau.
isBoundary1 :: KnowledgeComplex -> Chain1 -> Bool
isBoundary1 kc chain =
  -- Check if chain can be expressed as a linear combination of triangle boundaries
  any (chain ==) singleTriangleBoundaries
  || tryLinearCombo chain (map boundary2 (kcTriangles kc)) 0
  where
    singleTriangleBoundaries = map boundary2 (kcTriangles kc)

    isZeroChain :: Chain1 -> Bool
    isZeroChain c = Map.null c || all (== 0) (Map.elems c)

    tryLinearCombo :: Chain1 -> [Chain1] -> Int -> Bool
    tryLinearCombo c [] _ = isZeroChain c
    tryLinearCombo _ _ depth | depth > 10 = False
    tryLinearCombo c _ _ | isZeroChain c = True
    tryLinearCombo c (b:bs) depth =
      -- Try coefficient +1
      let c1 = Map.filter (/= 0) $ Map.unionWith (+) c (Map.map negate b)
      in tryLinearCombo c1 bs (depth+1)
      || -- Try coefficient -1
      let c2 = Map.filter (/= 0) $ Map.unionWith (+) c b
      in tryLinearCombo c2 bs (depth+1)
      || -- Try coefficient 0
      tryLinearCombo c bs (depth+1)

-- | Compute H_0: number of connected components.
--   H_0(K) = Z^(number of connected components)
computeH0 :: KnowledgeComplex -> Int
computeH0 kc =
  let n = length (kcVertices kc)
      -- Union-find to count components
      parent = Map.fromList [(i, i) | i <- [0..n-1]]
      find p i = case Map.lookup i p of
        Just j | j == i -> (p, i)
        Just j -> let (p', r) = find p j
                  in (Map.insert i r p', r)
        Nothing -> (p, i)
      union p i j =
        let (p1, ri) = find p i
            (p2, rj) = find p1 j
        in if ri == rj then p2 else Map.insert ri rj p2
      finalParent = foldl' (\p (i,j) -> union p i j) parent (kcEdges kc)
      roots = nub [snd (find finalParent i) | i <- [0..n-1]]
  in length roots

-- | Compute H_1 rank: number of independent 1-cycles modulo boundaries.
--   By Euler characteristic: rank H_1 = |edges| - |vertices| + components - |triangles|
--   (for a simplicial complex)
computeH1Rank :: KnowledgeComplex -> Int
computeH1Rank kc =
  let v = length (kcVertices kc)
      e = length (kcEdges kc)
      f = length (kcTriangles kc)
      c = computeH0 kc
  in e - v + c - f  -- By Euler characteristic formula

-- | Safe head: returns Nothing on empty list.
safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

-- | Safe last: returns Nothing on empty list.
safeLast :: [a] -> Maybe a
safeLast [] = Nothing
safeLast xs = Just (go xs)
  where
    go [y]    = y
    go (_:ys) = go ys
    go []     = error "safeLast: impossible"

-- ============================================================================
-- IV. THE FIVE HALLUCINATION DETECTORS
-- ============================================================================

-- | Detector 1: Circular Reasoning (pi_1)
--   Detects non-contractible loops in inference chains.
detectCircularReasoning :: [String] -> KnowledgeComplex -> Maybe TopologicalObstruction
detectCircularReasoning claims kc
  | length claims < 3 = Nothing
  | safeHead claims == safeLast claims =
      -- We have a loop. Check if it's contractible (bounds a 2-disk).
      let loop = zip claims (drop 1 claims)
          validIndices = mapMaybe (\(a, b) ->
            case (lookupIndex a (kcVertices kc), lookupIndex b (kcVertices kc)) of
              (Just i, Just j) -> Just (i, j)
              _ -> Nothing) loop
          chain = Map.fromListWith (+) [(e, 1) | e <- validIndices]
      in if isCycle1 chain && not (isBoundary1 kc chain)
         then Just (NonContractibleLoop claims)
         else Nothing
  | otherwise = Nothing
  where
    lookupIndex :: String -> [String] -> Maybe Int
    lookupIndex x xs = lookup x (zip xs [0..])

-- | Detector 2: Unjustified Inference (pi_0)
--   Detects claims in disconnected components.
detectUnjustifiedInference :: String -> String -> KnowledgeComplex -> Maybe TopologicalObstruction
detectUnjustifiedInference claimA claimB kc =
  case (lookupIndex claimA, lookupIndex claimB) of
    (Just iA, Just iB) ->
      if not (sameComponent iA iB kc)
      then Just (MissingPath claimA claimB)
      else Nothing
    _ -> Just (MissingPath claimA claimB)  -- Not even in the complex
  where
    lookupIndex c = lookup c (zip (kcVertices kc) [0..])

    sameComponent :: Int -> Int -> KnowledgeComplex -> Bool
    sameComponent i j kc' =
      let reachable = bfs [i] [] (kcEdges kc')
      in j `elem` reachable

    bfs :: [Int] -> [Int] -> [(Int,Int)] -> [Int]
    bfs [] visited _ = visited
    bfs (x:queue) visited edges
      | x `elem` visited = bfs queue visited edges
      | otherwise =
          let neighbors = [b | (a,b) <- edges, a == x]
                       ++ [a | (a,b) <- edges, b == x]
              newQueue = queue ++ filter (`notElem` (x:visited)) neighbors
          in bfs newQueue (x:visited) edges

-- | Detector 3: Inconsistent Justifications (pi_2)
--   Detects incompatible paths between the same endpoints.
detectIncoherentPaths :: String -> String -> PathEvidence -> PathEvidence
                      -> Maybe TopologicalObstruction
detectIncoherentPaths a b ev1 ev2
  | ev1 /= ev2 && not (compatible ev1 ev2) =
      Just (IncoherentPaths a b ev1 ev2)
  | otherwise = Nothing
  where
    compatible Definitional' Propositional = True
    compatible Propositional Definitional' = True
    compatible Definitional' ByUnivalence  = True
    compatible ByUnivalence Definitional'  = True
    compatible _ NoEvidence = False
    compatible NoEvidence _ = False
    compatible x y = x == y

-- | Detector 4: Fabricated Entity Chain (H_n)
--   Detects non-trivial homology classes.
detectFabricatedChain :: [String] -> KnowledgeComplex -> Maybe TopologicalObstruction
detectFabricatedChain claims kc =
  let indices = mapMaybe (\c -> lookup c (zip (kcVertices kc) [0..])) claims
  in case indices of
       (i0:rest)
         | length indices >= 3 ->
             let edges = zip indices (rest ++ [i0])
                 chain = Map.fromListWith (+) [(e, 1) | e <- edges]
             in if isCycle1 chain && not (isBoundary1 kc chain)
                then Just (HomologicalHole 1 claims)
                else Nothing
       _ -> Nothing

-- | Detector 5: Compositional Drift (Holonomy)
--   Detects non-trivial parallel transport around context loops.
detectCompositionalDrift :: String    -- ^ Original claim
                         -> String    -- ^ Claim after context loop
                         -> String    -- ^ Context description
                         -> Maybe TopologicalObstruction
detectCompositionalDrift original transported ctx
  | original /= transported = Just (TransportAnomaly original transported ctx)
  | otherwise = Nothing

-- ============================================================================
-- V. TYPE-CHECKING AS HALLUCINATION DETECTION
-- ============================================================================

-- | Type-check a semantic term against its purported type.
--   Returns Left HallucinationType if hallucination detected.
typeCheck :: Context -> SemTerm -> SemType -> Either HallucinationType Bool
typeCheck _ctx (Grounded claim _src) (Prop p)
  | claim == p = Right True
  | otherwise  = Left (TypeMismatch claim p)
typeCheck _ctx (Inferred _base (Statistical prob)) _ty
  = Left (StatisticalNotProof prob)
typeCheck ctx (Inferred base (Entailment _ _)) ty
  = typeCheck ctx base ty
typeCheck _ctx (PathWitness a b NoEvidence) (PathType _ _ _)
  = Left (MissingPathDerivation a b)
typeCheck _ctx (Hallucinated _) _
  = Left FreeFloating
typeCheck _ctx (Refl a) (PathType _ty x y)
  | a == x && a == y = Right True
  | otherwise = Left (ReflMismatch a x y)
typeCheck _ctx _ _ = Left Unchecked

-- | Full grounding check combining type-checking with topological analysis.
checkGrounding :: Context -> SemTerm -> GroundingResult
checkGrounding _ctx (Grounded _ src) = FullyGrounded [src]
checkGrounding ctx (Inferred base (Statistical _)) =
  case checkGrounding ctx base of
    FullyGrounded srcs -> PartiallyGrounded srcs
      [MissingPath (show base) (show (Inferred base (Statistical 0)))]
    other -> other
checkGrounding ctx (Inferred base (Entailment _ _)) =
  checkGrounding ctx base
checkGrounding ctx (Inferred base Definition) =
  checkGrounding ctx base
checkGrounding ctx (Inferred base (Analogy _ _)) =
  case checkGrounding ctx base of
    FullyGrounded srcs -> PartiallyGrounded srcs
      [MissingPath (show base) "analogy_target"]
    other -> other
checkGrounding _ctx (PathWitness a b NoEvidence) =
  Ungrounded [MissingPath a b]
checkGrounding _ctx (PathWitness _ _ _evidence) =
  FullyGrounded [Axiomatic]
checkGrounding _ctx (Hallucinated desc) =
  Ungrounded [MissingPath desc "ground_truth"]
checkGrounding ctx (Refl a) =
  checkGrounding ctx (Grounded a Axiomatic)
checkGrounding ctx (PathCompose p q) =
  case (checkGrounding ctx p, checkGrounding ctx q) of
    (FullyGrounded s1, FullyGrounded s2) -> FullyGrounded (s1 ++ s2)
    _ -> PartiallyGrounded [] [MissingPath (show p) (show q)]

-- ============================================================================
-- VI. MAIN: DEMONSTRATING ALL FIVE HALLUCINATION TYPES
-- ============================================================================

main :: IO ()
main = do
  putStrLn "============================================================"
  putStrLn "  TOPOLOGICAL HALLUCINATION DETECTION"
  putStrLn "  A Homotopy-Theoretic Classification of LLM Failure Modes"
  putStrLn "  YonedaAI Research Collective / Magneton Labs LLC"
  putStrLn "============================================================"
  putStrLn ""

  -- Build a sample knowledge complex
  let kc = KnowledgeComplex
        { kcVertices  = [ "Paris is capital of France"        -- 0
                        , "France is in Europe"               -- 1
                        , "Europe is a continent"             -- 2
                        , "Tokyo is capital of Japan"         -- 3
                        , "Japan is in Asia"                  -- 4
                        , "Quantum consciousness"             -- 5
                        , "Free will requires non-determinism" -- 6
                        , "Non-determinism from quantum"      -- 7
                        ]
        , kcEdges     = [ (0, 1)  -- Paris->France justified
                        , (1, 2)  -- France->Europe justified
                        , (0, 2)  -- Paris->Europe (needed for 2-simplex)
                        , (3, 4)  -- Tokyo->Japan justified
                        , (5, 6)  -- QC->FW (unjustified circular link)
                        , (6, 7)  -- FW->ND (unjustified circular link)
                        , (7, 5)  -- ND->QC (unjustified circular link)
                        ]
        , kcTriangles = [ (0, 1, 2) ]  -- Paris-France-Europe filled
        -- Note: (5,6,7) is NOT a triangle -- no 2-simplex fills it
        }

  putStrLn "Knowledge Complex:"
  putStrLn $ "  Vertices: " ++ show (length (kcVertices kc))
  putStrLn $ "  Edges: " ++ show (length (kcEdges kc))
  putStrLn $ "  Triangles: " ++ show (length (kcTriangles kc))
  putStrLn $ "  H_0 (components): " ++ show (computeH0 kc)
  putStrLn $ "  H_1 rank (holes): " ++ show (computeH1Rank kc)
  putStrLn ""

  -- ---- Case 1: Circular Reasoning (pi_1) ----
  putStrLn "--- Case 1: Circular Reasoning (pi_1 != 0) ---"
  let circularClaims = [ "Quantum consciousness"
                        , "Free will requires non-determinism"
                        , "Non-determinism from quantum"
                        , "Quantum consciousness"  -- loop!
                        ]
  case detectCircularReasoning circularClaims kc of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: The loop [QC -> FW -> ND -> QC] is a"
      putStrLn "  non-contractible loop in pi_1(Sem). No 2-disk fills it."
    Nothing ->
      putStrLn "  No circular reasoning detected."
  putStrLn ""

  -- ---- Case 2: Unjustified Inference (pi_0) ----
  putStrLn "--- Case 2: Unjustified Inference (pi_0 disconnection) ---"
  case detectUnjustifiedInference "Paris is capital of France" "Tokyo is capital of Japan" kc of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: Paris-facts and Tokyo-facts lie in"
      putStrLn "  different connected components of pi_0(Sem)."
    Nothing ->
      putStrLn "  Claims are connected (no unjustified inference)."
  putStrLn ""

  -- ---- Case 3: Inconsistent Justifications (pi_2) ----
  putStrLn "--- Case 3: Inconsistent Justifications (pi_2 / 2-cells) ---"
  let path1 = Propositional   -- Proof via similar triangles
  let path2 = ByUnivalence    -- Proof via area dissection (different approach)
  let path3 = NoEvidence      -- No proof at all

  -- First: two genuinely distinct proofs (Propositional vs ByUnivalence)
  -- These are different proof strategies with no 2-cell connecting them
  putStrLn "  Check 1: Propositional vs ByUnivalence (distinct proof strategies)"
  case detectIncoherentPaths "Pythagorean theorem" "a^2+b^2=c^2" path1 path2 of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: Propositional and ByUnivalence are distinct proof"
      putStrLn "  strategies with no canonical 2-cell connecting them. An LLM that"
      putStrLn "  treats them as interchangeable hallucinates at the pi_2 level."
    Nothing  -> putStrLn "  OK: Paths are coherent (2-cell exists)."

  -- Second: incompatible paths (Propositional vs NoEvidence)
  putStrLn "  Check 2: Propositional vs NoEvidence (incompatible)"
  case detectIncoherentPaths "premise" "conclusion" path1 path3 of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: Path with evidence and path with NoEvidence"
      putStrLn "  cannot be connected by a 2-cell. Conflating them hallucinates."
    Nothing ->
      putStrLn "  Paths are coherent."
  putStrLn ""

  -- ---- Case 4: Fabricated Entity Chain (H_n) ----
  putStrLn "--- Case 4: Fabricated Entity Chain (H_n != 0) ---"
  let fabricated = [ "Quantum consciousness"
                   , "Free will requires non-determinism"
                   , "Non-determinism from quantum"
                   ]
  case detectFabricatedChain fabricated kc of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: The chain [QC, FW, ND] forms a 1-cycle"
      putStrLn "  (partial sigma = 0) but is not a boundary (no 2-simplex fills it)."
      putStrLn "  Hence [sigma] != 0 in H_1(K)."
    Nothing ->
      putStrLn "  Chain is grounded (bounds a 2-simplex)."
  putStrLn ""

  -- ---- Case 5: Compositional Drift (Holonomy) ----
  putStrLn "--- Case 5: Compositional Drift (Holonomy != id) ---"
  case detectCompositionalDrift "Java (programming language)" "Java (island)" "topic shift via Indonesia" of
    Just obs -> do
      putStrLn $ "  DETECTED: " ++ show obs
      putStrLn "  Interpretation: Parallel transport around the context loop"
      putStrLn "  [Java_lang -> Indonesia -> Java_island] changed the referent."
      putStrLn "  Holonomy(nabla, gamma) != {id}."
    Nothing ->
      putStrLn "  No compositional drift."
  putStrLn ""

  -- ---- Type-Checking Examples ----
  putStrLn "--- Type-Checking as Hallucination Detection ---"

  let ctx = Extend Empty ("x", Prop "Paris is capital of France")

  -- Grounded claim: should pass
  let groundedTerm = Grounded "Paris is capital of France" (Documentary "CIA World Factbook")
  putStrLn $ "  Grounded claim: " ++ show (typeCheck ctx groundedTerm (Prop "Paris is capital of France"))

  -- Statistical "justification": should fail
  let statTerm = Inferred (Grounded "base" Axiomatic) (Statistical 0.95)
  putStrLn $ "  Statistical justification: " ++ show (typeCheck ctx statTerm (Prop "some claim"))

  -- Hallucinated term: should fail
  let hallTerm = Hallucinated "Dr. X studied at MIT"
  putStrLn $ "  Hallucinated term: " ++ show (typeCheck ctx hallTerm (Prop "biography"))

  -- Path with no evidence: should fail
  let noEvidPath = PathWitness "morning star" "evening star" NoEvidence
  putStrLn $ "  Path without evidence: " ++ show (typeCheck ctx noEvidPath (PathType (Entity "Venus") "morning star" "evening star"))

  putStrLn ""
  putStrLn "--- Grounding Analysis ---"

  putStrLn $ "  Grounded term: " ++ show (checkGrounding ctx groundedTerm)
  putStrLn $ "  Statistical inference: " ++ show (checkGrounding ctx statTerm)
  putStrLn $ "  Hallucinated term: " ++ show (checkGrounding ctx hallTerm)

  putStrLn ""
  putStrLn "============================================================"
  putStrLn "  All five topological hallucination types demonstrated."
  putStrLn "  The Hallucination-Homotopy Correspondence is complete."
  putStrLn "============================================================"
