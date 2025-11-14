function min=seprotfun(N_0,theta)

[Sep1,Sep2]=SEP_N0_rot(N_0,theta);
min=max(Sep1,Sep2);

end