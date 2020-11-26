% function plotroutines(res_plot, phases)
    
% initialize plot style
% plotcol = 'k';
lsAB = ':';        lsR = '-';
plotmar = 'none';
plotlw  = 1;

% first section
plotst = lsR;
res_plot = res;

% position figure on the left side of the screen
if ishandle(1) && strcmp(get(1, 'type'), 'figure')  % if figure 1 exists
    a = get(1);
    b = get(a.Children(:));
    for ifi = 1:size(b,1)                           % dim the color of the subplots
        set(b(ifi).Children(:),'Color',[0.7 0.7 0.7])
    end
    figure(1)
else                                                % else create it
    scrsz = get(groot,'ScreenSize');
    figure('Color',[1 1 1],'Position',[10 50 scrsz(3)/2-10 scrsz(4)-135])
end

colormatrix = [ 0         0.4470    0.7410
                0.8500    0.3250    0.0980
                0.9290    0.6940    0.1250
                0.4940    0.1840    0.5560
                0.4660    0.6740    0.1880
                0.3010    0.7450    0.9330
                0.6350    0.0780    0.1840];
colindex = 1;
for ip = 1:numel(phases)
    colour_found = 0;
    if ip > 1
        for ifind = ip-1:-1:1
            if isequal(phases(ip).vehicle,phases(ifind).vehicle) == 1
                phases(ip).plotcolor = phases(ifind).plotcolor;
                colour_found = 1;
            end
        end
    end
    if colour_found == 0;
        phases(ip).plotcolor = colormatrix(colindex,:);
        colindex = colindex + 1;
    end
end

index = 0;
for ip = 1:numel(phases)
    for ine = 1:phases(ip).ne
        index=index+1;
        extracted=[];
        for itime = 1:size(res_plot(index).t,2)
            extracted(itime,:) = phases(ip).interp(res_plot(index).control,res_plot(index).t(itime));
            extracted(itime,:) = max(min(extracted(itime,:),phases(ip).cbounds(:,2)'), phases(ip).cbounds(:,1)');
        end

        if index > 1 && res_plot(index).t(1)==0
            if ine == 1 && ~isempty(phases(ip).continue_from)
                link_to=0;
                for ilink = 1:phases(ip).continue_from
                    link_to = link_to + phases(ip).ne;
                end
            else
                link_to = index-1;
            end
            res_plot(index).t = res_plot(index).t+res_plot(link_to).t(end);
            res_plot(index).control(:,1) = res_plot(index).control(:,1)+res_plot(link_to).t(end);
        end
         subplot(4,2,1),hold on
        xlabel('Time [s]')
        ylabel('AoA [deg]')
        plot (res_plot(index).t,rad2deg(extracted(:,1)),...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot([res_plot(index).t(1), res_plot(index).t(end)], rad2deg([phases(ip).cbounds(1,1), phases(ip).cbounds(1,1)]),'k--')
        plot([res_plot(index).t(1), res_plot(index).t(end)], rad2deg([phases(ip).cbounds(1,2), phases(ip).cbounds(1,2)]),'k--')
        plot(res_plot(index).control(:,1),rad2deg(res_plot(index).control(:,2)),'ko')
        plot(res_plot(index).control(end,1),rad2deg(res_plot(index).control(end,2)),'k+')
        
        subplot(4,2,2),hold on
        xlabel('Time [s]')
        ylabel('Throttle')
        plot (res_plot(index).t,max(min(extracted(:,2),1),0),...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot([res_plot(index).t(1), res_plot(index).t(end)], [phases(ip).cbounds(2,1), phases(ip).cbounds(2,1)],'k--')
        plot([res_plot(index).t(1), res_plot(index).t(end)], [phases(ip).cbounds(2,2), phases(ip).cbounds(2,2)],'k--')
        plot(res_plot(index).control(:,1),res_plot(index).control(:,3),'ko')
        plot(res_plot(index).control(end,1),res_plot(index).control(end,3),'k+')
        
        subplot(4,2,3),hold on
        xlabel('Time [s]')
        ylabel('Bank [deg]')
        plot (res_plot(index).t,rad2deg(extracted(:,3)),...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot([res_plot(index).t(1), res_plot(index).t(end)], rad2deg([phases(ip).cbounds(3,1), phases(ip).cbounds(3,1)]),'k--')
        plot([res_plot(index).t(1), res_plot(index).t(end)], rad2deg([phases(ip).cbounds(3,2), phases(ip).cbounds(3,2)]),'k--')
        plot(res_plot(index).control(:,1),rad2deg(res_plot(index).control(:,4)),'ko')
        plot(res_plot(index).control(end,1),rad2deg(res_plot(index).control(end,4)),'k+')

        subplot(4,2,4),hold on
        xlabel('Time [s]')
        ylabel('Relative velocity [km/s]')
        plot (res_plot(index).t,(res_plot(index).x(:,2))./1000,...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot(res_plot(index).t(end),res_plot(index).x(end,2)/1000,'k+')

        subplot(4,2,5),hold on
        xlabel('Time [s]')
        ylabel('Relative FPA [deg]')
        plot (res_plot(index).t,rad2deg((res_plot(index).x(:,3))),...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot(res_plot(index).t(end),rad2deg(res_plot(index).x(end,3)),'k+')
        
        subplot(4,2,6),hold on
        xlabel('Time [s]')
        ylabel('Mass [ton]')
        plot (res_plot(index).t,(res_plot(index).x(:,7))./1000,...
            'Color', phases(ip).plotcolor,'Marker',plotmar,'LineWidth',plotlw,'LineStyle',plotst)
        plot(res_plot(index).t(end),(res_plot(index).x(end,7))./1000,'k+')
    end
end