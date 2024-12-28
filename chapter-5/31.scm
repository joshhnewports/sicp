(save env)
f
(restore env)

(save proc)
(save env)
(save argl)
'x
(restore argl)
(restore env)
(save argl)
'y
(restore argl)
(restore proc)

Evaluating f does not recurse into an evaluation causing env to change. The same for the evaluation of 'x and 'y not causing proc, env, and argl to change. All operations are superfluous.
