I suppose that if, under the serialized balance procedure, there are serialized withdraws and deposits that
are waiting, then the balance would also have to wait for these other procedures to execute.
Under the non-serialized balance procedure, we would get the balance immediately. This disregards serialized
withdraws and deposits that should have happened earlier in time.
This depends on what exactly the authors mean by "ensure that no other procedure that assigns to the variable
can be run concurrently with this procedure".
