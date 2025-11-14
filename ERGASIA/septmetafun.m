function min=septmetafun(N_0,a)

[Sep1,Sep2]=SEP_N0(N_0,a);
min=max(Sep1,Sep2);

end