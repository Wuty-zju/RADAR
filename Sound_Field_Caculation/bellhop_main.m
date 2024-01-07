close all

bellhop .\conf\bellhop_Ideal_range_depth
bellhop .\conf\bellhop_Pekeris_range_depth


figure(1)
plotshd .\conf\bellhop_Ideal_range_depth.shd
figure(2)
plotssp('.\conf\bellhop_Ideal_range_depth.env')
figure(3)
plotshd .\conf\bellhop_Pekeris_range_depth.shd
figure(4)
plotssp('.\conf\bellhop_Pekeris_range_depth.env')