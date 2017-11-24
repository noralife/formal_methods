--------------------------- MODULE SimpleProgram ---------------------------
VARIABLES
  serverState,
  clientState,
  serverData,
  clientCache

nocache == 0
data == {1,2,3}

TypeOK == /\ serverState \in {"idle", "serving"}
          /\ clientState \in {"idle", "waiting"}
          /\ serverData \in data
          /\ clientCache \in {nocache} \cup data

Init == /\ serverState = "idle"
        /\ clientState = "idle"
        /\ serverData \in data
        /\ clientCache = nocache
-----------------------------------------------------------------------------
UpdateData == /\ serverState = "idle"
              /\ serverData' \in data
              /\ UNCHANGED <<serverState, clientState, clientCache>>

Response == /\ serverState = "serving"
            /\ serverState' = "idle"
            /\ clientState' = "idle"
            /\ clientCache' = serverData
            /\ UNCHANGED <<serverData>>

Server == UpdateData \/ Response
-----------------------------------------------------------------------------
Request == /\ clientState = "idle"
           /\ clientState' = "waiting"
           /\ serverState' = "serving"
           /\ UNCHANGED <<serverData, clientCache>>

Client == Request
-----------------------------------------------------------------------------
Next == Server \/ Client
-----------------------------------------------------------------------------
EventualConsistency == <>(clientCache /= nocache => serverData = clientCache)
StrongConsistency == [](clientCache /= nocache => serverData = clientCache)
=============================================================================
\* Modification History
\* Last modified Fri Nov 24 00:55:03 EST 2017 by tnanjo
\* Created Thu Nov 23 21:29:30 EST 2017 by tnanjo
