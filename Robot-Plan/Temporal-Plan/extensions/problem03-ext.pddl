(define (problem problem03-ext)
    (:domain robot-domain-ext)
    (:objects
        table1 table2 table3 table4 - table
        siri alexa - waiter 
        bar - bar
        warm1 warm2 warm3 warm4 - drink
        tray1 tray2 - tray 

    )
    (:init
        (at-robby siri table1)
        (at-robby alexa table1)

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

        (gripper-free siri)
        (gripper-free alexa)

        (tray-at-bar tray1)
        (tray-at-bar tray2)

        (waiter-tray siri tray1)
        (waiter-tray alexa tray2) 

        (table-waiter siri table1)
        (table-waiter siri table2)
        (table-waiter alexa table3)
        (table-waiter alexa table4)

        (to-bar bar)

        (drink-order table1 warm1)
        (drink-order table1 warm2)
        (drink-order table4 warm3)
        (drink-order table4 warm4)

        (need-clean table3)

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

        (= (on-tray tray1) 0)
        (= (on-tray tray2) 0)

        (= (drink-ready) 0)

        (= (speed siri) 2)
        (= (speed alexa) 2)

        (= (prep-time warm1) 5)
        (= (prep-time warm2) 5)
        (= (prep-time warm3) 5)
        (= (prep-time warm4) 5)

        (= (cleaning-time table1) 2)
        (= (cleaning-time table2) 2)
        (= (cleaning-time table3) 4)
        (= (cleaning-time table4) 2)
    )

    (:goal
        (and
            (drink-at warm1 table1)
            (drink-at warm2 table1)
            (drink-at warm3 table4)
            (drink-at warm4 table4)

            (table-clean table3)
        )
    )

    (:metric minimize
        (total-time)
    )
)