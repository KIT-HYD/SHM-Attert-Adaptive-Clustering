function [etp] = f_ETpo_Penman(T, dt, Rg, v2, RH)
% Potential Evapotranspiration from a reference surface (short grass) according to Penman (1956)
% Equations were taken from DVWK Merkblätter 238/1996 Ermittlung der Verdustung von Land und Wasserflächen, section 6.1.3
% Note
% - this is the maximum ET if water supply is not limiting
% - adjust for vegetation other than short grass and their seasonal changes 
%   by multiplication with crop coefficients kc (~ [0.5 - 1.5]
% Input
% - T: air temperature [°C]
% - dt: length of time period [s]
% - Rg: global radiation [W/m²] 
% - v2: wind velocity in 2m height [m/s]
% - RH: relative humidity [%], [0,100]

% Output
% - etp: potential evapotranspiration from a reference surface [mm/dt]
% Version
% - 2019/02/17 Uwe Ehret: initial version
% - 2020/02/28: Uwe Ehret, version published in GitHub

% saturation vapor pressure for given T (Magnus equation)
% - e_s [hPa]
% - T [°C]
e_s = 6.11 * exp( (17.62 * T) / (243.12 + T) );

% inclination of the saturation vapor pressure curve
% - s [hPa/K]
% - e_s [hPa]
% - T [°C]
s = e_s * (4284 /((243.12 + T)^2));

% specific latent heat of vaporization
% - Lstar [J / kg]
Lstar = 2088000;  % 2088 kJ/kg

% psychrometric constant
% - gamma [hPa/K]
gamma = 0.65;

% evaporation (eq. 6.15 in DVWK 238/1996)
% - etp [mm/dt]
etp = (s / (s + gamma) ) * (dt / Lstar) * (0.6 * Rg + 37.6 * (1 + 1.08 * v2) * (1 - (RH / 100) ) );



