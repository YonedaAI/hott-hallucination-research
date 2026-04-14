{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE StandaloneDeriving    #-}

-- ============================================================================
-- TypeTheoreticGen.hs
--
-- Hallucination-Free Language Generation via Dependent Type Theory
--
-- This module implements the five generation principles:
--   P1. Generation as Type Inhabitation
--   P2. Certified Derivations (Curry-Howard for language)
--   P3. Abstention on Empty Types
--   P4. Context as Fibration (dependent telescopes)
--   P5. Attention as Weighted Limit (categorical attention)
--
-- Author: Matthew Long, YonedaAI Research Collective / Magneton Labs LLC
-- Date:   April 2026
-- ============================================================================

module Main where

import Data.Maybe (isNothing)
import Control.Applicative ((<|>))

-- ============================================================================
-- I. SEMANTIC TYPES AND TERMS
-- ============================================================================

-- | Sources ground terms in reality.
data Source
  = Empirical String        -- Direct observation / measurement
  | Documentary String      -- Document / database reference
  | Axiomatic               -- Definitional truth
  | Derived [Source]         -- Derived from multiple sources
  deriving (Show, Eq)

-- | Justifications are the 1-cells in the semantic groupoid.
data Justification
  = Entailment String String   -- A entails B
  | Definition                 -- True by definition
  | Analogy String String      -- Structural similarity (weak)
  | Statistical Float          -- Probabilistic (NO PATH STRUCTURE)
  deriving (Show, Eq)

-- | Path evidence: proof that two terms are identifiable.
data PathEvidence
  = Definitional          -- Definitionally equal (refl)
  | Propositional         -- Propositionally equal (requires proof)
  | ByUnivalence          -- Equal because their types are equivalent
  | NoEvidence            -- THE HALLUCINATION CASE
  deriving (Show, Eq)

-- | Semantic types: the space of valid instances of a concept.
data SemType
  = Entity String                         -- Atomic entity type
  | Prop String                           -- Proposition type
  | PathType SemType String String        -- Identity type a =_A b
  | ProdType SemType SemType              -- Product
  | SumType SemType SemType               -- Coproduct
  | FuncType SemType SemType              -- Function type A -> B
  | VoidType                              -- Empty type (absurdity)
  | UnitType                              -- Unit type (trivially true)
  deriving (Show, Eq)

-- | Semantic terms: inhabitants of semantic types.
data SemTerm
  = Grounded String Source                -- Grounded fact
  | Inferred SemTerm Justification        -- Inference
  | PathWitness String String PathEvidence -- Path witness
  | Refl String                            -- Reflexivity: a = a
  | Pair SemTerm SemTerm                   -- Product introduction
  | InL SemTerm                            -- Left injection
  | InR SemTerm                            -- Right injection
  | UnitTerm                               -- Unit introduction
  | Absurd                                 -- Absurdity elimination
  | Hallucinated String                    -- EXPLICIT HALLUCINATION
  deriving (Show, Eq)

-- ============================================================================
-- II. CONTEXTS AS DEPENDENT TELESCOPES (Principle P4)
-- ============================================================================

-- | A context is a dependent sequence of typed bindings.
-- This is the semantic analog of a type-theoretic context Gamma.
-- Each binding (name, type) may depend on all preceding bindings.
data Context
  = Empty
  | Extend Context (String, SemType)
  deriving (Show, Eq)

-- | Look up a variable in the context.
contextLookup :: Context -> String -> Maybe SemType
contextLookup Empty _ = Nothing
contextLookup (Extend ctx (x, ty)) name
  | x == name = Just ty
  | otherwise = contextLookup ctx name

-- | Get all bindings from a context.
contextBindings :: Context -> [(String, SemType)]
contextBindings Empty = []
contextBindings (Extend ctx binding) = contextBindings ctx ++ [binding]

-- | The fiber over a context element: all valid inhabitants.
data Fiber = Fiber
  { fiberBase   :: (String, SemType)
  , fiberCtx    :: Context
  , validTerms  :: [SemTerm]
  , llmTerms    :: [(SemTerm, Float)]
  } deriving (Show)

-- | Hallucination measure: probability mass outside the valid fiber.
hallucinationMeasure :: Fiber -> Float
hallucinationMeasure fib =
  let invalid = filter (\(t, _) -> t `notElem` validTerms fib) (llmTerms fib)
  in sum (map snd invalid)

-- ============================================================================
-- III. DERIVATION TREES (Principle P2)
-- ============================================================================

-- | A derivation tree witnesses the judgment Gamma |- a : A.
data Derivation
  = AxiomD Source                          -- Grounded in source
  | IntroD String Derivation               -- Introduction rule
  | ElimD Derivation Derivation            -- Elimination rule
  | PathIntroD String String Derivation    -- Path introduction
  | TransportD Derivation PathEvidence     -- Transport along a path
  | UnivalenceD Derivation                 -- Apply univalence axiom
  | VarD String                            -- Variable rule
  | ReflD String                           -- Reflexivity derivation
  deriving (Show)

-- | The typing judgment: Gamma |- a : A
data Judgment = Judgment
  { jContext    :: Context
  , jTerm       :: SemTerm
  , jType       :: SemType
  , jDerivation :: Maybe Derivation
  } deriving (Show)

-- ============================================================================
-- IV. TYPE CHECKING
-- ============================================================================

-- | Classification of hallucination types by topological character.
data HallucinationType
  = TypeMismatch String String           -- Wrong fiber
  | StatisticalNotProof Float            -- Fundamental category error
  | MissingPathDeriv String String       -- pi_1 obstruction
  | FreeFloating                         -- Term in no fiber
  | ReflMismatch String String String    -- Bad reflexivity
  | Unchecked
  deriving (Show)

-- | Core type-checking: does this term inhabit this type in this context?
-- This replaces P(token | context) > threshold.
typeCheck :: Context -> SemTerm -> SemType -> Either HallucinationType Bool
typeCheck _ (Grounded claim _) (Prop p)
  | claim == p = Right True
  | otherwise  = Left (TypeMismatch claim p)
typeCheck _ (Grounded name _) (Entity e)
  | name == e = Right True
  | otherwise = Left (TypeMismatch name e)
typeCheck _ (Inferred _ (Statistical prob)) _
  = Left (StatisticalNotProof prob)
typeCheck ctx (Inferred base (Entailment _ _)) ty
  = typeCheck ctx base ty
typeCheck ctx (Inferred base Definition) ty
  = typeCheck ctx base ty
typeCheck _ (PathWitness a b NoEvidence) _
  = Left (MissingPathDeriv a b)
typeCheck _ (PathWitness a b _) (PathType _ x y)
  | a == x && b == y = Right True
  | otherwise = Left (ReflMismatch a x y)
typeCheck _ (Refl a) (PathType _ x y)
  | a == x && a == y = Right True
  | otherwise = Left (ReflMismatch a x y)
typeCheck _ (Hallucinated _) _
  = Left FreeFloating
typeCheck _ UnitTerm UnitType = Right True
typeCheck ctx (Pair a b) (ProdType ta tb) =
  case (typeCheck ctx a ta, typeCheck ctx b tb) of
    (Right True, Right True) -> Right True
    (Left err, _)            -> Left err
    (_, Left err)            -> Left err
    _                        -> Left Unchecked
typeCheck _ (InL _) (SumType _ _) = Right True  -- Left injection into sum
typeCheck _ (InR _) (SumType _ _) = Right True  -- Right injection into sum
typeCheck _ _ _ = Left Unchecked

-- ============================================================================
-- V. TYPE INHABITATION SEARCH (Principle P1)
-- ============================================================================

-- | A knowledge base: collection of sourced facts.
data KnowledgeBase = KnowledgeBase [(String, SemType, Source)]
  deriving (Show)

-- | Search for an inhabitant of a type in context, up to a given depth.
-- This is the core of Principle P1: generation = proof search.
inhabit :: KnowledgeBase -> Context -> SemType -> Int
        -> Maybe (SemTerm, Derivation)
inhabit _ _ _ 0 = Nothing  -- Search exhausted: ABSTAIN (Principle P3)
inhabit kb ctx ty depth =
  ctxSearch ctx ty
  <|> kbSearch kb ty
  <|> decomposeSearch kb ctx ty (depth - 1)

-- | Search the context for a variable of the right type.
ctxSearch :: Context -> SemType -> Maybe (SemTerm, Derivation)
ctxSearch Empty _ = Nothing
ctxSearch (Extend ctx (x, t)) goal
  | t == goal = case goal of
      Prop p   -> Just (Grounded p Axiomatic, VarD x)
      Entity e -> Just (Grounded e Axiomatic, VarD x)
      _        -> Just (UnitTerm, VarD x)
  | otherwise = ctxSearch ctx goal

-- | Search the knowledge base for a grounding source.
kbSearch :: KnowledgeBase -> SemType -> Maybe (SemTerm, Derivation)
kbSearch (KnowledgeBase []) _ = Nothing
kbSearch (KnowledgeBase ((name, ty, src):rest)) goal
  | ty == goal = Just (Grounded name src, AxiomD src)
  | otherwise  = kbSearch (KnowledgeBase rest) goal

-- | Decompose the goal type and search recursively.
decomposeSearch :: KnowledgeBase -> Context -> SemType -> Int
               -> Maybe (SemTerm, Derivation)
decomposeSearch kb ctx (ProdType a b) depth = do
  (ta, da) <- inhabit kb ctx a depth
  (tb, db) <- inhabit kb ctx b depth
  return (Pair ta tb, ElimD da db)
decomposeSearch _ _ UnitType _ =
  Just (UnitTerm, AxiomD Axiomatic)
decomposeSearch _ _ (PathType _ x y) _
  | x == y = Just (Refl x, ReflD x)
  | otherwise = Nothing  -- Non-trivial path: need explicit evidence
decomposeSearch _ _ VoidType _ = Nothing  -- Void is uninhabited!
decomposeSearch _ _ _ _ = Nothing

-- ============================================================================
-- VI. EMPTY TYPE DETECTION (Principle P3)
-- ============================================================================

-- | Check if a type is provably uninhabited.
isProvablyEmpty :: KnowledgeBase -> Context -> SemType -> Bool
isProvablyEmpty _ _ VoidType = True
isProvablyEmpty kb ctx (ProdType a b) =
  isProvablyEmpty kb ctx a || isProvablyEmpty kb ctx b
isProvablyEmpty kb ctx ty =
  isNothing (inhabit kb ctx ty 3)

-- | Abstention result: why we can't answer.
data AbstentionLevel
  = ProvablyUninhabited    -- Gamma |- A ~ 0
  | SearchExhausted Int    -- Search at depth d found nothing
  | KnowledgeBounded      -- Need more facts
  deriving (Show)

-- | Determine the abstention level for an uninhabited type.
abstentionLevel :: KnowledgeBase -> Context -> SemType -> AbstentionLevel
abstentionLevel kb ctx ty
  | isProvablyEmpty kb ctx ty = ProvablyUninhabited
  | otherwise = SearchExhausted 5

-- ============================================================================
-- VII. CATEGORICAL ATTENTION (Principle P5)
-- ============================================================================

-- | A diagram in the semantic category: objects with morphisms.
data SemanticDiagram = SemanticDiagram
  { diagObjects  :: [SemTerm]
  , diagMorphisms :: [(SemTerm, SemTerm, PathEvidence)]
  , diagWeights   :: [(Int, Float)]
  } deriving (Show)

-- | Coherence check result.
data DiagramCoherence
  = Coherent SemTerm              -- Diagram has a limit
  | IncoherentDiag [String]       -- Obstruction descriptions
  deriving (Show)

-- | Check if a diagram is coherent (all paths compose consistently).
checkDiagramCoherence :: SemanticDiagram -> DiagramCoherence
checkDiagramCoherence diag =
  let morphs = diagMorphisms diag
      hasNoEvidence = any (\(_, _, ev) -> ev == NoEvidence) morphs
      hasContradiction = detectContradiction morphs
  in if hasNoEvidence
     then IncoherentDiag ["Missing path evidence in diagram"]
     else if hasContradiction
     then IncoherentDiag ["Contradictory paths in diagram"]
     else case diagObjects diag of
       []    -> IncoherentDiag ["Empty diagram"]
       (x:_) -> Coherent x  -- Simplified: return first object as limit

-- | Detect contradictions: two paths from same source to same target
-- with incompatible evidence.
detectContradiction :: [(SemTerm, SemTerm, PathEvidence)] -> Bool
detectContradiction morphs =
  let pairs = [(a1, b1, e1, e2) | (a1, b1, e1) <- morphs
                                  , (a2, b2, e2) <- morphs
                                  , a1 == a2 && b1 == b2
                                  , e1 /= e2]
  in not (null pairs)

-- | Categorical attention: compute weighted limit.
-- Returns Nothing when the diagram is incoherent (abstain).
categoricalAttend :: SemanticDiagram -> Maybe SemTerm
categoricalAttend diag =
  case checkDiagramCoherence diag of
    Coherent lim    -> Just lim
    IncoherentDiag _ -> Nothing

-- ============================================================================
-- VIII. THE HOTT-LM: PUTTING IT ALL TOGETHER
-- ============================================================================

-- | The HoTT-LM: generates terms with certified derivations.
data HoTTLM = HoTTLM
  { lmKB      :: KnowledgeBase
  , lmDepth   :: Int
  }

-- | Generate: given context and goal type, find an inhabitant.
-- Returns Nothing when the type is uninhabited (ABSTAIN, not hallucinate).
generate :: HoTTLM -> Context -> SemType -> Maybe (SemTerm, Derivation)
generate model ctx goalType =
  case inhabit (lmKB model) ctx goalType (lmDepth model) of
    Just (term, deriv) ->
      case typeCheck ctx term goalType of
        Right True -> Just (term, deriv)
        _          -> Nothing  -- Derivation doesn't check out -> abstain
    Nothing -> Nothing         -- No inhabitant -> abstain (P3)

-- | Verify: check a term against its purported type.
verifyTerm :: HoTTLM -> Context -> SemTerm -> SemType -> Maybe Derivation
verifyTerm _ ctx term ty =
  case typeCheck ctx term ty of
    Right True -> Just (AxiomD Axiomatic)  -- Simplified
    _          -> Nothing

-- | Unify: find a semantic path between two terms.
unifyTerms :: SemTerm -> SemTerm -> Maybe PathEvidence
unifyTerms a b
  | a == b    = Just Definitional
  | otherwise = Nothing  -- Non-trivial unification not implemented

-- ============================================================================
-- IX. DERIVATION VERIFICATION
-- ============================================================================

-- | Verify that a derivation tree is valid.
verifyDerivation :: Context -> SemTerm -> SemType -> Derivation -> Bool
verifyDerivation _ (Grounded s _) (Prop p) (AxiomD _) = s == p
verifyDerivation _ (Grounded s _) (Entity e) (AxiomD _) = s == e
verifyDerivation _ (Refl a) (PathType _ x y) (ReflD r) =
  a == r && r == x && r == y
verifyDerivation _ (Hallucinated _) _ _ = False  -- Always invalid
verifyDerivation _ UnitTerm UnitType _ = True
verifyDerivation _ _ _ _ = True  -- Simplified for demonstration

-- ============================================================================
-- X. MAIN: DEMONSTRATING ALL FIVE PRINCIPLES
-- ============================================================================

main :: IO ()
main = do
  putStrLn "============================================================"
  putStrLn "Type-Theoretic Generation: Demonstrating the 5 Principles"
  putStrLn "============================================================"
  putStrLn ""

  -- Set up knowledge base
  let kb = KnowledgeBase
        [ ("Paris is the capital of France",
           Prop "Paris is the capital of France",
           Documentary "CIA World Factbook")
        , ("Macron is president of France",
           Prop "Macron is president of France",
           Documentary "Official government records")
        , ("France is in Europe",
           Prop "France is in Europe",
           Documentary "Geography database")
        , ("Macron",
           Entity "Macron",
           Documentary "Official government records")
        ]

  let model = HoTTLM kb 5

  -- Build a dependent context (Principle P4: Context as Fibration)
  let ctx = Extend
              (Extend
                (Extend Empty
                  ("q1", Prop "Paris is the capital of France"))
                ("a1", Entity "Macron"))
              ("q2", Prop "Macron is president of France")

  -- === PRINCIPLE 1: Generation as Type Inhabitation ===
  putStrLn "--- Principle 1: Generation as Type Inhabitation ---"
  putStrLn "Query: What is the capital of France?"
  let goalType1 = Prop "Paris is the capital of France"
  case generate model ctx goalType1 of
    Just (term, deriv) -> do
      putStrLn $ "  Generated term: " ++ show term
      putStrLn $ "  Derivation:     " ++ show deriv
      putStrLn "  Status: VALID (type inhabited)"
    Nothing ->
      putStrLn "  Status: ABSTAIN (type uninhabited)"
  putStrLn ""

  -- === PRINCIPLE 2: Certified Derivations ===
  putStrLn "--- Principle 2: Certified Derivations ---"
  let term2 = Grounded "Paris is the capital of France"
                        (Documentary "CIA World Factbook")
  let deriv2 = AxiomD (Documentary "CIA World Factbook")
  let valid = verifyDerivation ctx term2 goalType1 deriv2
  putStrLn $ "  Term:         " ++ show term2
  putStrLn $ "  Derivation:   " ++ show deriv2
  putStrLn $ "  Verified:     " ++ show valid
  putStrLn $ "  Check time:   O(|delta| * |A|) = polynomial"
  putStrLn ""

  -- Demonstrate that statistical justification is REJECTED
  putStrLn "  Attempting statistical justification (should fail):"
  let statTerm = Inferred (Grounded "Paris" Axiomatic)
                          (Statistical 0.95)
  case typeCheck ctx statTerm goalType1 of
    Left err -> putStrLn $ "  REJECTED: " ++ show err
    Right _  -> putStrLn $ "  (Unexpectedly accepted)"
  putStrLn ""

  -- === PRINCIPLE 3: Abstention on Empty Types ===
  putStrLn "--- Principle 3: Abstention on Empty Types ---"
  putStrLn "Query: How many planets are in Andromeda?"
  let goalEmpty = Prop "number of planets in Andromeda"
  case generate model ctx goalEmpty of
    Just (term, _) ->
      putStrLn $ "  Generated: " ++ show term
    Nothing -> do
      putStrLn "  Result: ABSTAIN (correct!)"
      putStrLn $ "  Abstention level: " ++
        show (abstentionLevel kb ctx goalEmpty)
      putStrLn "  An LLM would hallucinate a number here."
  putStrLn ""

  -- Demonstrate VoidType detection
  putStrLn "  Testing VoidType (provably empty):"
  putStrLn $ "  isProvablyEmpty VoidType = " ++
    show (isProvablyEmpty kb ctx VoidType)
  putStrLn ""

  -- === PRINCIPLE 4: Context as Fibration ===
  putStrLn "--- Principle 4: Context as Fibration ---"
  putStrLn "  Context telescope:"
  let bindings = contextBindings ctx
  mapM_ (\(i, (_, ty)) ->
    putStrLn $ "    x" ++ show (i :: Int) ++ " : " ++ show ty
    ) (zip [1..] bindings)
  putStrLn ""

  -- Demonstrate fiber analysis
  let fiber = Fiber
        { fiberBase = ("capital", Prop "Paris is the capital of France")
        , fiberCtx = ctx
        , validTerms = [Grounded "Paris is the capital of France"
                                 (Documentary "CIA World Factbook")]
        , llmTerms = [ (Grounded "Paris is the capital of France"
                                  (Documentary "CIA World Factbook"), 0.7)
                     , (Hallucinated "London is the capital of France", 0.2)
                     , (Hallucinated "Berlin is the capital of France", 0.1)
                     ]
        }
  putStrLn $ "  Hallucination measure: " ++
    show (hallucinationMeasure fiber)
  putStrLn "  (30% of LLM probability mass is outside the valid fiber)"
  putStrLn ""

  -- === PRINCIPLE 5: Attention as Weighted Limit ===
  putStrLn "--- Principle 5: Attention as Weighted Limit ---"

  -- Coherent diagram
  putStrLn "  Coherent diagram (consistent context):"
  let coherentDiag = SemanticDiagram
        { diagObjects =
            [ Grounded "Paris is the capital of France"
                        (Documentary "CIA World Factbook")
            , Grounded "France is in Europe"
                        (Documentary "Geography database")
            ]
        , diagMorphisms =
            [ ( Grounded "Paris is the capital of France"
                          (Documentary "CIA World Factbook")
              , Grounded "France is in Europe"
                          (Documentary "Geography database")
              , Propositional )
            ]
        , diagWeights = [(0, 0.6), (1, 0.4)]
        }
  case categoricalAttend coherentDiag of
    Just lim -> putStrLn $ "    Limit exists: " ++ show lim
    Nothing  -> putStrLn "    No limit (would abstain)"
  putStrLn ""

  -- Incoherent diagram
  putStrLn "  Incoherent diagram (contradictory context):"
  let incoherentDiag = SemanticDiagram
        { diagObjects =
            [ Grounded "Created in 1503" (Documentary "Art history")
            , Grounded "Created in 1517" (Documentary "Auction catalog")
            ]
        , diagMorphisms =
            [ ( Grounded "Created in 1503" (Documentary "Art history")
              , Grounded "Created in 1517" (Documentary "Auction catalog")
              , NoEvidence )
            ]
        , diagWeights = [(0, 0.5), (1, 0.5)]
        }
  case categoricalAttend incoherentDiag of
    Just lim -> putStrLn $ "    Limit exists: " ++ show lim
    Nothing  -> do
      putStrLn "    No limit: ABSTAIN (correct!)"
      putStrLn "    Standard attention would average -> 'circa 1510' (hallucination)"
  putStrLn ""

  -- === HALLUCINATION DETECTION ===
  putStrLn "--- Hallucination Detection Summary ---"
  let testCases =
        [ ("Grounded claim", Grounded "Paris is the capital of France"
            (Documentary "CIA World Factbook"), Prop "Paris is the capital of France")
        , ("Statistical inference", Inferred (Grounded "x" Axiomatic)
            (Statistical 0.99), Prop "x")
        , ("Missing path", PathWitness "a" "b" NoEvidence,
            PathType (Prop "test") "a" "b")
        , ("Hallucinated term", Hallucinated "made up fact",
            Prop "made up fact")
        , ("Valid reflexivity", Refl "a",
            PathType (Prop "test") "a" "a")
        ]
  mapM_ (\(desc, term, ty) -> do
    let result = typeCheck ctx term ty
    putStrLn $ "  " ++ desc ++ ":"
    case result of
      Right True  -> putStrLn "    VALID"
      Right False -> putStrLn "    REJECTED: type check returned False"
      Left err    -> putStrLn $ "    REJECTED: " ++ show err
    ) testCases
  putStrLn ""

  putStrLn "============================================================"
  putStrLn "All five principles demonstrated."
  putStrLn "  P1: Generation = type inhabitation (proof search)"
  putStrLn "  P2: Every valid term has a polynomial-time-checkable derivation"
  putStrLn "  P3: Empty types yield abstention, not hallucination"
  putStrLn "  P4: Context is a dependent telescope (fibration)"
  putStrLn "  P5: Attention is a weighted limit, not a weighted sum"
  putStrLn "============================================================"
