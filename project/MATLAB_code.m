clc; clear all; close all;

data = readtable('survey_data.xlsx');

distance = data.Distance_from_School_km_;
screen_time = data.Screen_Time_hours_day_;
extracurricular = data.Extracurricular_Activity_hours_week_;
cgpa = data.CGPA;


figure;
subplot(3, 1, 1);
scatter(distance, cgpa, 'filled');
xlabel('Distance from School (km)');
ylabel('CGPA');
title('CGPA vs Distance from School');
grid on;

subplot(3, 1, 2);
scatter(screen_time, cgpa, 'filled');
xlabel('Screen Time (hours/day)');
ylabel('CGPA');
title('CGPA vs Screen Time');
grid on;

subplot(3, 1, 3);
scatter(extracurricular, cgpa, 'filled');
xlabel('Extracurricular Activity (hours/week)');
ylabel('CGPA');
title('CGPA vs Extracurricular Activity');
grid on;

% Regression analysis
n = length(cgpa);
A = [ones(n, 1), distance, screen_time, extracurricular];

sA = A' * A;
sB = A' * cgpa;
coefficients = inv(sA) * sB;

fprintf('Intercept: %.4f\n', coefficients(1));
fprintf('Coefficient for Distance from School: %.4f\n', coefficients(2));
fprintf('Coefficient for Screen Time: %.4f\n', coefficients(3));
fprintf('Coefficient for Extracurricular Activity: %.4f\n', coefficients(4));

predicted_cgpa = A * coefficients;
residuals = cgpa - predicted_cgpa;
RMSE = sqrt(mean(residuals .^ 2));
fprintf('RMSE: %.4f\n', RMSE);

feature_names = {'Intercept', 'Distance', 'Screen Time', 'Extracurricular'};
feature_importance = abs(coefficients);
figure;
bar(feature_importance);
set(gca, 'XTickLabel', feature_names);
title('Feature Importance');
ylabel('Coefficient Absolute Value');
grid on;


figure;
scatter(1:n, cgpa, 'filled');
hold on;
plot(1:n, predicted_cgpa, 'r', 'LineWidth', 1);
xlabel('Student Index');
ylabel('CGPA');
title('Observed vs Predicted CGPA');
legend('Observed CGPA', 'Predicted CGPA');
grid on;
