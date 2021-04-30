(define (domain robot-domain-ext)

    (:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions)
    (:types
        gripper drink waiter tray - object
        bar table - location
    )

    (:predicates
        (at-robby ?waiter - waiter ?table - location) ; where the waiter robot is at
        (conn ?from ?to - location) ; true, if two tables are connected 
        (carrying ?drink - drink)
        (drink-at ?drink - drink ?table - location)
        (drink-order ?table - table ?drink - drink)
        (need-clean ?table - table)
        (table-clean ?table - table)
        (tray-ready ?tray - tray)
        (preparing)
        (waiter-at-bar)
        (carrying-tray ?tray - tray)
        (gripper-free ?waiter - waiter)
        (loading-tray ?tray - tray)
        (tray-at-bar ?tray - tray)
        (table-waiter ?waiter - waiter ?table - table)
        (waiter-tray ?waiter - waiter ?tray - tray)
        (to-bar ?bar - location)

    )

    (:functions
        (conn-length ?from ?to - location)
        (on-tray ?tray)
        (drink-ready)
        (speed ?waiter)
        (cleaning-time ?table - table)
        (prep-time ?drink)
    )

    (:durative-action prepare-drink
        :parameters (?drink - drink ?table - table ?bar - bar)
        :duration (= ?duration (prep-time ?drink))
        :condition (and
            (at start (drink-order ?table ?drink))
            (at start (not (preparing)))
        )
        :effect (and
            (at start (preparing))
            (at end (not (preparing)))
            (at end (drink-at ?drink ?bar))
            (at end (increase (drink-ready) 1))
        )
    )

    (:action pick-up-drink
        :parameters (?waiter - waiter ?drink - drink ?table - table ?bar - bar ?tray - tray)
        :precondition (and (waiter-at-bar) (at-robby ?waiter ?bar) (drink-at ?drink ?bar)
            (gripper-free ?waiter) (> (drink-ready) 0) (< (drink-ready) 2) (not (loading-tray ?tray))
            (not (carrying ?drink)) (tray-at-bar ?tray) (< (on-tray ?tray) 1) (not (carrying-tray ?tray))
            (drink-order ?table ?drink) (table-waiter ?waiter ?table) (waiter-tray ?waiter ?tray)
        )
        :effect (and (not (drink-at ?drink ?bar)) (assign (speed ?waiter) 2) (not (gripper-free ?waiter))
            (carrying ?drink) (decrease (drink-ready) 1))
    )

    (:action load-tray
        :parameters (?waiter - waiter ?drink - drink ?table - table ?bar - bar ?tray - tray)
        :precondition (and (waiter-at-bar) (at-robby ?waiter ?bar) (drink-at ?drink ?bar) (gripper-free ?waiter)
            (> (drink-ready) 1) (drink-order ?table ?drink) (table-waiter ?waiter ?table) (waiter-tray ?waiter ?tray)
            (not (carrying ?drink)) (< (on-tray ?tray) 3) (tray-at-bar ?tray) (not (carrying-tray ?tray))
        )
        :effect (and (carrying ?drink) (not (drink-at ?drink ?bar)) (increase (on-tray ?tray) 1)
            (decrease (drink-ready) 1) (loading-tray ?tray) (gripper-free ?waiter)
        )
    )

    (:action load-last-drink
        :parameters (?waiter - waiter ?drink - drink ?table - table ?bar - bar ?tray - tray)
        :precondition (and (waiter-at-bar) (at-robby ?waiter ?bar) (drink-at ?drink ?bar)
            (gripper-free ?waiter) (> (drink-ready) 0) (loading-tray ?tray) (drink-order ?table ?drink)
            (table-waiter ?waiter ?table) (not (carrying ?drink)) (< (on-tray ?tray) 3)
            (tray-at-bar ?tray) (waiter-tray ?waiter ?tray) (not (carrying-tray ?tray))
        )
        :effect (and (carrying ?drink) (not (drink-at ?drink ?bar)) (increase (on-tray ?tray) 1)
            (decrease (drink-ready) 1) (not (loading-tray ?tray)) (gripper-free ?waiter) (tray-ready ?tray)
        )
    )

    (:action pick-up-tray
        :parameters (?waiter - waiter ?tray - tray ?bar - bar)
        :precondition (and (not (loading-tray ?tray)) (at-robby ?waiter ?bar) (tray-ready ?tray)
            (tray-at-bar ?tray) (gripper-free ?waiter) (waiter-at-bar) (waiter-tray ?waiter ?tray))
        :effect (and (carrying-tray ?tray) (assign (speed ?waiter) 1) (not (tray-at-bar ?tray))
            (not (loading-tray ?tray)) (not (gripper-free ?waiter)) (not (tray-ready ?tray)))
    )

    (:durative-action move
        :parameters (?waiter - waiter ?from ?to - location)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed ?waiter)))
        :condition (and
            (at start (at-robby ?waiter ?from))
            (at start (not (to-bar ?to)))
            (over all (conn ?from ?to))

        )
        :effect (and
            (at start (not (at-robby ?waiter ?from)))
            (at end (at-robby ?waiter ?to))
            (at end (not (at-robby ?waiter ?from)))
        )
    )

    (:durative-action move-to-bar
        :parameters (?waiter - waiter ?from - table ?to - bar)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed ?waiter)))
        :condition (and
            (at start (at-robby ?waiter ?from))
            (at start (not (waiter-at-bar)))
            (over all (conn ?from ?to))
        )
        :effect (and
            (at start (not (at-robby ?waiter ?from)))
            (at start (waiter-at-bar))
            (at end (at-robby ?waiter ?to))
            (at end (not (at-robby ?waiter ?from)))
        )
    )

    (:durative-action move-to-table
        :parameters (?waiter - waiter ?from - bar ?to - table)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed ?waiter)))
        :condition (and
            (at start (at-robby ?waiter ?from))
            (at start (waiter-at-bar))
            (over all (conn ?from ?to))
        )
        :effect (and
            (at start (not (at-robby ?waiter ?from)))
            (at start (not (waiter-at-bar)))
            (at end (at-robby ?waiter ?to))
            (at end (not (at-robby ?waiter ?from)))
        )
    )

    (:action drop-drink
        :parameters (?waiter - waiter ?drink - drink ?table - table ?tray - tray)
        :precondition (and (drink-order ?table ?drink) (at-robby ?waiter ?table)
            (carrying ?drink) (table-waiter ?waiter ?table) (not (carrying-tray ?tray))
            (not (gripper-free ?waiter)) (waiter-tray ?waiter ?tray)
        )
        :effect (and (drink-at ?drink ?table) (not (carrying ?drink))
            (gripper-free ?waiter)
        )
    )

    (:action drop-tray-drink
        :parameters (?waiter - waiter ?drink - drink ?table - table ?tray - tray)
        :precondition (and (carrying ?drink) (at-robby ?waiter ?table) (drink-order ?table ?drink)
            (not (tray-at-bar ?tray)) (table-waiter ?waiter ?table) (waiter-tray ?waiter ?tray)
            (carrying-tray ?tray) (> (on-tray ?tray) 0) (not (gripper-free ?waiter))
        )
        :effect (and (drink-at ?drink ?table) (not (carrying ?drink))
            (decrease (on-tray ?tray) 1) (not (gripper-free ?waiter)) (carrying-tray ?tray)
        )
    )

    (:action drop-tray
        :parameters (?waiter - waiter ?tray - tray ?bar - bar)
        :precondition (and (carrying-tray ?tray) (< (on-tray ?tray) 1) (waiter-tray ?waiter ?tray)
            (at-robby ?waiter ?bar) (not (gripper-free ?waiter)))
        :effect (and (not (carrying-tray ?tray)) (tray-at-bar ?tray) (assign (speed ?waiter) 2)
            (gripper-free ?waiter))
    )

    (:durative-action clean-table
        :parameters (?waiter - waiter ?table - table ?tray - tray)
        :duration (= ?duration (cleaning-time ?table))
        :condition (and
            (at start (at-robby ?waiter ?table))
            (at start (table-waiter ?waiter ?table))
            (at start (need-clean ?table))
            (at start (not (carrying-tray ?tray)))
            (at start (waiter-tray ?waiter ?tray))
            (at start (gripper-free ?waiter))
            (at start (not (tray-ready ?tray)))
            (at start (not (loading-tray ?tray)))
            (over all (at-robby ?waiter ?table))
        )
        :effect (and
            (at start (not (need-clean ?table)))
            (at end (not (need-clean ?table)))
            (at end (table-clean ?table))
        )
    )
)