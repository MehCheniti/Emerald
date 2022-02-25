const barrier <- monitor object barrierObject

  const maxProcesses : Integer <- 4
  var currentlyWaitingProcesses : Integer <- 0
  const c : Condition <- Condition.create

  export operation enter
    stdout.putstring["A process has started. \n"]

    if currentlyWaitingProcesses == maxProcesses - 1 then
      loop
        exit when currentlyWaitingProcesses == 0
        signal c
        currentlyWaitingProcesses <- currentlyWaitingProcesses - 1
      end loop
    else
      currentlyWaitingProcesses <- currentlyWaitingProcesses + 1
      stdout.putstring["There is/ are currently " || currentlyWaitingProcesses.asstring || " process(es) waiting. \n"]
      wait c
    end if

  end enter
end barrierObject

const main <- object main
    initially
      for i : Integer <- 1 while i < 5 by i <- i + 1
        const aProcess <- object aProcess
          const number <- i
          process
            barrier.enter
            stdout.putstring["Process number " || number.asstring || " has passed the barrier. \n"]
          end process
        end aProcess
      end for
    end initially
end main
