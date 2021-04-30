(define (problem problem01)
    (:domain robot-domain)
    (:objects
        table1 table2 table3 table4 - table
        bar - bar
        cold1 cold2 - drink 
    )

    (:init

        (at-robby bar)

        (conn bar table1)
        (conn table1 bar)
        (conn bar table2)
        (conn table2 bar)
        (conn table1 table2)
        (conn table2 table1)
        (conn table1 table3)
        (conn table3 table1)
        (conn table1 table4)
        (conn table4 table1)
        (conn table2 table4)
        (conn table4 table2)
        (conn table2 table3)
        (conn table3 table2)
        (conn table3 table4)
        (conn table4 table3)

        (gripper-free)

        (tray-at-bar)

        (drink-order table2 cold1)
        (drink-order table2 cold2)

        (need-clean table3)
        (need-clean table4)

        (= (conn-length bar table1) 2)
        (= (conn-length table1 bar) 2)
        (= (conn-length bar table2) 2)
        (= (conn-length table2 bar) 2)
        (= (conn-length table1 table2) 1)
        (= (conn-length table2 table1) 1)
        (= (conn-length table1 table3) 1)
        (= (conn-length table3 table1) 1)
        (= (conn-length table1 table4) 1)
        (= (conn-length table4 table1) 1)
        (= (conn-length table2 table4) 1)
        (= (conn-length table4 table2) 1)
        (= (conn-length table2 table3) 1)
        (= (conn-length table3 table2) 1)
        (= (conn-length table3 table4) 1)
        (= (conn-length table4 table3) 1)

        (= (on-tray) 0)
        (= (drink-ready) 0)
        (= (prep-time cold1) 3)
        (= (prep-time cold2) 5)
        (= (speed) 2)

        (= (cleaning-time table1) 2)
        (= (cleaning-time table2) 2)
        (= (cleaning-time table3) 4)
        (= (cleaning-time table4) 2)
    )

    (:goal
        (and
            (drink-at cold1 table2)
            (drink-at cold2 table2)

            (table-clean table3)
            (table-clean table4)
        )
    )

    (:metric minimize
        (total-time)
    )
)