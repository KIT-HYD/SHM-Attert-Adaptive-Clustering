function [r_teta] = f_r_teta(teta_act,teta_FC)
% returns a soilmoisture dependent reduction factor to correct Penman reference evapotranspiration ETo (short grass, unlimited soil water)
% Source: Dunger 2006 (Habiltationsschrift an der TU Freiberg von Volkmar Dunger), section 4.5.8.4
% for comparison see also 
% - FAO: http://www.fao.org/3/X0490E/x0490e0e.htm#chapter%208%20%20%20etc%20under%20soil%20water%20stress%20conditions
% - Koitzsch, R. (1977): Schätzung der Bodenfeuchte aus meteorologischen Daten, Boden- und Pflanzenparametern mit einem Mehrschichtenmodell. Zeitschrift für Meteorologie, Bd. 27, H. 5, S. 302 – 306.
% - Koitzsch, R., R. Helling und E. Vetterlein (1980): Simulation des Bodenfeuchteverlaufes unter Berücksichtigung der Wasserbewegung durch Pflanzen-bestände. Archiv Acker- und Pflanzenbau und Bodenkunde, Berlin 24, Heft 11, S. 717 – 725.
% Note: 
% - Compared to Dunger 2006, p. 160, eq. 75, the follwoing simplifying assumptions are made:
%   - a = 1 (full vegetation coverage) --> only the transpiration part remains, the evaporation part is neglected
%   - effect of vertial root distribution is neglected --> ft(z) is set to 1
% - we assume the shape of the soil-moisture dependend reduction to be like in figure 47, but with characteristic values not expressed
%   by soil moisture, but by filling level of a soil moisture reservoir:
%   - tetaWP --> 0 storage in the soil moisture reservoir
%   - tetaFC --> full storage in the soil moisture reservoir (Sumax)
%   - tetad = 0.8 * tetaFC = 0.8 * Sumax
% Input
% - teta_act: current filling level of the soil moisture reservoir [mm]
% - teta_FC: maximum filling level of the soil moisture reservoir [mm]
% Output
% - r_teta: soilmoisture dependent reduction factor [-]
% Version
% 2019/02/19: Uwe Ehret, initial version

teta_CRIT = 0.8 * teta_FC; % critial filling level. Above, water availability is no limitation

if teta_act < teta_CRIT
    r_teta = teta_act / teta_CRIT;
else
    r_teta = 1;
end

end

