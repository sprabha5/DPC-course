%----------- FORWARD CONVERTER --------------------

%--- Specifications-----
Vi = 100 ;   %V Vin
Vi_min=80;
Vo = 45 ;     %V Vout
Po = 100 ;    %W Pout
e = 0.95 ;   %(95%) efficiency
Fsw = 50 * 10^3 ;    %kHz
%dVo < 1% Vo
VR = 0.01; %voltge rgulation
delta_Vo = Vo/100;
Io = Po/ Vo ;
D = 0.45 ;      %duty cycle
Dmax = 0.5;
Vd = 1.5 ;   % V it is drop across D1 & D2, generally 1.5 for fast recovery diodes

I_ripple = 0.05*Io;  %in % 5% of output voltage
delta_IL = I_ripple*Io;
Lp= ((Vi-Vo)*D)/(delta_IL*Fsw);
Ls = Lp;
Ld = 0.2 * Lp; % Let Ld to be around 10% to 30% of Lp

%------- Design ----
% Transformer calculation
Pin = Po/e;
PL = 0.1 * (Vo*Io);   %PL =PL_cu + PL_core 
Po = Vo*Io + Vd*Io + PL ;

% Area Product Calculation
kw = 0.4;
Bm = 0.2 ;
J = 3 * 10^6;    %A/m^2
% Ap = (Po * (1 + 1/e))/(sqrt(2)*kw*J*Bm*Fsw) ;
% Ap=13708mm^2          (Area product calculated)
% Ap = 18471*10^(-12);    Ap selected   EE 42/21/9
Ap = 46592*10^(-12);      %Ap selected EE 42/21/15 B66325G0000X127
lm = 97; %mm
Ae = 178; %mm^2     %Effective magnetic cross section
Aw = 256; %mm^2
ue = 1500;

%--------- No. of turns calculation ----------
Np=(Vi_min*Dmax) / (Ae*10^(-6)*Bm*Fsw);
Np=round(Np);
es= (Vo + Vd + 0.1*Vo)/D;
Ns = Np*((Vo+Vd*Dmax)/(Vi_min*Dmax));
% Ns=es/(2*Ae*10^(-6)*Bm*Fsw);
Ns=round(Ns);
Nd=Np ;  % demagnetizing winding = Np as they are wound bifilar
n=Ns/Np;

%-------- Wire Gauge Selection ----------------

ur = 1500; % ur = 2000 +- 25% worst case e Im is obtained at minimum value of relative permeability.
uo = 4*pi* (10^(-7));
% Lm = (uo*ur*Ae*10^(-6)*(Np*Np))/(lm*10^(-3));
Im = (Vi*D)/(Lm*Fsw); %magnetizing current
Ip_peak = Pin/Vi;
Is_peak= Po/Vo;
Ip_rms = ((1.2*Po)/(e*Vi*D))/(sqrt(2));
Is_rms= Io/(sqrt(2));
% Ip_rms= n * Is_rms;
Id_rms= Ip_rms/10;
AL = 3500*10^(-9);
Lm = (Np^2)*AL;
Dc = (Vo*n)/Vi;
Rmax = 70;
Lmin = (Rmax*(1-Dc))/(2*Fsw);
Cmin = (Vo*(1-Dc))/(8*Lmin*delta_Vo*Fsw*Fsw);

ap = Ip_rms/3; %SWG ap=0.65670
as = Is_rms/3; %SWG 21 as=0.51890
ad = Id_rms/3; %SWG 33 ad=0.050670 
% kw*Aw is in mm^2
% Np*ap + Ns*as + Nd*ad mm
if (kw*Aw > Np*ap + Ns*as + Nd*ad)
    disp(' windings will fit in the available window area');
else
    disp(' go to step 2 and do again')
end

%L = Vo/(delta_Vo/Io);
L= (Vo^2)/(2*Fsw*delta_Vo);
C = Io/(2*Fsw*delta_Vo);
Wn = 1/ sqrt(L*C); %natural_frequency
Dr = 0.707; %corresponds to a critically damped response, providing a good compromise between response speed and overshoot
R = 2*Dr*(sqrt(L/C));

