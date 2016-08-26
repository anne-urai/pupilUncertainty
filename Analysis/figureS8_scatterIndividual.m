%%

clf;
if 0,
% group split, also correct and error
subplot(4,5,1); MedianSplit('pupil', 'correct');
ylim([-0.35 0.2]);
ylabel('Pupil * correct');
subplot(4,5,2); MedianSplit('pupil', 'incorrect');
set(gca, 'yaxislocation', 'right');
ylabel('Pupil * error');ylim([-0.35 0.2]);

% group split, also correct and error
subplot(4,5, 4); MedianSplit('rt', 'correct');
ylim([-0.35 0.2]);
ylabel('RT * correct');
subplot(4,5,5); MedianSplit('rt', 'incorrect');
set(gca, 'yaxislocation', 'right');
ylabel('RT * error');ylim([-0.35 0.2]);
end

subplot(441); SjCorrelation('pupil', 'correct');  %title('Correct');
ylim([-0.7 0.5]); set(gca, 'ytick', [-0.4 0 0.4]);
xlim([-0.5 0.5]); set(gca, 'xtick', [-0.4 0 0.4]);
ylabel('Pupil x correct weight');
xlabel('Choice weight');

subplot(442); SjCorrelation('pupil', 'incorrect'); %title('Incorrect');
ylim([-0.7 0.5]); set(gca, 'ytick', [-0.4 0 0.4]);
xlim([-0.5 0.5]); set(gca, 'xtick', [-0.4 0 0.4]);
ylabel('Pupil x error weight');
set(gca, 'yaxislocation', 'right');

% test between the two corr
load(sprintf('%s/Data/GrandAverage/historyweights_%s.mat', mypath, 'pupil+rt'));
y1 = dat.('correct_pupil')(:, 1);
y2 = dat.('incorrect_pupil')(:, 1);
x = dat.response(:, 1);

% one way, parametric Steiger's test
[rddiff,cilohi,p] = rddiffci(corr(x, y1), corr(x, y2), corr(y1, y2), 27, 0.05);
[p, rddiff] = permtest_correlation(x, y1, y2);
xlabel(sprintf('dr = %.3f, p = %.3f \n', rddiff, p));

% now for RT
subplot(4,4,3);  SjCorrelation('rt', 'correct');
ylim([-0.7 0.5]); set(gca, 'ytick', [-0.4 0 0.4]);
xlim([-0.5 0.5]); set(gca, 'xtick', [-0.4 0 0.4]);
ylabel('RT x correct weight');
set(gca, 'yaxislocation', 'left');
xlabel('Choice weight');

subplot(4,4,4);  SjCorrelation('rt', 'incorrect');
ylim([-0.7 0.5]); set(gca, 'ytick', [-0.4 0 0.4]);
xlim([-0.5 0.5]); set(gca, 'xtick', [-0.4 0 0.4]);
ylabel('RT x error weight');
set(gca, 'yaxislocation', 'right');

y1 = dat.('correct_rt')(:, 1);
y2 = dat.('incorrect_rt')(:, 1);
x = dat.response(:, 1);
% one way, parametric Steiger's test
[rddiff,cilohi,p] = rddiffci(corr(x, y1), corr(x, y2), corr(y1, y2), 27, 0.05);
[p, rddiff] = permtest_correlation(x, y1, y2);
fprintf('correct rt vs incorrect rt, delta rho = %.3f, p = %.3f \n', rddiff, p);
xlabel(sprintf('dr = %.3f, p = %.3f \n', rddiff, p));

if 0,
    %% also redo figure 5, model-free switching behaviour
    %% use nice shades of red and green
    clf;
    cols = cbrewer('qual', 'Set1', 8);
    cols = cols([1 2], :);
    sjCols = cbrewer('div', 'PuOr', 3);
    
    % select the two subgroups of people
    load(sprintf('%s/Data/GrandAverage/historyweights_%s.mat', mypath, 'pupil+rt'));
    alt = find(dat.response(:, 1) < 0);
    rep = find(dat.response(:, 1) > 0);
    
    nbins = 3;
    subplot(5,5,16); hold on;
    psychFuncShift_Bias('pupil', nbins, 1, alt');
    psychFuncShift_Bias('pupil', nbins, 0, alt');
    title('Alternators', 'color', sjCols(1,:));
    axisNotSoTight; set(gca, 'ytick', 0:0.05:1);
    
    subplot(5,5,17); hold on;
    psychFuncShift_Bias('pupil', nbins, 1, rep');
    psychFuncShift_Bias('pupil', nbins, 0, rep');
    title('Repeaters', 'color', sjCols(3,:));
    axisNotSoTight; set(gca, 'ytick', 0:0.05:1);
    
    
    subplot(5,5,18); hold on;
    psychFuncShift_Bias('rt', nbins, 1, alt');
    psychFuncShift_Bias('rt', nbins, 0, alt');
    title('Alternators', 'color', sjCols(1,:));
    axisNotSoTight; set(gca, 'ytick', 0:0.05:1);
    
    subplot(5,5,19); hold on;
    psychFuncShift_Bias('rt', nbins, 1, rep');
    psychFuncShift_Bias('rt', nbins, 0, rep');
    title('Repeaters', 'color', sjCols(3,:));
    axisNotSoTight; set(gca, 'ytick', 0:0.05:1);
end

print(gcf, '-dpdf', sprintf('%s/Figures/figureS_scatterIndividual.pdf', mypath));