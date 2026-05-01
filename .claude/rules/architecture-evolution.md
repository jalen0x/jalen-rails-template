---
paths:
  - "docs/adr/**/*.md"
  - "config/routes.rb"
  - "app/services/**/*.rb"
  - "app/models/**/*.rb"
---

# Architecture Evolution

Architecture is never finished. Evaluate changes through opportunity cost now versus carrying cost forever.

## Monolith First

- Start with the Rails monolith unless current scale/team boundaries prove otherwise.
- Do not introduce microservices on day one.
- A slow test suite, naming pressure, or team-boundary conflict can signal rising monolith carrying cost; measure before reacting.

## Microservices Are Expensive

Microservices require service discovery, authentication, deployment independence, operational ownership, and distributed observability. Without clear boundaries they become a distributed monolith: more moving parts with no real independence.

## Shared Database as an Intermediate Pattern

For multiple Rails apps in one domain, a shared database can be a lower-cost transition than microservices:

- one Rails app owns migrations,
- shared Active Record models contain only database mapping/configuration,
- business logic stays out of shared models,
- database changes require cross-team review.

External calls must never happen inside DB transactions; with a shared database, lock amplification can break every app using it.

## Decision Records

Capture major architecture choices in ADRs when they change carrying cost or team workflow. Include:

- the problem,
- considered options,
- why the chosen option fits sustainability/consistency/quality,
- expected rollback or revisit signal.
