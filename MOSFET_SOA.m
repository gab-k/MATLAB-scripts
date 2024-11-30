% Script to Calculate and plot Safe Operating Area (SOA) from:
% R_DS(on), I_DS(max), P(max), V_DS(max)

% Parameters
R_DS_on = 44/1000;    % On-resistance (Ohms)
I_DS_max = 33;      % Current limit (Amps)
P_limit = 30;     % Power limit (Watts)
V_DS_max = 100;    % Maximum drain-source voltage (Volts)

% Print parameters
fprintf('R_DS(on): %.4f Ohms\n', R_DS_on);
fprintf('Current Limit: %.2f Amps\n', I_DS_max);
fprintf('Power Limit: %.2f Watts\n', P_limit);
fprintf('V_DS(max): %.2f Volts\n\n', V_DS_max);

% Calculations
fprintf('Calculating Safe Operating Area (SOA)...\n');

% Ohmic region: I = V/R_DS_on (up to current limit or power limit)
V_ohmic = logspace(-1, log10(min(V_DS_max, sqrt(P_limit * R_DS_on))), 100); 
I_ohmic = V_ohmic / R_DS_on;

% Current limit region
V_current_limit = logspace(-1, log10(V_DS_max), 100);
I_current_limit = I_DS_max * ones(size(V_current_limit));

% Power limit region: P = V * I => I = P / V
V_power_limit = logspace(log10(P_limit / I_DS_max), log10(V_DS_max), 100);
I_power_limit = P_limit ./ V_power_limit;


% Plot SOA with logarithmic scales
figure;
hold on;
grid on;
title('Safe Operating Area (SOA) - Logarithmic with Shading');
xlabel('V_{DS} (Volts)');
ylabel('I_{D} (Amps)');
set(gca, 'XScale', 'log', 'YScale', 'log'); % Set logarithmic scale
xlim([0.08, V_DS_max * 1.1]); % Extend slightly beyond V_DS_max for visibility
ylim([0.1, I_DS_max * 2]);

% Calc fill area polygon points
R_I_intersect = I_DS_max*R_DS_on;
I_P_intersect = P_limit/I_DS_max;
% Handle case where current limit line is never intersected
if I_ohmic(end) < I_DS_max
    x = [0.0000000000001 0.1 V_ohmic(end)  V_DS_max V_DS_max];
    y = [0.0000000000001 I_ohmic(1) I_ohmic(end)  I_power_limit(end) 0.0000000000001];
else
    x = [0.0000000000001 0.1 R_I_intersect I_P_intersect V_DS_max V_DS_max];
    y = [0.0000000000001 I_ohmic(1) I_DS_max I_DS_max I_power_limit(end) 0.0000000000001];
end
% Shaded safe operating area
fill(x, y, 'green','FaceAlpha',0.3, 'EdgeColor', 'none', 'DisplayName', 'Safe Operating Area');

% Plot limits
plot(V_ohmic, I_ohmic, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Ohmic Region');
plot(V_power_limit, I_power_limit, 'b--', 'LineWidth', 1.5, 'DisplayName', 'Power Limit Region');
plot(V_current_limit, I_current_limit, 'm--', 'LineWidth', 1.5, 'DisplayName', 'Current Limit Region');
plot([V_DS_max, V_DS_max], [0.1, I_DS_max * 2], 'k--', 'LineWidth', 1.5, 'DisplayName', 'Voltage Limit');

legend show;

fprintf('SOA Calculation and Plotting Complete.\n');
