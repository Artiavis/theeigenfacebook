function tightsubplot(dim, i, data)

row = mod(i-1, dim);
col = floor((i-1) / dim);    
subplot('position', [row*(1/dim), (dim-col-1)*(1/dim), 1/dim-.001, 1/dim-0.001 ]); 
imagesc(data);
axis off; 



