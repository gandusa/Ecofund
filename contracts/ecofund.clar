;; ------------------------------------------------------
;; EcoFund - Milestone-Based Funding Vault
;; A contract for transparent project funding tied to milestones
;; Contributors donate, milestones unlock funds, refunds possible
;; ------------------------------------------------------

(define-trait sip-010-trait
  (
    ;; minimal trait requirement for token transfer
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (get-balance (principal) (response uint uint))
  )
)

;; ------------------------------
;; Data Structures
;; ------------------------------

(define-data-var project-owner principal tx-sender)   ;; Project creator
(define-data-var project-name (string-ascii 50) "EcoFund Demo Project")
(define-data-var total-raised uint u0)                ;; Total funds raised
(define-data-var funding-goal uint u1000000)          ;; Example goal: 1,000,000 microSTX
(define-data-var current-milestone uint u0)           ;; Milestone tracker
(define-data-var total-milestones uint u3)            ;; Number of milestones
(define-data-var active bool true)                    ;; Project active status

;; Mapping of contributor balances
(define-map contributions
  { contributor: principal }
  { amount: uint }
)

;; Mapping of milestone approvals
(define-map milestone-approvals
  { milestone-id: uint }
  { approved: bool }
)

;; ------------------------------
;; Public Functions
;; ------------------------------

;; Donate to the project
;; Added amount parameter and fixed transfer logic to send funds to contract
(define-public (donate (amount uint))
  (begin
    (asserts! (var-get active) (err u100)) ;; project must be active
    (asserts! (> amount u0) (err u107)) ;; amount must be positive
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (let ((existing-contribution (default-to u0 (get amount (map-get? contributions {contributor: tx-sender})))))
      (map-set contributions {contributor: tx-sender} {amount: (+ existing-contribution amount)})
      (var-set total-raised (+ (var-get total-raised) amount))
      (ok true)
    )
  )
)

;; Approve milestone (contributors can vote or owner auto-approves)
(define-public (approve-milestone (milestone-id uint))
  (begin
    (asserts! (<= milestone-id (var-get total-milestones)) (err u101))
    (map-set milestone-approvals {milestone-id: milestone-id} {approved: true})
    (var-set current-milestone milestone-id)
    (ok milestone-id)
  )
)

;; Withdraw funds (only project-owner, only for approved milestone)
;; Fixed transfer to withdraw from contract balance
(define-public (withdraw (amount uint))
  (begin
    (asserts! (is-eq tx-sender (var-get project-owner)) (err u102))
    (let ((milestone-record (map-get? milestone-approvals {milestone-id: (var-get current-milestone)})))
      (asserts! (is-some milestone-record) (err u108))
      (asserts! (get approved (unwrap-panic milestone-record)) (err u103))
      (as-contract (stx-transfer? amount tx-sender (var-get project-owner)))
    )
  )
)

;; Refund contributors if project inactive or failed
;; Fixed refund logic to transfer from contract to contributor
(define-public (refund)
  (let ((record (map-get? contributions {contributor: tx-sender})))
    (match record contrib
      (begin
        (asserts! (not (var-get active)) (err u104))
        (try! (as-contract (stx-transfer? (get amount contrib) tx-sender tx-sender)))
        (map-delete contributions {contributor: tx-sender})
        (ok true)
      )
      (err u105)
    )
  )
)

;; Close the project (by owner)
(define-public (close-project)
  (begin
    (asserts! (is-eq tx-sender (var-get project-owner)) (err u106))
    (var-set active false)
    (ok true)
  )
)
