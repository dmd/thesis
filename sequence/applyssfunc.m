function d = applyssfunc(funcname,vec)

rez=1000;
if isa(funcname,'function_handle')
    funcname=func2str(funcname);
end

d = interp1(linspace(min(vec),max(vec),rez),smallscale(funcname),vec);

d=d.*range(vec);
d=d+min(vec);
