function converted_neuron = convertSpatialDimension(neuron)
number_of_cells = size(neuron.A , 2); 
[d1 d2]=size(neuron.Cn);
for n=1:number_of_cells
   converted_neuron(n,:,:) = reshape(neuron.A(:,n), d1 , d2);
end


