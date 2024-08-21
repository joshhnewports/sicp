Primitives are applied by the underlying Scheme. So map bypasses the metacircular apply's environment management with
the underlying Scheme's. Since map applies a procedure to a list it is important that there are changes to the
interpreted language's environment.
