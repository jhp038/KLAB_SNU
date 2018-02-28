
number_of_cells = size(neuron.A , 2); 

for n=1:number_of_cells
   spatial_footprints(n,:,:) = reshape(neuron.A(:,n), d1 , d2);
end
