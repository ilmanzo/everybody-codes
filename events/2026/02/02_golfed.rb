p $<.sum{a=Hash.new([]);r='';d=->n{a[n].each(&d);r[n]||r<<n};it.split{|t|a[t[o=t[1].ord%4]]+=[t[2-o]]}.scan(/\d/,&d);r.to_i}
