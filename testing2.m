%%function utm_plot(lon, lat, alt)
clc
close all

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
    end
    
    
    % Plot of Altitude %
    
alt1 = (res_plot(index).x(:,1))./1000;
alt2 = (res_plot(index).x(end,1))./1000;
lon1 = rad2deg(res_plot(index).x(:,6));
lon2 = rad2deg(res_plot(index).x(end,6))
lat1 = rad2deg(res_plot(index).x(:,5));
lat2 = rad2deg(res_plot(index).x(end,5));
plot3(lon1,lat1,alt1), hold on;
plot3(lon2,lat2,alt2,'ko'), hold on;
stem3(lon1,lat1,alt1,'Marker', 'none'), hold on
stem3(lon2,lat2,alt2,'Marker','none')
geoshow('landareas.shp','FaceColor',[0.5 1 0.5]);
grid minor
 xlabel('Longitude [°]')
 ylabel('Latitude [°]')
 zlabel('Altitude [km]')
 title('Visualisation of the Altitude')
 view(40,40)
end