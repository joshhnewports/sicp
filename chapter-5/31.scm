(f 'x 'y)
Evaluating f does not recurse into an evaluation causing env to change. The same for the evaluation of 'x and 'y not causing proc, env, and argl to change. All operations are superfluous.

((f) 'x 'y)
argl env are necessary

(f (g 'x) y)
proc argl env are necessary

(f (g 'x) 'y)
proc argl env are necessary
