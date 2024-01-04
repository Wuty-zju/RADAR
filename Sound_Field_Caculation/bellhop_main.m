close all

bellhop .\env\bellhop_Ideal_range_depth
bellhop .\env\bellhop_Pekeris_range_depth


figure(1)
plotshd .\env\bellhop_Ideal_range_depth.shd
figure(2)
plotssp('.\env\bellhop_Ideal_range_depth.env')
figure(3)
plotshd .\env\bellhop_Pekeris_range_depth.shd
figure(4)
plotssp('.\env\bellhop_Pekeris_range_depth.env')