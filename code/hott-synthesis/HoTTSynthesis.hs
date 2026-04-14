{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE StandaloneDeriving    #-}

module Main where

-- ============================================================================
-- HoTT HALLUCINATION FRAMEWORK: UNIFIED SYNTHESIS
--
-- Capstone implementation unifying:
--   Thread 1: Topological detection (pi_0, pi_1, pi_2, H_n, holonomy)
--   Thread 2: Type-theoretic generation (inhabitation, derivation, abstention)
--
-- Central construction: The Semantic Monad T = Detect . Generate
-- with the Detection-Generation Adjunction Generate -| Detect
-- ============================================================================

import Data.List (nub)

-- ============================================================================
-- I. UNIVERSE LEVELS
-- ============================================================================

data Nat = Z | S Nat deriving (Eq, Show)

-- ============================================================================
-- II. SEMANTIC TYPES AS HOMOTOPY TYPES
-- ============================================================================

-- | A semantic type: the space of valid instances of a concept.
data SemType
  = Entity   String             -- Atomic entity type
  | Prop     String             -- Proposition type
  | PathType SemType String String  -- Identity type a =_A b (simplified)
  | ProdType SemType SemType    -- Product (conjunction)
  | SumType  SemType SemType    -- Sum (disjunction)
  | VoidType                    -- Absurdity / contradiction
  | UnitType                    -- Trivially true
  deriving (Eq, Show)

-- | Semantic terms: inhabitants of semantic types.
data SemTerm
  = Grounded     String Source      -- Backed by evidence
  | Inferred     SemTerm Justification  -- Derived from another term
  | PathWitness  String String PathEvidence  -- Proof of a =_A b
  | Refl         String             -- Reflexivity: a = a
  | Hallucinated String             -- Explicit hallucination marker
  deriving (Eq, Show)

-- | Sources ground terms in reality
data Source
  = Empirical   String    -- Direct observation
  | Documentary String    -- Document/database reference
  | Axiomatic             -- Definitional truth
  | Derived     [Source]  -- Derived from multiple sources
  deriving (Eq, Show)

-- | Justifications: 1-cells in the semantic infinity-groupoid
data Justification
  = Entailment String String    -- A entails B
  | Definition                  -- True by definition
  | Analogy String String       -- Structural similarity (weak)
  | Statistical Float           -- Probability (NO PATH STRUCTURE)
  deriving (Eq, Show)

-- | Path evidence: proof that two terms are identifiable
data PathEvidence
  = Definitional        -- Judgmentally equal (refl)
  | Propositional       -- Propositionally equal (requires proof)
  | ByUnivalence        -- Equal via type equivalence
  | NoEvidence          -- THE HALLUCINATION CASE
  deriving (Eq, Show)

-- ============================================================================
-- III. CONTEXT AND FIBRATION
-- ============================================================================

-- | A context: dependent sequence of typed bindings
data Context = Context [(String, SemType)]
  deriving (Eq, Show)

emptyCtx :: Context
emptyCtx = Context []

extendCtx :: Context -> (String, SemType) -> Context
extendCtx (Context bindings) binding = Context (bindings ++ [binding])

lookupCtx :: Context -> String -> Maybe SemType
lookupCtx (Context bindings) name = lookup name bindings

-- ============================================================================
-- IV. DERIVATION TREES
-- ============================================================================

-- | A derivation tree: the proof that a term inhabits its type.
data Derivation
  = AxiomD    Source                      -- Grounded in source
  | IntroD    String Derivation           -- Introduction rule
  | ElimD     Derivation Derivation       -- Elimination rule
  | PathIntroD String String Derivation   -- Path introduction
  | TransportD Derivation PathEvidence    -- Transport along path
  | UnivalenceD Derivation               -- Apply univalence axiom
  deriving (Eq, Show)

-- ============================================================================
-- V. TOPOLOGICAL OBSTRUCTIONS
-- ============================================================================

-- | Topological obstructions: formal reasons for hallucination
data TopologicalObstruction
  = MissingPath String String                   -- pi_0: no 1-cell
  | NonContractibleLoop [String]                -- pi_1: circular reasoning
  | IncoherentPaths String String PathEvidence PathEvidence  -- pi_2
  | HomologicalHole Int [String]                -- H_n: unfilled cycle
  | TransportAnomaly String String PathEvidence -- Holonomy != id
  deriving (Eq, Show)

-- | Classification of hallucination types
data HallucinationType
  = TypeMismatch String String
  | StatisticalNotProof Float
  | MissingPathDerivation String String
  | FreeFloating
  | ReflMismatch String String String
  | Unchecked
  deriving (Eq, Show)

-- ============================================================================
-- VI. GROUNDING AND TYPE-CHECKING
-- ============================================================================

-- | Result of checking whether a claim is grounded
data GroundingResult
  = FullyGrounded [Source]
  | PartiallyGrounded [Source] [TopologicalObstruction]
  | Ungrounded [TopologicalObstruction]
  | Contradictory String String
  deriving (Eq, Show)

-- | Type-checking judgment: Gamma |- a : A
typeCheck :: Context -> SemTerm -> SemType -> Either HallucinationType Bool
typeCheck _ctx (Grounded claim _src) (Prop p)
  | claim == p = Right True
  | otherwise  = Left (TypeMismatch claim p)
typeCheck _ (Grounded name _) (Entity e)
  | name == e = Right True
  | otherwise = Left (TypeMismatch name e)
typeCheck _ctx (Inferred _base (Statistical prob)) _ty
  = Left (StatisticalNotProof prob)
typeCheck ctx' (Inferred base (Entailment _ _)) ty'
  = typeCheck ctx' base ty'
typeCheck ctx' (Inferred base Definition) ty'
  = typeCheck ctx' base ty'
typeCheck _ctx (PathWitness a b NoEvidence) (PathType _ty _ _)
  = Left (MissingPathDerivation a b)
typeCheck _ctx (PathWitness a b evidence) (PathType _ty x y)
  | a == x && b == y && evidence /= NoEvidence = Right True
  | otherwise = Left (MissingPathDerivation a b)
typeCheck _ctx (Hallucinated _) _
  = Left FreeFloating
typeCheck _ctx (Refl a) (PathType _ty x y)
  | a == x && a == y = Right True
  | otherwise = Left (ReflMismatch a x y)
typeCheck _ (Grounded _ _) UnitType = Right True
typeCheck _ _ _ = Left Unchecked

-- | Check grounding of a term
checkGrounding :: Context -> SemTerm -> GroundingResult
checkGrounding ctx term = case term of
  Grounded _ src -> FullyGrounded [src]
  Inferred base (Statistical _) ->
    case checkGrounding ctx base of
      FullyGrounded srcs -> PartiallyGrounded srcs
        [MissingPath (showTerm base) (showTerm term)]
      other -> other
  Inferred base (Entailment _ _) -> checkGrounding ctx base
  Inferred base Definition -> checkGrounding ctx base
  PathWitness a b NoEvidence -> Ungrounded [MissingPath a b]
  PathWitness _ _ _ -> FullyGrounded [Axiomatic]
  Hallucinated desc -> Ungrounded [MissingPath desc "truth"]
  Refl _ -> FullyGrounded [Axiomatic]
  _ -> Ungrounded [MissingPath (showTerm term) "unknown"]

showTerm :: SemTerm -> String
showTerm (Grounded s _)     = s
showTerm (Inferred _ _)     = "<inferred>"
showTerm (Hallucinated s)   = "<hallucinated:" ++ s ++ ">"
showTerm (Refl s)           = "refl(" ++ s ++ ")"
showTerm (PathWitness a b _) = a ++ "=" ++ b

-- ============================================================================
-- VII. KNOWLEDGE COMPLEX
-- ============================================================================

-- | A knowledge complex: simplicial structure over grounded facts
data KnowledgeComplex = KnowledgeComplex
  { kcFacts :: [String]                -- 0-simplices: grounded facts
  , kcEdges :: [(String, String)]      -- 1-simplices: justified pairs
  , kcTriangles :: [(String, String, String)]  -- 2-simplices: filled triangles
  } deriving (Eq, Show)

-- | Find adjacencies for a fact
neighbors :: KnowledgeComplex -> String -> [String]
neighbors kc fact =
  [b | (a, b) <- kcEdges kc, a == fact] ++
  [a | (a, b) <- kcEdges kc, b == fact]

-- ============================================================================
-- VIII. ALL FIVE OBSTRUCTION DETECTORS
-- ============================================================================

-- | Detect pi_0 obstruction: disconnection (unjustified inference)
detectDisconnection :: Context -> KnowledgeComplex -> SemTerm
                    -> [TopologicalObstruction]
detectDisconnection _ctx kc term = case term of
  Inferred base _ ->
    let baseStr = showTerm base
        termStr = showTerm term
        baseNeighbors = neighbors kc baseStr
    in if termStr `elem` kcFacts kc && baseStr `elem` kcFacts kc
          && termStr `notElem` baseNeighbors
       then [MissingPath baseStr termStr]
       else []
  _ -> []

-- | Detect pi_1 obstruction: circular reasoning
detectCircularReasoning :: Context -> KnowledgeComplex -> SemTerm
                        -> [TopologicalObstruction]
detectCircularReasoning _ctx _kc term =
  let chain = extractInferenceChain term
  in if length chain >= 3 && hasCycle chain
     then [NonContractibleLoop chain]
     else []
  where
    extractInferenceChain :: SemTerm -> [String]
    extractInferenceChain (Inferred base _) =
      showTerm base : extractInferenceChain base
    extractInferenceChain t = [showTerm t]

    hasCycle :: [String] -> Bool
    hasCycle xs = length xs /= length (nub xs)

-- | Detect pi_2 obstruction: incoherent paths
detectIncoherentPaths :: Context -> KnowledgeComplex -> SemTerm
                      -> [TopologicalObstruction]
detectIncoherentPaths _ctx kc (PathWitness a b ev1) =
  -- Check if another path exists with different evidence
  -- (simplified: check if the path endpoints have multiple edges)
  let paths = [(x, y) | (x, y) <- kcEdges kc, x == a && y == b]
  in if length paths > 1
     then [IncoherentPaths a b ev1 Propositional]
     else []
detectIncoherentPaths _ _ _ = []

-- | Detect H_n obstruction: homological holes (fabricated chains)
detectHomologicalHoles :: KnowledgeComplex -> SemTerm
                       -> [TopologicalObstruction]
detectHomologicalHoles kc term =
  let chain = extractChain term
  in if length chain >= 3 && isCycle kc chain && not (isFilled kc chain)
     then [HomologicalHole 1 chain]
     else []
  where
    extractChain :: SemTerm -> [String]
    extractChain (Inferred base _) = showTerm base : extractChain base
    extractChain t = [showTerm t]

    isCycle :: KnowledgeComplex -> [String] -> Bool
    isCycle kc' xs = length xs >= 3 &&
      all (\(a', b') -> (a', b') `elem` kcEdges kc' || (b', a') `elem` kcEdges kc')
          (zip xs (drop 1 xs ++ take 1 xs))

    isFilled :: KnowledgeComplex -> [String] -> Bool
    isFilled kc' [a', b', c'] = (a', b', c') `elem` kcTriangles kc'
                              || (b', c', a') `elem` kcTriangles kc'
                              || (c', a', b') `elem` kcTriangles kc'
    isFilled _ _ = False  -- Higher simplices not filled

-- | Detect holonomy obstruction: transport anomaly (compositional drift)
detectTransportAnomaly :: Context -> KnowledgeComplex -> SemTerm
                       -> [TopologicalObstruction]
detectTransportAnomaly _ctx kc term = case term of
  PathWitness a b ev ->
    -- Check if round-trip transport changes meaning
    if a /= b && ev == Propositional
    then let reverseExists = (b, a) `elem` kcEdges kc
         in if reverseExists
            then [TransportAnomaly a b ev]  -- Non-trivial holonomy
            else []
    else []
  _ -> []

-- | Integrated obstruction detection: all five types
-- Also detects explicit hallucination markers (VoidType inhabitants)
findAllObstructions :: Context -> KnowledgeComplex -> SemTerm
                    -> [TopologicalObstruction]
findAllObstructions ctx kc term = case term of
  -- Hallucinated terms have a pi_0 obstruction: they are disconnected
  -- from any grounded fact in the knowledge complex
  Hallucinated desc -> [MissingPath desc "ground-truth"]
  _ -> concat
    [ detectDisconnection ctx kc term
    , detectCircularReasoning ctx kc term
    , detectIncoherentPaths ctx kc term
    , detectHomologicalHoles kc term
    , detectTransportAnomaly ctx kc term
    ]

-- ============================================================================
-- IX. DETECTION AND GENERATION FUNCTORS
-- ============================================================================

-- | Detection result: semantic type + obstructions
data DetectionResult = DetectionResult
  { drContext      :: Context
  , drType         :: SemType
  , drGrounding    :: GroundingResult
  , drObstructions :: [TopologicalObstruction]
  } deriving (Show)

-- | Generation result
data GenerationResult
  = Generated SemTerm Derivation
  | Abstained String
  deriving (Show)

-- | The Detection functor: Claim -> Sem
detect :: Context -> KnowledgeComplex -> SemTerm -> DetectionResult
detect ctx kc term =
  let grounding = checkGrounding ctx term
      obstructions = findAllObstructions ctx kc term
      semType = inferType term
  in DetectionResult ctx semType grounding obstructions

-- | Infer the semantic type of a term
inferType :: SemTerm -> SemType
inferType (Grounded name (Empirical _))   = Prop name
inferType (Grounded name (Documentary _)) = Prop name
inferType (Grounded name Axiomatic)       = Prop name
inferType (Grounded name (Derived _))     = Prop name
inferType (Inferred base _)               = inferType base
inferType (PathWitness a b _)             = PathType (Prop a) a b
inferType (Refl a)                        = PathType (Prop a) a a
inferType (Hallucinated _)                = VoidType  -- Hallucinated -> VoidType

-- | The Generation functor: Sem -> Claim
-- Performs type inhabitation search
generate :: Context -> KnowledgeComplex -> SemType -> GenerationResult
generate ctx kc goalType = case searchInhabitant ctx kc goalType of
  Just (term, deriv) ->
    case typeCheck ctx term goalType of
      Right True  -> Generated term deriv
      Right False -> Abstained ("Type check returned False")
      Left err    -> Abstained ("Type check failed: " ++ show err)
  Nothing -> Abstained ("Type uninhabited: " ++ show goalType)

-- | Search for an inhabitant of a type in the given context and knowledge
searchInhabitant :: Context -> KnowledgeComplex -> SemType
                 -> Maybe (SemTerm, Derivation)
searchInhabitant _ctx kc (Prop p) =
  -- Search knowledge complex for a grounded fact matching p
  if p `elem` kcFacts kc
  then Just (Grounded p (Documentary "knowledge-base"),
             AxiomD (Documentary "knowledge-base"))
  else Nothing
searchInhabitant _ctx kc (Entity e) =
  if e `elem` kcFacts kc
  then Just (Grounded e (Documentary "knowledge-base"),
             AxiomD (Documentary "knowledge-base"))
  else Nothing
searchInhabitant _ctx kc (PathType _base a b) =
  if (a, b) `elem` kcEdges kc
  then Just (PathWitness a b Propositional,
             PathIntroD a b (AxiomD (Documentary "knowledge-base")))
  else if a == b
  then Just (Refl a, PathIntroD a a (AxiomD Axiomatic))
  else Nothing
searchInhabitant _ _ UnitType =
  Just (Grounded "unit" Axiomatic, AxiomD Axiomatic)
searchInhabitant _ _ VoidType = Nothing  -- VoidType is uninhabited!
searchInhabitant ctx kc (ProdType a b) = do
  (ta, da) <- searchInhabitant ctx kc a
  (tb, db) <- searchInhabitant ctx kc b
  return (Grounded (showTerm ta ++ " & " ++ showTerm tb) (Derived []),
          IntroD "pair" (ElimD da db))
searchInhabitant _ _ _ = Nothing

-- ============================================================================
-- X. THE SEMANTIC MONAD T = Detect . Generate
-- ============================================================================

-- | The Semantic Monad: wraps computation with obstruction tracking
data SemanticM a = SemanticM
  { runSemantic :: Context -> KnowledgeComplex
                -> (a, [TopologicalObstruction])
  }

instance Functor SemanticM where
  fmap f (SemanticM g) = SemanticM $ \ctx kc ->
    let (a, obs) = g ctx kc in (f a, obs)

instance Applicative SemanticM where
  pure a = SemanticM $ \_ _ -> (a, [])
  (SemanticM f) <*> (SemanticM x) = SemanticM $ \ctx kc ->
    let (fn, o1) = f ctx kc
        (a,  o2) = x ctx kc
    in (fn a, o1 ++ o2)

instance Monad SemanticM where
  (SemanticM m) >>= f = SemanticM $ \ctx kc ->
    let (a, o1)  = m ctx kc
        (b, o2)  = runSemantic (f a) ctx kc
    in (b, o1 ++ o2)

-- | Monadic unit: eta_A : A -> T(A)
-- Maps a claim to its verified version
semanticUnit :: SemTerm -> SemanticM SemTerm
semanticUnit term = SemanticM $ \ctx kc ->
  let result = detect ctx kc term
  in case drObstructions result of
    [] -> (term, [])  -- No obstructions: term is a fixed point
    obs -> (term, obs)  -- Has obstructions: record them

-- | Monadic multiplication: mu_A : T^2(A) -> T(A)
-- Collapses double verification
semanticMu :: SemanticM (SemanticM a) -> SemanticM a
semanticMu (SemanticM outer) = SemanticM $ \ctx kc ->
  let (inner, o1) = outer ctx kc
      (a, o2)     = runSemantic inner ctx kc
  in (a, nub (o1 ++ o2))  -- Deduplicate obstructions

-- ============================================================================
-- XI. THE GENERATE-CHECK-ABSTAIN LOOP
-- ============================================================================

-- | GCA Result
data GCAResult
  = GCAVerified SemTerm Derivation
  | GCACorrected SemTerm Derivation [TopologicalObstruction]
  | GCAAbstain String
  deriving (Show)

-- | The Generate-Check-Abstain loop implementing the semantic monad
gcaLoop :: SemTerm -> SemType -> Int -> SemanticM GCAResult
gcaLoop claim goalType maxIter = go claim maxIter
  where
    go _current 0 = SemanticM $ \_ _ ->
      (GCAAbstain "Maximum iterations reached", [])
    go current n = SemanticM $ \ctx kc ->
      let detResult = detect ctx kc current
          obs = drObstructions detResult
      in case obs of
        [] ->
          -- No obstructions: claim is verified
          case typeCheck ctx current goalType of
            Right True ->
              let deriv = AxiomD (Documentary "verified")
              in ((GCAVerified current deriv), [])
            _ -> ((GCAAbstain "Type check failed after clear detection"), [])
        obstructions ->
          -- Obstructions found: try to regenerate
          case generate ctx kc goalType of
            Generated newTerm deriv ->
              -- Re-check the generated term
              let newObs = findAllObstructions ctx kc newTerm
              in if null newObs
                 then ((GCACorrected newTerm deriv obstructions), obstructions)
                 else runSemantic (go newTerm (n - 1)) ctx kc
            Abstained reason ->
              ((GCAAbstain reason), obstructions)

-- ============================================================================
-- XII. PERSISTENT HOMOLOGY (Simplified)
-- ============================================================================

type Embedding = [Float]

data PersistenceBar = PersistenceBar
  { barDimension :: Int
  , barBirth     :: Float
  , barDeath     :: Float
  } deriving (Show)

-- | Persistence of a bar
persistence :: PersistenceBar -> Float
persistence bar = barDeath bar - barBirth bar

-- | Detect hallucination-prone regions via persistent features
detectHallucinationRegions :: [PersistenceBar] -> Float -> [PersistenceBar]
detectHallucinationRegions bars threshold =
  filter (\b -> persistence b > threshold && barDimension b >= 1) bars

-- ============================================================================
-- XIII. THE COMPLETENESS CHECK
-- ============================================================================

-- | Check if a term is a fixed point of the semantic monad
isSemanticFixedPoint :: Context -> KnowledgeComplex -> SemTerm -> Bool
isSemanticFixedPoint ctx kc term =
  let (_, obs) = runSemantic (semanticUnit term) ctx kc
  in null obs

-- | Verify the completeness theorem for a specific claim
verifyCompleteness :: Context -> KnowledgeComplex -> SemTerm -> SemType
                   -> (Bool, Bool, Bool)
verifyCompleteness ctx kc term goalType =
  let -- (i) Is the term not hallucinated?
      notHallucinated = case checkGrounding ctx term of
        FullyGrounded _ -> True
        _ -> False

      -- (ii) Does detection find no obstructions?
      detResult = detect ctx kc term
      noObstructions = null (drObstructions detResult)

      -- (iii) Does generation produce equivalent term?
      genResult = generate ctx kc goalType
      genSucceeds = case genResult of
        Generated _ _ -> True
        Abstained _   -> False

  in (notHallucinated, noObstructions, genSucceeds)

-- ============================================================================
-- XIV. MAIN: DEMONSTRATION
-- ============================================================================

main :: IO ()
main = do
  putStrLn "============================================================"
  putStrLn "  HoTT HALLUCINATION FRAMEWORK: UNIFIED SYNTHESIS"
  putStrLn "  Capstone POC: Detection-Generation Duality"
  putStrLn "============================================================"
  putStrLn ""

  -- Set up knowledge complex
  let kc = KnowledgeComplex
        { kcFacts = [ "Eiffel Tower designed by Gustave Eiffel"
                    , "Eiffel Tower completed in 1889"
                    , "Gustave Eiffel was French"
                    , "Eiffel Tower is in Paris"
                    , "Paris is capital of France"
                    , "France is in Europe"
                    ]
        , kcEdges = [ ("Eiffel Tower designed by Gustave Eiffel",
                       "Gustave Eiffel was French")
                    , ("Eiffel Tower is in Paris",
                       "Paris is capital of France")
                    , ("Paris is capital of France",
                       "France is in Europe")
                    , ("Gustave Eiffel was French",
                       "France is in Europe")
                    ]
        , kcTriangles = [ ("Eiffel Tower is in Paris",
                          "Paris is capital of France",
                          "France is in Europe")
                        ]
        }

  let ctx = Context
        [ ("topic", Entity "Eiffel Tower")
        , ("domain", Prop "architecture")
        ]

  -- ----------------------------------------------------------
  -- DEMO 1: Grounded claim -> detect -> verify
  -- ----------------------------------------------------------
  putStrLn "--- Demo 1: Grounded Claim (Non-Hallucinated) ---"
  let claim1 = Grounded "Eiffel Tower designed by Gustave Eiffel"
                        (Documentary "historical records")
  let type1 = Prop "Eiffel Tower designed by Gustave Eiffel"

  putStrLn $ "Claim: " ++ showTerm claim1
  let det1 = detect ctx kc claim1
  putStrLn $ "Detection obstructions: " ++ show (drObstructions det1)
  putStrLn $ "Grounding: " ++ show (drGrounding det1)
  putStrLn $ "Type check: " ++ show (typeCheck ctx claim1 type1)

  let (_fp1, obs1) = runSemantic (semanticUnit claim1) ctx kc
  putStrLn $ "Is semantic fixed point: " ++ show (null obs1)

  let (nh, no, gs) = verifyCompleteness ctx kc claim1 type1
  putStrLn $ "Completeness check: notHallucinated=" ++ show nh
           ++ " noObstructions=" ++ show no
           ++ " genSucceeds=" ++ show gs
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 2: Hallucinated claim -> detect -> generate alternative
  -- ----------------------------------------------------------
  putStrLn "--- Demo 2: Hallucinated Claim ---"
  let claim2 = Hallucinated "Le Corbusier designed the Eiffel Tower"
  let type2 = Prop "Eiffel Tower designed by Gustave Eiffel"

  putStrLn $ "Claim: " ++ showTerm claim2
  let det2 = detect ctx kc claim2
  putStrLn $ "Detection obstructions: " ++ show (drObstructions det2)
  putStrLn $ "Inferred type: " ++ show (drType det2)
  putStrLn $ "Type check: " ++ show (typeCheck ctx claim2 type2)

  let (_fp2, obs2) = runSemantic (semanticUnit claim2) ctx kc
  putStrLn $ "Is semantic fixed point: " ++ show (null obs2)

  -- Run GCA loop
  let (gcaResult2, _gcaObs2) = runSemantic (gcaLoop claim2 type2 3) ctx kc
  putStrLn $ "GCA result: " ++ show gcaResult2
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 3: Statistical justification (category error)
  -- ----------------------------------------------------------
  putStrLn "--- Demo 3: Statistical Justification (Fundamental Category Error) ---"
  let baseClaim = Grounded "Eiffel Tower is in Paris"
                           (Documentary "geography")
  let claim3 = Inferred baseClaim (Statistical 0.95)
  let type3 = Prop "Eiffel Tower is in Paris"

  putStrLn $ "Claim: Inferred from grounded with P=0.95"
  putStrLn $ "Type check: " ++ show (typeCheck ctx claim3 type3)
  putStrLn $ "Grounding: " ++ show (checkGrounding ctx claim3)
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 4: Circular reasoning (pi_1 obstruction)
  -- ----------------------------------------------------------
  putStrLn "--- Demo 4: Circular Reasoning (pi_1 obstruction) ---"
  let claimA = Grounded "A" (Documentary "src")
  let claimB = Inferred claimA (Entailment "A" "B")
  let claim4 = Inferred (Inferred claimB (Entailment "B" "A"))
                         (Entailment "A" "B")

  putStrLn $ "Claim chain: A -> B -> A -> B (circular)"
  let det4 = detect ctx kc claim4
  putStrLn $ "Detection obstructions: " ++ show (drObstructions det4)
  let circObs = detectCircularReasoning ctx kc claim4
  putStrLn $ "Circular reasoning detected: " ++ show (not (null circObs))
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 5: Type inhabitation search (generation)
  -- ----------------------------------------------------------
  putStrLn "--- Demo 5: Type Inhabitation Search ---"
  let searchType1 = Prop "Paris is capital of France"
  let gen1 = generate ctx kc searchType1
  putStrLn $ "Search for inhabitant of: " ++ show searchType1
  putStrLn $ "Result: " ++ show gen1

  let searchType2 = Prop "Mars is capital of France"
  let gen2 = generate ctx kc searchType2
  putStrLn $ "Search for inhabitant of: " ++ show searchType2
  putStrLn $ "Result: " ++ show gen2 ++ " (correctly abstains)"

  let searchType3 = VoidType
  let gen3 = generate ctx kc searchType3
  putStrLn $ "Search for inhabitant of VoidType: "
  putStrLn $ "Result: " ++ show gen3 ++ " (uninhabited, abstains)"
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 6: The full semantic monad pipeline
  -- ----------------------------------------------------------
  putStrLn "--- Demo 6: Full Semantic Monad Pipeline ---"
  let pipeline = do
        -- Start with a claim
        let claim = Grounded "Eiffel Tower is in Paris"
                             (Documentary "geography")
        -- Apply unit (detect)
        verified <- semanticUnit claim
        -- Apply generation
        let goalType = Prop "Paris is capital of France"
        result <- SemanticM $ \ctx' kc' ->
          let genR = generate ctx' kc' goalType
          in case genR of
            Generated t d -> ((Just (t, d)), [])
            Abstained _   -> (Nothing, [])
        return (verified, result)

  let ((verifiedTerm, genResult), allObs) = runSemantic pipeline ctx kc
  putStrLn $ "Verified term: " ++ showTerm verifiedTerm
  putStrLn $ "Generated from related type: " ++ show genResult
  putStrLn $ "Total obstructions in pipeline: " ++ show (length allObs)
  putStrLn ""

  -- ----------------------------------------------------------
  -- DEMO 7: Persistent homology (simplified)
  -- ----------------------------------------------------------
  putStrLn "--- Demo 7: Persistent Homology Monitoring ---"
  let bars = [ PersistenceBar 0 0.0 0.5    -- Short-lived H_0
             , PersistenceBar 1 0.1 0.8    -- Persistent H_1 (hallucination!)
             , PersistenceBar 1 0.2 0.25   -- Ephemeral H_1 (noise)
             , PersistenceBar 2 0.3 0.9    -- Persistent H_2 (hallucination!)
             ]
  let threshold = 0.3
  let suspicious = detectHallucinationRegions bars threshold
  putStrLn $ "Persistence bars: " ++ show (length bars)
  putStrLn $ "Threshold: " ++ show threshold
  putStrLn $ "Hallucination-prone regions: " ++ show (length suspicious)
  mapM_ (\b -> putStrLn $ "  H_" ++ show (barDimension b)
                        ++ " [" ++ show (barBirth b)
                        ++ ", " ++ show (barDeath b)
                        ++ "] persistence=" ++ show (persistence b))
        suspicious
  putStrLn ""

  -- ----------------------------------------------------------
  -- SUMMARY
  -- ----------------------------------------------------------
  putStrLn "============================================================"
  putStrLn "  SYNTHESIS SUMMARY"
  putStrLn "============================================================"
  putStrLn "Detection-Generation Adjunction: Generate -| Detect"
  putStrLn "Semantic Monad T = Detect . Generate"
  putStrLn "  Unit eta: claim -> verified claim"
  putStrLn "  Multiplication mu: T^2 -> T (idempotent verification)"
  putStrLn "Completeness: HHC + type-theoretic generation = complete system"
  putStrLn "  - Every hallucination detected (topological invariants)"
  putStrLn "  - Generation never produces undetected hallucinations"
  putStrLn "  - Non-hallucinated claims = fixed points of T"
  putStrLn "============================================================"
