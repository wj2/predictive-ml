function [ ] = visualizeMID( res, m, n )
jkns = res.jackknifes;
for i = 1:size(jkns, 2)
    knife = jkns{1};
    figure; hold on;
    title(strcat('jkn ', num2str(i)));
    imagesc(reshape(knife.v_sta, m, n));
    colormap gray;
    colorbar;
    hold off;
    
    mids = knife.mid;
    for j = 1:size(knife.mid, 2)
        mid = mids{j};
        figure; hold on;
        tit = strcat('jkn ', num2str(i), '; mid ', num2str(j));
        suptitle(tit);
        subplot(1, 2, 1); hold on;
        imagesc(reshape(mid.v_train_best, m, n));
        colormap gray;
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        xlim([1, n]);
        ylim([1, m]);
        hold off;
        
        subplot(1, 2, 2); hold on;
        imagesc(reshape(mid.v_test_best, m, n));
        colormap gray;
        set(gca, 'XTickLabel', []);
        set(gca, 'YTickLabel', []);
        xlim([1, n]);
        ylim([1, m]);
        hold off;        
        figfile = sprintf('../present/figs/mid-noisres%i-%j.png', i, j);
        print(gcf, '-dpng', '-r300', figfile);
    end
end
end

