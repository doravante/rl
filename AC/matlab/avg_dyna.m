clear all;
close all;

path = make_save_folder('dyna');

episodes = 200;
trials = 25;
power_of_two = 12;

axis_limits = [0,episodes,-6000,0];

parfor_progress(trials*(power_of_two+1));
for power=0:power_of_two
    step = 2^power;
    
    cr = zeros(trials,episodes);
    rmse = zeros(trials,episodes);

    parfor i=1:trials
        [~, ~, cr(i,:), rmse(i,:)] = dyna_pendulum('mode', 'episode', 'episodes', episodes, 'steps', step);
        parfor_progress;
    end

    figure;
    t = strcat('dyna-', num2str(step), '-', num2str(trials), '-iterations-', num2str(episodes), '-episodes');
    h = errorbaralpha(mean(cr), 1.96.*std(cr)./sqrt(trials), 'Title', t, 'Rendering', 'opaque', 'Axis', axis_limits);
    saveas(h, strcat(path, t), 'png');
    save(strcat(path,t), 'cr');
    
    figure;
    t = strcat('dyna-rmse-', num2str(step), '-', num2str(trials), '-iterations-', num2str(episodes), '-episodes');
    h = errorbaralpha(mean(rmse), 1.96.*std(rmse)./sqrt(trials), 'Title', t, 'Rendering', 'opaque');
    saveas(h, strcat(path, t), 'png');
    save(strcat(path,t), 'rmse');
    
    h = figure;
    t = strcat('dyna-', num2str(step), '-', num2str(trials), '-iterations-', num2str(episodes), '-episodes-curves');
    title(t);
    axis(axis_limits);
    xlabel('Trials');
    ylabel('Average reward');
    hold on;
    for i=1:trials
        plot(cr(i,:));
    end
    hold off;
    saveas(h, strcat(path, t), 'png');
end
parfor_progress(0);
