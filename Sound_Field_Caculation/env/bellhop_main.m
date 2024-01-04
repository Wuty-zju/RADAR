close all

bellhop bellhop_Ideal_range_depth
bellhop bellhop_Pekeris_range_depth


figure(1)
plotshd bellhop_Ideal_range_depth.shd
figure(2)
plotssp('bellhop_Ideal_range_depth.env')
figure(3)
plotshd bellhop_Pekeris_range_depth.shd
figure(4)
plotssp('bellhop_Pekeris_range_depth.env')