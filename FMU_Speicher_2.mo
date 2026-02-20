model FMU_Speicher_2

// --- Parameter (konstante Werte zur Laufzeit) ---
  parameter Real P_max   = 1000; 
  parameter Real Efficiency = 0.8;
  parameter Real E_start = 200;
  parameter Real E_nom = 400;
  parameter Real SOC_min = 0;
  parameter Real SOC_max = 1;

  
  // --- Zustand der Batterie ---
  Real E(start = E_start, fixed = true);
  Real SOC;
  Real y_lim;


  Modelica.Blocks.Interfaces.RealInput u annotation(
    Placement(transformation(origin = {-69, -7}, extent = {{-13, -13}, {13, 13}}), iconTransformation(origin = {-86, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation(
    Placement(transformation(origin = {48, -8}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {66, 0}, extent = {{-10, -10}, {10, 10}})));
equation

  // --- Leistungsbegrenzung ---
  if abs(u) < P_max then
    y_lim = u;
  else
    y_lim = sign(u) * P_max;
  end if;

 
  // --- SOC_begrenzung ---
  if (SOC >= SOC_max and y_lim > 0) then
    y = 0;
  elseif (SOC <= SOC_min and y_lim < 0) then
    y = 0;
  else
    y = y_lim;
  end if;

  
  // --- Energiebilanz ---
  if y >= 0 then
    der(E) = Efficiency * y;         // Laden
  else
    der(E) = (1/Efficiency) * y;     // Entladen
  end if;
  
  
  // --- SOC-Berechnung ---
  SOC = E / E_nom;
  


annotation(
    uses(Modelica(version = "4.0.0")),
    Diagram(graphics = {Rectangle(origin = {-10, -10}, extent = {{-30, 30}, {30, -30}}), Line(origin = {-49, -8}, points = {{-9, 0}, {9, 0}, {9, 0}}), Line(origin = {28.4595, -7.7568}, points = {{-9, 0}, {9, 0}, {9, 0}}), Text(origin = {-15, -7}, extent = {{-11, 5}, {11, -5}}, textString = "Speicher")}));
end FMU_Speicher_2;
